# DDR Controller Verification Environment

A simplified SystemVerilog verification environment built to validate the functionality of a DDR-style memory controller.

The project demonstrates a structured verification flow using **Generator → Driver → Monitor → Scoreboard**, enabling automated checking of read/write memory transactions.

---

## Project Objective

The goal of this project is to demonstrate how a verification environment can systematically validate memory controller functionality by:

- generating stimulus
- driving DUT inputs
- observing DUT behavior
- checking correctness automatically

This mirrors the basic structure used in real hardware verification flows.

---

## Verification Architecture
# DDR Controller Verification Environment

A simplified SystemVerilog verification environment built to validate the functionality of a DDR-style memory controller.

The project demonstrates a structured verification flow using **Generator → Driver → Monitor → Scoreboard**, enabling automated checking of read/write memory transactions.

---

## Project Objective

The goal of this project is to demonstrate how a verification environment can systematically validate memory controller functionality by:

- generating stimulus
- driving DUT inputs
- observing DUT behavior
- checking correctness automatically

This mirrors the basic structure used in real hardware verification flows.

---

## Verification Architecture
Generator → Driver → DUT → Monitor → Scoreboard



**Generator**
- Produces directed and randomized memory transactions.

**Driver**
- Applies generated transactions to the DDR controller interface.

**Monitor**
- Observes DUT signals and records transactions occurring during simulation.

**Scoreboard**
- Compares observed DUT outputs with expected results to determine pass/fail.

---

## Tools Used

| Tool | Purpose |
|-----|------|
| SystemVerilog | Design and verification environment |
| Icarus Verilog | Simulation compiler |
| GTKWave | Waveform visualization |
| Ubuntu (WSL) | Development environment |

---

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

---

## Simulation Flow

### Compile
iverilog -g2012 -Wall -o build/ddr_verif_env.out rtl/ddr_controller.sv tb/tb_ddr_env.sv

### Run Simulation
vvp build/ddr_verif_env.out


### Open Waveform
gtkwave build/ddr_verif_env.vcd

---

## Verification Scenarios

The verification environment validates multiple memory behaviors:

- Empty memory read returning `0`
- Directed write/read transaction at address `0x10`
- Directed write/read transaction at address `0x20`
- Memory overwrite at the same address
- Randomized write/read transactions

All verification tests passed successfully.

---

## Simulation Waveform

Below is a GTKWave snapshot showing memory read/write activity during simulation.

![DDR Verification Waveform](docs/waveform.png)

**Note**

Initial `X` values represent unknown signal states at simulation startup before reset and stimulus are applied. These are expected in digital simulation.

---

## Key Takeaways

This project demonstrates:

- creation of a structured verification environment
- automated checking using a scoreboard
- transaction-based testing
- debugging using waveform analysis

These concepts are foundational for modern hardware verification methodologies.
