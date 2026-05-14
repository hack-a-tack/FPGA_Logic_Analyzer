"""
MODULE: la_host.py
FUNCTION: Python script for capturing, receiving and converting logic analyzer data into a csv/vcd file.
DATE: 2026-05-04 (YYYY-MM-DD)
LAST MODIFIED: 2026-05-14

NOTES
- HostConfig is a data container only.
- All functions are top-level functions.
- VCD export available for waveform illustration.
- Modes
-- capture: capture data
-- read: transfer data to host (csv/vcd)
-- capture-read: normal mode (full operation + produce files)
---- csv file written by default; optional vcd file
-- raw: send raw opcode (doesn't have to be A0 (CAPTURE) or A1 (READ)) to test system error response
-- capture-twice: do two captures back-to-back. If sufficiently fast, returns error because capture already taking place
-- self-test: bring-up/diagnostics mode (prove the whole chain works and make failures obvious)
---- csv file and vcd files only written if explicit flags added when running the script in self-test mode
"""


import argparse
import csv
import sys
import time
from dataclasses import dataclass

import serial
from serial.tools import list_ports
from typing import Optional

# Protocol constants
CAPTURE = 0xA0
READ    = 0xA1

OK      = 0x55
DONE    = 0x77
HEADER  = 0x99
ERROR   = 0xEE

DEFAULT_NUM_SAMPLES = 4096
DEFAULT_SAMPLE_RATE_HZ = 24_000_000

DEFAULT_TIMEOUT_S = 1.0
DEFAULT_SELFTEST_TIMEOUT_S = 5.0


@dataclass
class HostConfig:
    port: str
    baud: int
    timeout_s: float
    num_samples: int
    sample_rate_hz: int


def read_exact(ser: serial.Serial, n: int, timeout_s: float) -> bytes:
    """Read exactly n bytes or raise TimeoutError."""
    deadline = time.time() + timeout_s
    out = bytearray()
    while len(out) < n and time.time() < deadline:
        chunk = ser.read(n - len(out))
        if chunk:
            out.extend(chunk)
        else:
            time.sleep(0.001)
    if len(out) != n:
        raise TimeoutError(f"Timeout reading {n} bytes (got {len(out)})")
    return bytes(out)


def read_one(ser: serial.Serial, timeout_s: float) -> int:
    b = read_exact(ser, 1, timeout_s)
    return b[0]


def expect_byte(ser: serial.Serial, expected: int, timeout_s: float, label: str) -> None:
    got = read_one(ser, timeout_s)
    if got != expected:
        raise RuntimeError(f"{label}: expected 0x{expected:02X}, got 0x{got:02X}")


def send_cmd(ser: serial.Serial, opcode: int) -> None:
    ser.write(bytes([opcode]))
    ser.flush()
    

def send_raw_opcode(ser: serial.Serial, hex_str: str):
    value = int(hex_str, 16)
    ser.write(bytes([value]))
    ser.flush()
    return ser.read(1, timeout_s)


def do_capture(ser: serial.Serial, cfg: HostConfig) -> None:
    send_cmd(ser, CAPTURE)
    expect_byte(ser, OK, cfg.timeout_s, "CAPTURE/OK")
    expect_byte(ser, DONE, cfg.timeout_s, "CAPTURE/DONE")
    
    
def capture_twice_fast(ser: serial.Serial):
    ser.write(bytes([CAPTURE, CAPTURE]))
    ser.flush()
    
    # Read whatever comes back
    resp = ser.read(4)
    return resp


def do_read(ser: serial.Serial, cfg: HostConfig) -> bytes:
    send_cmd(ser, READ)

    first = read_one(ser, cfg.timeout_s)
    if first == ERROR:
        raise RuntimeError("READ: device returned ERROR (0xEE) - data not ready?")
    if first != HEADER:
        raise RuntimeError(f"READ: expected HEADER 0x{HEADER:02X}, got 0x{first:02X}")

    data = read_exact(ser, cfg.num_samples, cfg.timeout_s)
    return data
    

def print_read_summary(data: bytes, n: int = 16) -> None:
    if not data:
        print("Read 0 bytes")
        return
    
    head = data[:n]
    print(f"Read {len(data)} bytes")
    print("First bytes:", head.hex(" "))
    uniques = set(data)
    print(f"Unique byte values: {len(uniques)}")
    print(f"Min/Max byte: 0x{min(data):02X} / 0x{max(data):02X}")

    # quick frequency peek (top 5)
    from collections import Counter
    c = Counter(data)
    top = c.most_common(5)
    print("Top values:", ", ".join([f"0x{b:02X}({cnt})" for b, cnt in top]))


