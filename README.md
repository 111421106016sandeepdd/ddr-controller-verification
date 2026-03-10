# DDR Controller Verification Environment

This project implements a simplified SystemVerilog verification environment for a DDR-style memory controller.

The verification architecture includes a transaction generator, driver, monitor, and scoreboard to validate read/write operations.

## Verification Architecture

Generator → Driver → DUT → Monitor → Scoreboard

- Generator creates memory transactions
- Driver applies them to the DDR controller
- Monitor observes DUT behavior
- Scoreboard checks correctness of read data

## Simulation

Compile:

iverilog -g2012 -Wall -o build/ddr_verif_env.out rtl/ddr_controller.sv tb/tb_ddr_env.sv

Run simulation:

vvp build/ddr_verif_env.out

Open waveform:

gtkwave build/ddr_verif_env.vcd

## Simulation Waveform

The waveform below shows read and write transactions verified through the environment.

![DDR Verification Waveform](docs/waveform.png)
