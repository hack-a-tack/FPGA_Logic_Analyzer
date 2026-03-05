## Project overview

(Info applies to rev. 1, update for later revisions (only final rev. matters in the README))
FPGA-based 8-channel logic analyzer implemented on iCE40UP5K. Supports 24 MHz sampling, 4096 sample depth, UART streaming and trigger logic.

Key specs:
| Spec | Value |
| ------------- | ------------- |
| FPGA | iCE40UP5K |
| Sampling channels | 8 |
| Sampling rate | 24MHz |
| Buffer | 4096 samples |
| Interface | UART |
| Programming | SPI |
| PCB | 2-layer |


## Architecture

// Note to self: block diagram, + explain modules briefly (less than a full sentence for each)

(insert block diagram)

(module overview:)
| Module  | Description |
| ------------- | ------------- |
| capture_engine.vhd | samples digital inputs |
| analyzer_fsm.vhd | manages logic analyzer state |
| send_engine.vhd | UART streaming of captured data |
| ... | ... |


## Photos / board render


## Performance metrics
(table of performance metrics)
| Metric  | Value |
| ------------- | ------------- |
| Sample rate | 24MHz |
| Buffer depth | 4096 samples |
| UART throughput | 3Mbaud |
| Capture latency | 3 cycles |
| LUT usage | *1420* |
| BRAM usage | *4* |


## How to build / simulate
(Brief instructions)


## Lessons and improvements


## Link to engineering report
For a more in-depth overview, check out the project report (add github route and link).
