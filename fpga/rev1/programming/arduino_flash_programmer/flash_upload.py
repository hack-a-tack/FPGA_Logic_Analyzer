"""
MODULE: flash_upload.py
FUNCTION: Python script for sending data to arduino over serial line for programming SPI flash on FPGA PCB.
DATE: 2026-05-14 (YYYY-MM-DD)

NOTES
Python sends simple binary commands over USB serial:
J = read JEDEC ID
E = erase sector
P = program page
R = read flash
Z = tri-state Arduino pins

Arduino receives those commands, performs SPI flash operations, then replies:
K        = OK
F + code = Fail with error code
"""

import argparse
import math
import struct
import sys
import time
from pathlib import Path

import serial


PAGE_SIZE = 256
SECTOR_SIZE = 4096
EXPECTED_JEDEC = bytes([0xEF, 0x40, 0x13])


def read_exact(ser: serial.Serial, n: int) -> bytes:
    data = ser.read(n)
    if len(data) != n:
        raise TimeoutError(f"Expected {n} bytes, got {len(data)}")
    return data


def expect_ok(ser: serial.Serial, action: str) -> None:
    b = read_exact(ser, 1)

    if b == b"K":
        return

    if b == b"F":
        code = read_exact(ser, 1)[0]
        raise RuntimeError(f"{action} failed, Arduino error code: {code}")

    raise RuntimeError(f"{action} failed, unexpected response: {b!r}")


def read_jedec(ser: serial.Serial) -> bytes:
    ser.write(b"J")
    expect_ok(ser, "JEDEC read")
    return read_exact(ser, 3)


def erase_sector(ser: serial.Serial, addr: int) -> None:
    ser.write(b"E" + struct.pack(">I", addr))  # ">I" means big-endian unsigned 32-bit integer
    expect_ok(ser, f"Erase sector at 0x{addr:06X}")


def program_page(ser: serial.Serial, addr: int, data: bytes) -> None:
    if len(data) > PAGE_SIZE:
        raise ValueError("Page data too long")

    if (addr & 0xFF) + len(data) > PAGE_SIZE:
        raise ValueError("Page program crosses 256-byte boundary")

    checksum = sum(data) & 0xFFFF

    packet = (
        b"P"
        + struct.pack(">I", addr)
        + struct.pack(">H", len(data))  # ">H" means big-endian unsigned 16-bit integer
        + data
        + struct.pack(">H", checksum)
    )

    ser.write(packet)
    expect_ok(ser, f"Program page at 0x{addr:06X}")


def read_flash(ser: serial.Serial, addr: int, length: int) -> bytes:
    ser.write(b"R" + struct.pack(">I", addr) + struct.pack(">H", length))
    expect_ok(ser, f"Read at 0x{addr:06X}")
    return read_exact(ser, length)


def tristate_programmer(ser: serial.Serial) -> None:
    # Tells Arduino to stop driving SPI pins.
    # Important before releasing FPGA reset. You do not want Arduino and FPGA both connected as active bus masters.
    ser.write(b"Z")
    expect_ok(ser, "Tri-state programmer pins")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("port", help="Serial port, e.g. COM7 or /dev/ttyACM0")
    parser.add_argument("binfile", help="Raw SPI flash .bin file")
    parser.add_argument("--baud", type=int, default=115200)
    parser.add_argument("--yes", action="store_true", help="Skip confirmation prompt")
    args = parser.parse_args()

    bitstream = Path(args.binfile).read_bytes()
    file_size = len(bitstream)

    sectors_needed = math.ceil(file_size / SECTOR_SIZE)
    pages_needed = math.ceil(file_size / PAGE_SIZE)

    print(f"File: {args.binfile}")
    print(f"Size: {file_size} bytes")
    print(f"Sectors to erase: {sectors_needed}")
    print(f"Pages to program: {pages_needed}")

    if not args.yes:
        answer = input("This will erase/program flash from address 0x000000. Continue? [y/N] ")
        if answer.lower() != "y":
            print("Aborted.")
            return 1

    with serial.Serial(args.port, args.baud, timeout=10) as ser:
        # Open USB serial connection to Arduino
        # Pro Micro resets when serial port opens.
        time.sleep(2.5)
        ser.reset_input_buffer()
        ser.reset_output_buffer()

        print("\nReading JEDEC ID...")
        jedec = read_jedec(ser)
        print("JEDEC:", " ".join(f"{b:02X}" for b in jedec))

        if jedec != EXPECTED_JEDEC:
            raise RuntimeError(f"Unexpected JEDEC ID: {jedec.hex(' ')}")

        print("\nErasing sectors...")
        for i in range(sectors_needed):  # erase only the sectors needed for the file, not the whole chip
            addr = i * SECTOR_SIZE
            print(f"Erase sector {i + 1}/{sectors_needed} at 0x{addr:06X}")
            erase_sector(ser, addr)

        print("\nProgramming pages...")
        for page_idx, addr in enumerate(range(0, file_size, PAGE_SIZE), start=1):
            chunk = bitstream[addr:addr + PAGE_SIZE]
            print(f"Program page {page_idx}/{pages_needed} at 0x{addr:06X}, len={len(chunk)}")
            program_page(ser, addr, chunk)

        print("\nVerifying readback...")
        for page_idx, addr in enumerate(range(0, file_size, PAGE_SIZE), start=1):
            expected = bitstream[addr:addr + PAGE_SIZE]
            actual = read_flash(ser, addr, len(expected))

            if actual != expected:
                for i, (a, e) in enumerate(zip(actual, expected)):
                    if a != e:
                        fail_addr = addr + i
                        print(f"Mismatch at 0x{fail_addr:06X}: read 0x{a:02X}, expected 0x{e:02X}")
                        return 2
                print(f"Mismatch near page at 0x{addr:06X}")
                return 2

            if page_idx % 32 == 0 or page_idx == pages_needed:
                print(f"Verified {page_idx}/{pages_needed} pages")

        print("\nTri-stating Arduino SPI pins...")
        tristate_programmer(ser)

    print("\nPASS: Flash programmed and verified.")
    print("Now release CRESET_B and check CDONE.")
    return 0


if __name__ == "__main__":
    sys.exit(main())