def write_csv(path: str, data: bytes) -> None:
    with open(path, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["index", "value"])
        for i, b in enumerate(data):
            w.writerow([i, b])


def write_vcd(path: str, data: bytes, sample_rate_hz: int) -> None:
    """Writes an 8-channel VCD (LA0(LSB) ... LA7(MSB)) from byte samples."""
    if sample_rate_hz <= 0:
        raise ValueError("sample_rate_hz must be > 0")

    # Use 1ns timescale. We'll round timestamps to integer ns.
    # At 24 MHz, period ~41.666... ns -> rounding introduces jitter of <=0.5ns, which is fine for viewing.
    sample_period_ns = 1e9 / float(sample_rate_hz)

    # VCD identifiers must be short unique tokens. We'll use ASCII chars.
    ids = {
        0: "a",
        1: "b",
        2: "c",
        3: "d",
        4: "e",
        5: "f",
        6: "g",
        7: "h",
    }

    def bit(sample: int, i: int) -> int:
        return (sample >> i) & 0x1

    with open(path, "w", newline="") as f:
        # Header
        f.write("$date\n")
        f.write(f"  {time.strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write("$end\n")
        f.write("$version\n  la_host.py VCD export\n$end\n")
        f.write("$timescale 1ns $end\n")
        f.write("$scope module logic_analyzer $end\n")
        for i in range(8):
            f.write(f"$var wire 1 {ids[i]} LA{i} $end\n")
        f.write("$upscope $end\n")
        f.write("$enddefinitions $end\n")

        # Initial values at t=0
        f.write("#0\n")
        first = data[0] if data else 0
        for i in range(8):
            f.write(f"{bit(first, i)}{ids[i]}\n")

        # Emit only changes (compact VCD)
        prev = first
        for n in range(1, len(data)):
            cur = data[n]
            if cur == prev:
                continue
            t_ns = int(round(n * sample_period_ns))
            f.write(f"#{t_ns}\n")
            diff = cur ^ prev
            for i in range(8):
                if (diff >> i) & 1:
                    f.write(f"{bit(cur, i)}{ids[i]}\n")
            prev = cur


def open_serial(cfg: HostConfig) -> serial.Serial:
    ser = serial.Serial(
        port=cfg.port,
        baudrate=cfg.baud,
        bytesize=serial.EIGHTBITS,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        timeout=0.01,           # non-blocking-ish; we do deadlines ourselves
        write_timeout=cfg.timeout_s,
    )
    
    time.sleep(0.1)
    ser.reset_input_buffer()
    ser.reset_output_buffer()
    return ser


def do_self_test(ser: serial.Serial, cfg: HostConfig, out_csv: Optional[str], out_vcd: Optional[str]) -> None:
    """
    Self-test = capture-read + verbose step-by-step prints.
    By default: does not write files unless out_csv/out_vcd are provided.
    """
    print(f"[self-test] Port={cfg.port} Baud={cfg.baud} Timeout={cfg.timeout_s}s Samples={cfg.num_samples}")

    print("[self-test] Sending CAPTURE (0xA0)...")
    send_cmd(ser, CAPTURE)
    print("[self-test] Waiting for OK (0x55)...")
    expect_byte(ser, OK, cfg.timeout_s, "SELFTEST/CAPTURE/OK")
    print("[self-test] OK received.")

    print("[self-test] Waiting DONE (0x77)...")
    expect_byte(ser, DONE, cfg.timeout_s, "SELFTEST/CAPTURE/DONE")
    print("[self-test] DONE received.")

    print("[self-test] Sending READ (0xA1)...")
    send_cmd(ser, READ)

    first = read_one(ser, cfg.timeout_s)
    if first == ERROR:
        raise RuntimeError("[self-test] READ returned ERROR (0xEE) - data not ready?")
    if first != HEADER:
        raise RuntimeError(f"[self-test] READ expected HEADER 0x{HEADER:02X}, got 0x{first:02X}")
    print("[self-test] HEADER received.")

    data = read_exact(ser, cfg.num_samples, cfg.timeout_s)
    print_read_summary(data)

    # Optional outputs
    if out_csv:
        write_csv(out_csv, data)
        print(f"[self-test] Wrote CSV: {out_csv}")
    if out_vcd:
        write_vcd(out_vcd, data, cfg.sample_rate_hz)
        print(f"[self-test] Wrote VCD: {out_vcd}")


def spam_capture(ser: serial.Serial) -> None:
    while True:
        ser.write(bytes([CAPTURE]))
        ser.flush()
        time.sleep(0.1)


def list_serial_ports() -> None:
    ports = list_ports.comports()
    if not ports:
        print("No serial ports found.")
        return
    for p in ports:
        # p.device like "COM7", p.description like "USB-SERIAL CH340"
        print(f"{p.device}\t{p.description}")


def main(argv: list[str]) -> int:
    p = argparse.ArgumentParser(description="FPGA Logic Analyzer Host (CSV + optional VCD)")
    p.add_argument("--port", default="COM3", help="Serial port (e.g., COM3)")
    p.add_argument("--baud", type=int, default=921600, help="Baud rate")
    p.add_argument("--timeout", type=float, default=DEFAULT_TIMEOUT_S,
                   help="Timeout in seconds for each major step (increase for slow systems)")
    p.add_argument("--samples", type=int, default=DEFAULT_NUM_SAMPLES,
                   help="Number of bytes to read after HEADER")
                   
    p.add_argument("--csv", default="capture.csv", help="Output CSV path")
    p.add_argument("--vcd", default=None,
                   help="Optional VCD output path (e.g., capture.vcd). If set, writes VCD too.")
    p.add_argument("--samplerate", type=int, default=DEFAULT_SAMPLE_RATE_HZ,
                   help="Sample rate in Hz for VCD timestamps (default 24e6)")
                   
    p.add_argument("--list-ports", action="store_true", help="Lists serial ports and exit")
    
    p.add_argument("mode", nargs="?", choices=["capture", "read", "capture-read", "raw", "capture-twice", "spam-capture", "self-test"], help="Operation mode")
    p.add_argument("value", nargs="?")
    args = p.parse_args(argv)
    
    if args.list_ports:
        list_serial_ports()
        return 0
    
    if args.mode is None:
        p.error("mode is reauired unless --list-ports is used")
       
    effective_timeout = args.timeout
    if args.mode == "self-test" and args.timeout == DEFAULT_TIMEOUT_S:
        effective_timeout = DEFAULT_SELFTEST_TIMEOUT_S

    cfg = HostConfig(
        port=args.port,
        baud=args.baud,
        timeout_s=effective_timeout,
        num_samples=args.samples,
        sample_rate_hz=args.samplerate
    )

    try:
        with open_serial(cfg) as ser:        
            if args.mode == "capture":
                do_capture(ser, cfg)
                print("Capture: OK + DONE received.")
                
            elif args.mode == "read":
                data = do_read(ser, cfg)
                print_read_summary(data)
                write_csv(args.csv, data)
                if args.vcd:
                    write_vcd(args.vcd, data, cfg.sample_rate_hz)
                print(f"Read: wrote {len(data)} bytes to {args.csv}" + (f" and {args.vcd}" if args.vcd else ""))
            
            elif args.mode == "capture-read":
                do_capture(ser, cfg)
                data = do_read(ser, cfg)
                print_read_summary(data)
                write_csv(args.csv, data)
                if args.vcd:
                    write_vcd(args.vcd, data, cfg.sample_rate_hz)
                print(f"Capture+Read: wrote {len(data)} bytes to {args.csv}" + (f" and {args.vcd}" if args.vcd else ""))
               
            elif args.mode == "raw":
                if args.value is None:
                    p.error("raw mode requries a hex value, e.g. raw B0")
                else:
                    resp = send_raw_opcode(ser, args.value, cfg.timeout_s)
                    print("RX:", resp.hex(" "))
            
            elif args.mode == "capture-twice":
                resp = capture_twice_fast(ser)
                print("RX:", resp.hex(" "))
                
            elif args.mode == "spam-capture":
                spam_capture(ser)
            
            else:  # self-test
                out_csv = args.csv if ("--csv" in argv) else None
                out_vcd = args.vcd if ("--vcd" in argv) else None
                do_self_test(ser, cfg, out_csv=out_csv, out_vcd=out_vcd)
                print("[self-test] PASS")
                
        return 0
        
    except (serial.SerialException, TimeoutError, RuntimeError, ValueError) as e:
        print(f"ERROR: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))