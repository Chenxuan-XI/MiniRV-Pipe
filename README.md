# MiniRV-Pipe

**A Lightweight Instruction-Driven FPGA Pipeline (RISC-V Inspired)**

---

## Overview

**MiniRV-Pipe** is a lightweight, educational FPGA project that implements a
**RISC-V–inspired 5-stage pipeline CPU core**.

The project focuses on **micro-architecture clarity, explicit pipeline design,
and FPGA-oriented engineering trade-offs**, rather than full ISA completeness
or high performance.

**Goal:**
Build a clean, modular pipeline that is easy to reason about, simulate, and extend
with hazards, forwarding, and performance analysis.

---

## Design Philosophy

* **Clarity over completeness**
  A minimal instruction set keeps the focus on pipeline behavior.

* **Explicit stage responsibility**
  Each pipeline stage has a single, well-defined role.

* **FPGA-oriented design**
  Timing behavior, signal ownership, and debuggability are prioritized.

---

## Project Development Stages

### Stage 0 — Monolithic CPU (Concept Exploration)

A non-pipelined CPU used to understand the full instruction execution flow:

* Fetch → Decode → Execute → Memory → Write-Back
* Custom Tiny RV-like instruction format
* Separation of control path and data path
* Register file timing behavior clarified

> This stage serves as a **conceptual baseline** and is not targeted for FPGA deployment.

---

### Stage 1 — Pipelined Implementation

Transition to a **5-stage RISC-V–inspired pipeline**:

```
IF → ID → EX → MEM → WB
```

Focus areas:

* Clean modular boundaries
* Explicit pipeline registers
* Correct data and control propagation

#### Implemented Components

* **Instruction Set**

  * Minimal Tiny RV-like ISA (ADD, SUB, AND, LOAD, STORE)
  * Fixed 32-bit instruction format
  * Enumerated opcode and ALU operation definitions

* **Instruction Fetch (IF)**

  * Program Counter with PC + 4 update
  * Instruction ROM initialized from hex file

* **Register File**

  * 32 × 32-bit registers
  * Dual-read, single-write
  * x0 hardwired to zero
  * Parameterized sync/async read behavior

* **Execute & Memory Path**

  * ALU computation
  * Effective address calculation
  * EX/MEM and MEM/WB pipeline registers

* **Write-Back (WB)**

  * ALU vs memory data selection
  * Register write-enable generation

---

### Stage 2 - LOAD / STORE Pipeline Test & RAW Hazard

#### Test Program

```verilog
// ADD  x1, x0, x0   ; x1 = 0
mem[0] = 32'h0080_0000;

// ADDI x2, x1, 7    ; x2 = 7
mem[1] = 32'h3104_0007;

// STORE x2 -> MEM[2]  (byte address = 8)
mem[2] = 32'h9000_4008;

// LOAD x3 <- MEM[2]
mem[3] = 32'h8180_0008;
```

> Data memory is **byte-addressed** and internally implemented as a **word array**
> (`mem[addr[9:2]]`), therefore accessing `MEM[2]` requires `addr = 8`.

#### Observed Behavior

* `ADDI x2` correctly writes back `x2 = 7`
* `STORE` writes to the correct memory address
* `LOAD x3` reads back `0` instead of `7`

Debug output from data memory:

```
DMEM WRITE: addr=2 data=0
```

#### Root Cause: RAW Hazard

Instruction sequence:

```
ADDI  x2, x1, 7
STORE x2, [addr]
```

In the current 5-stage pipeline (IF → ID → EX → MEM → WB):

* `ADDI` writes back in the **WB stage**
* `STORE` reads `rs2` in the **ID stage**
* No forwarding or hazard detection is implemented

As a result, `STORE` reads the old value of `x2` (`0`), which leads to incorrect memory data.

This is a **classic Read-After-Write (RAW) hazard**, not a functional bug.

#### Debugging Method

The issue was located by adding `$display` statements at key stages:

