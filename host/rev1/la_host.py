"""
MODULE: la_host.py
FUNCTION: Python script for capturing, receiving and converting logic analyzer data into a csv file.
DATE: 2026-04-11 (YYYY-MM-DD)
"""

import argparse
import csv
import sys
import time
from dataclasses import dataclass

import serial


# Protocol constants
CAPTURE = 0xA0
READ    = 0xA1

OK      = 0x55
DONE    = 0x77
HEADER  = 0x99
ERROR   = 0xEE

DEFAULT_NUM_SAMPLES = 4096


@dataclass
class HostConfig:
    port: str
    baud: int
    timeout_s: float
    num_samples: int


def read_exact(ser: serial.Serial, n: int, timeout_s: float) -> bytes:
    """Read exactly n bytes or raise TimeoutError."""
    deadline = time.time() + timeout_s
    out = bytearray()
    while len(out) < n and time.time() < deadline:
        chunk = ser.read(n - len(out))
        if chunk:
            out.extend(chunk)
        else:
            # tiny sleep avoids busy loop on some drivers
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


def do_capture(ser: serial.Serial, cfg: HostConfig) -> None:
    send_cmd(ser, CAPTURE)
    expect_byte(ser, OK, cfg.timeout_s, "CAPTURE/OK")

    # Capture is ~170us, but give margin (USB + firmware latency)
    expect_byte(ser, DONE, cfg.timeout_s, "CAPTURE/DONE")


def do_read(ser: serial.Serial, cfg: HostConfig) -> bytes:
    send_cmd(ser, READ)

    # Either HEADER, or ERROR if not ready
    first = read_one(ser, cfg.timeout_s)
    if first == ERROR:
        raise RuntimeError("READ: device returned ERROR (0xEE) - data not ready?")
    if first != HEADER:
        raise RuntimeError(f"READ: expected HEADER 0x{HEADER:02X}, got 0x{first:02X}")

    data = read_exact(ser, cfg.num_samples, cfg.timeout_s)
    return data


def write_csv(path: str, data: bytes) -> None:
    with open(path, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["index", "value"])
        for i, b in enumerate(data):
            w.writerow([i, b])


def open_serial(cfg: HostConfig) -> serial.Serial:
    ser = serial.Serial(
        port=cfg.port,
        baudrate=cfg.baud,
        bytesize=serial.EIGHTBITS,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        timeout=0.01,  # non-blocking-ish; we do our own deadline
        write_timeout=cfg.timeout_s,
    )
    # Clear stale bytes
    ser.reset_input_buffer()
    ser.reset_output_buffer()
    return ser


def main(argv: list[str]) -> int:
    p = argparse.ArgumentParser(description="FPGA Logic Analyzer Host (CSV dump)")
    p.add_argument("--port", default="COM3", help="Serial port (e.g., COM3)")
    p.add_argument("--baud", type=int, default=921600, help="Baud rate")
    p.add_argument("--timeout", type=float, default=1.0,
                   help="Timeout in seconds for each major step (increase for slow systems)")
    p.add_argument("--samples", type=int, default=DEFAULT_NUM_SAMPLES,
                   help="Number of bytes to read after HEADER")
    p.add_argument("--out", default="capture.csv", help="Output CSV path")
    p.add_argument("mode", choices=["capture", "read", "capture-read"], help="Operation mode")

    args = p.parse_args(argv)
    cfg = HostConfig(port=args.port, baud=args.baud, timeout_s=args.timeout, num_samples=args.samples)

    try:
        with open_serial(cfg) as ser:
            if args.mode == "capture":
                do_capture(ser, cfg)
                print("Capture: OK + DONE received.")
            elif args.mode == "read":
                data = do_read(ser, cfg)
                write_csv(args.out, data)
                print(f"Read: wrote {len(data)} bytes to {args.out}")
            else:
                do_capture(ser, cfg)
                data = do_read(ser, cfg)
                write_csv(args.out, data)
                print(f"Capture+Read: wrote {len(data)} bytes to {args.out}")
        return 0
    except (serial.SerialException, TimeoutError, RuntimeError) as e:
        print(f"ERROR: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))