

## Project Structure
# DDR Controller Verification Environment (SystemVerilog)

## Overview

This project implements a **SystemVerilog-based verification environment** for a simplified DDR-style memory controller.  
The goal of the project is to simulate and verify memory read and write transactions using a structured verification architecture.

The verification environment generates memory transactions, drives them into the DUT, monitors responses, and validates correctness using a scoreboard.

This project demonstrates fundamental **digital verification techniques used in ASIC and FPGA development**.

---

## Objectives

- Design a structured **SystemVerilog verification environment**
- Simulate memory read and write transactions
- Validate controller behavior using automated checking
- Practice modular verification architecture used in real chip development

---

## Verification Architecture

The verification environment consists of the following components:

### Generator
Creates stimulus transactions such as memory reads and writes.

### Driver
Applies generated transactions to the DUT interface.

### Monitor
Observes DUT signals and captures activity during simulation.

### Scoreboard
Compares expected results with actual DUT outputs to verify correctness.

This modular architecture follows common verification methodology used in industry environments.

---

## Project Structure
ddr-controller-verification/
├── rtl/
│ └── ddr_controller.v
├── tb/
│ ├── generator.sv
│ ├── driver.sv
│ ├── monitor.sv
│ ├── scoreboard.sv
│ └── tb_top.sv
├── docs/
│ └── waveform.png
└── README.md


---

## Simulation Tools

- **SystemVerilog**
- **Icarus Verilog**
- **GTKWave**
- **Linux development environment**

---

## Verification Flow

1. Generator produces read/write transactions
2. Driver sends transactions to the DUT
3. Monitor observes DUT behavior
4. Scoreboard validates results
5. Waveforms are inspected for functional correctness

---

## Example Verification Scenario

Typical simulation includes:

- Write transaction to memory
- Read transaction from memory
- Scoreboard comparison of expected vs actual data
- Waveform inspection using GTKWave

---

## Learning Outcomes

Through this project the following verification concepts were practiced:

- Testbench architecture design
- Transaction generation
- Driver and monitor implementation
- Scoreboard-based checking
- Simulation debugging using waveform analysis

---

## Future Improvements

Possible enhancements to the verification environment include:

- Constrained random stimulus generation
- Functional coverage collection
- Error injection testing
- Migration to a full **UVM-based verification environment**

---

## Author

Sandeep  

