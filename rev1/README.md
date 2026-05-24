# Revision 1

MVP FPGA logic analyzer.

## Features
- 8 digital input channels
- 4096-sample capture depth
- nominal 24 MS/s sampling
- UART readout at 921600 baud
- store-then-send architecture

## Status
Functional hardware validated.

## Key results
See measurements/processed/performance_summary.csv.

## Known limitations
- no trigger system
- no pre-trigger buffer
- no framing/checksum
- limited capture depth
- floating inputs undefined