* **ID stage**: to observe `rs2_val` during `STORE`
* **Data memory**: to confirm actual write address and data

This confirmed that the address path was correct, while the stored data was stale.

#### Temporary Solution

To validate the datapath correctness, **NOPs were inserted** between `ADDI` and `STORE`:

```verilog
    initial begin
        wait(rst_n == 1);

        // ADD x1, x0, x0   ; x1 = 0
        dut.u_if.rom_pc.mem[0] = 32'h0080_0000;

        // ADD x2, x1, 7    ; x1 = 0
        dut.u_if.rom_pc.mem[1] = 32'h3104_0007;

        // NOP
        dut.u_if.rom_pc.mem[2] = 32'h0000_0000;
        dut.u_if.rom_pc.mem[3] = 32'h0000_0000;
        dut.u_if.rom_pc.mem[4] = 32'h0000_0000;

        // STORE x2 -> MEM[2] (mem[i] ← address = i * 4)
        dut.u_if.rom_pc.mem[5] = 32'h9000_4008;

        // LOAD x3 <- MEM[2]
        dut.u_if.rom_pc.mem[6] = 32'h8180_0008;

        $display("[TB] Instruction memory initialized");

    end
```

After inserting NOPs:

Time    PC        WB_WE  WB_RD  WB_WDATA
--------------------------------------
0       00000000  0      0      00000000
55000   00000004  0      0      00000000
65000   00000008  0      0      00000000
75000   0000000c  0      0      00000000
85000   00000010  1      1      00000000
95000   00000014  1      2      00000007
105000  00000018  0      0      00000000
115000  0000001c  0      0      00000000
125000  00000020  0      0      00000000
135000  00000024  0      0      00000000
145000  00000028  1      3      00000007
155000  0000002c  0      x      00000000


---

### Stage 3 — Hazard Handling & Performance (Planned)

* Data hazard detection
* Forwarding paths (EX/MEM, MEM/WB)
* Load-use hazard handling
* Basic performance analysis (CPI, stall impact)

---

## Pipeline Architecture

### Overview

MiniRV-Pipe implements a classic **5-stage pipeline** with explicit inter-stage
registers:

* **IF** — Instruction Fetch
* **ID** — Instruction Decode & Register Read
* **EX** — ALU & Address Calculation
* **MEM** — Data Memory Access
* **WB** — Register Write-Back

All pipeline state is stored explicitly, enabling clear timing analysis and debugging.

---

### Stage Responsibilities (Summary)

* **IF**
  Fetch instruction from ROM, update PC (PC + 4)

* **ID**
  Decode instruction fields, read register operands, generate immediates

* **EX**
  Perform ALU operations, compute memory addresses, resolve forwarding

* **MEM**
  Read/write data memory for LOAD/STORE instructions

* **WB**
  Write ALU or memory results back to the register file

---

### Pipeline Diagram

![MiniRV Pipeline](docs/minirv_pipeline.png)

The diagram shows the essential data paths and pipeline registers.
Complex control logic (branches, exceptions) is intentionally omitted.

---

## Instruction Set

### Supported Instructions

| Instruction | Type | Description          |
| ----------- | ---- | -------------------- |
| ADD         | R    | rd = rs1 + rs2       |
| ADDI        | I    | rd = rs1 + imm       |
| SUB         | R    | rd = rs1 - rs2       |
| AND         | R    | rd = rs1 & rs2       |
| LOAD        | I    | rd = MEM[rs1 + imm]  |
| STORE       | S    | MEM[rs1 + imm] = rs2 |

For NOP operation, it is first implemmented as an architectural NOP instead of an explicit opcode NOP. 
NOPs are currently implemented as ADD x0, x0, x0, which has no architectural side effects.

---

### Instruction Format

All instructions use a fixed 32-bit encoding:

```
[31:28] opcode
[27:23] rd
[22:18] rs1
[17:13] rs2
[12:0]  imm
```

* `imm` is sign-extended
* Ignored for R-type instructions
* Used for address calculation in LOAD/STORE

