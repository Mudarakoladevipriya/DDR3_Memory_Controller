# Simplified DDR3 Memory Controller

## Overview

This project implements a simplified DDR3 Memory Controller using Verilog. The controller accepts read and write requests, generates simplified DDR3 control commands, manages memory operations, and performs periodic refresh operations.

The design is functionally verified using Xilinx Vivado Simulator.

---

## Features

- Read operation support
- Write operation support
- Address mapping
- Simplified DDR3 command generation
- Command Finite State Machine (FSM)
- Timing control
- Refresh controller
- Periodic refresh operation
- DDR3 memory model for simulation
- Functional verification using testbenches
- Automated PASS/FAIL checking

---

## Project Architecture

The top-level module integrates the following modules:

```text
                 +----------------------+
                 |  DDR3 Controller Top |
                 +----------+-----------+
                            |
       +--------------------+--------------------+
       |                    |                    |
       v                    v                    v
+--------------+    +----------------+   +------------------+
| Address      |    | Command FSM    |   | Timing Controller|
| Mapper       |    |                |   |                  |
+--------------+    +----------------+   +------------------+
                            |
                            v
                    +----------------+
                    | Refresh        |
                    | Controller     |
                    +----------------+
                            |
                            v
                    +----------------+
                    | DDR3 Memory    |
                    | Model          |
                    +----------------+
