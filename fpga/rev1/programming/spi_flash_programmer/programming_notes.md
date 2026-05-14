# Arduino SPI Flash Programmer Notes

## Usage

This folder contains the temporary Arduino-based SPI flash programmer used to program the Winbond W25Q40CL configuration flash for the iCE40UP5K board.

Programming flow:

```bash
python flash_upload.py COMx bitstream/top_bitmap.bin
```

Replace COMx with the Arduino Pro Micro serial port shown in Device Manager. On Linux/macOS this may look like /dev/ttyACM0 or /dev/ttyUSB0

## Hardware setup
- FPGA board powered normally
- FPGA held in reset using the CRESET_B DIP switch
- Arduino GND connected to PCB GND
- Voltage dividers used on Arduino-driven SPI lines:
  - CS#
  - MOSI
  - SCK
- MISO connected directly from flash/PCB to Arduino MISO
- Arduino SPI pins disconnected after programming before releasing FPGA reset


## Expected result

The Python script should:

1. Read JEDEC ID: EF 40 13
2. Erase 26 sectors
3. Program 407 pages
4. Verify full readback
5. Tri-state Arduino SPI pins

After disconnecting the programmer and releasing CRESET_B, the FPGA should configure from SPI flash and CDONE should indicate DONE.


## Observed programmed-board voltages

Measured after FPGA PCB was programmed and CRESET_B released:

- CRESET_B: 3.32 V
  - Other LEDs momentarily flickered when measuring CRESET_B
- CDONE: 1.95 V
  - CDONE LED faintly lit
  - Note: Rev1 CDONE LED circuit loads the open-drain CDONE signal incorrectly; this should be corrected in Rev2.