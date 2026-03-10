# DDR Controller Verification Environment

This project implements a simplified SystemVerilog verification environment for a DDR-style memory controller.

The verification flow includes transaction generation, driving DUT inputs, monitoring DUT outputs, and scoreboard-based checking of read data.

## Verification Architecture

Generator → Driver → DUT → Monitor → Scoreboard

- **Generator** creates directed and randomized memory transactions
- **Driver** applies transactions to the DDR controller
- **Monitor** observes DUT read/write behavior
- **Scoreboard** compares observed read data against expected values

## Tools Used

- SystemVerilog
- Icarus Verilog
- GTKWave
- Ubuntu on WSL

## Repository Structure

```text
ddr-controller-verification/
├── docs/
│   └── waveform.png
├── rtl/
│   └── ddr_controller.sv
├── tb/
│   └── tb_ddr_env.sv
├── .gitignore
└── README.md
