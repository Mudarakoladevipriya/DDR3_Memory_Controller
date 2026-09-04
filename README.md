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



## Test Cases

The following test cases were used to verify the simplified DDR3 Memory Controller:

| Test Case | Operation | Address | Data | Expected Result |
|-----------|-----------|---------|------|-----------------|
| Test 1 | Write and Read | `0x00000001` | `0x12345678` | Read data should match `0x12345678` |
| Test 2 | Write and Read | `0x00000002` | `0xA5A55A5A` | Read data should match `0xA5A55A5A` |
| Test 3 | Write and Read | `0x00000003` | `0xDEADBEEF` | Read data should match `0xDEADBEEF` |
| Test 4 | Refresh Test | — | — | Periodic refresh commands should be generated and detected |

### Simulation Results

```text
WRITE COMPLETE: Address=00000001 Data=12345678
READ PASS: Address=00000001 Expected=12345678 Actual=12345678

WRITE COMPLETE: Address=00000002 Data=a5a55a5a
READ PASS: Address=00000002 Expected=a5a55a5a Actual=a5a55a5a

WRITE COMPLETE: Address=00000003 Data=deadbeef
READ PASS: Address=00000003 Expected=deadbeef Actual=deadbeef

REFRESH COUNT = 3
REFRESH TEST PASSED

PASS COUNT = 3
FAIL COUNT = 0

ALL TESTS PASSED
                            |
                            v
                    +----------------+
                    | DDR3 Memory    |
                    | Model          |
                    +----------------+
