# DDR Controller Verification Environment

This project implements a simplified SystemVerilog verification environment for a DDR-style memory controller.

The environment verifies memory read/write operations using a structured testbench composed of a generator, driver, monitor, and scoreboard.

---

## Verification Architecture

Generator → Driver → DUT → Monitor → Scoreboard

**Generator**
- Creates directed and randomized memory transactions

**Driver**
- Drives read/write signals into the DDR controller

**Monitor**
- Observes DUT transactions

**Scoreboard**
- Compares observed read data with expected values

---

## Tools Used

- SystemVerilog
- Icarus Verilog
- GTKWave
- Ubuntu (WSL)

---

## Repository Structure
ddr-controller-verification/
├── docs/
│ └── waveform.png
├── rtl/
│ └── ddr_controller.sv
├── tb/
│ └── tb_ddr_env.sv
├── .gitignore
└── README.md

---

## Simulation

Compile:
iverilog -g2012 -Wall -o build/ddr_verif_env.out rtl/ddr_controller.sv tb/tb_ddr_env.sv


Run simulation:


vvp build/ddr_verif_env.out


Open waveform:


gtkwave build/ddr_verif_env.vcd

---

## Verification Results

The environment successfully verified:

- Empty memory read returns `0`
- Directed write/read transaction at address `0x10`
- Directed write/read transaction at address `0x20`
- Overwrite behavior at the same address
- Randomized write/read transactions

All verification tests passed.

---

## Simulation Waveform

The waveform below shows read and write transactions captured during simulation.

![DDR Verification Waveform](docs/waveform.png)

Note: Initial `X` values represent unknown signal states during simulation startup before reset and stimulus are applied.
