# MiniRV-Pipe
A lightweight instruction-driven FPGA pipeline inspired by RISC-V
## Project Motivation

## Project Development Stage

This project is developed incrementally, with each stage focusing on a clear architectural goal. The emphasis is on **micro-architecture understanding, clean pipeline design, and FPGA-oriented engineering trade-offs**, rather than ISA completeness.

---

### Stage 0 — Monolithic CPU (Concept & Exploration)

The initial stage focused on understanding the complete instruction execution flow in a **monolithic (non-pipelined) CPU architecture**.
Rather than targeting performance, this stage aimed to clarify how instructions move through fetch, decode, execute, memory access, and write-back as a single control flow.

Key outcomes of this stage include:

* Definition of a custom Tiny RV-like instruction format
* Clear separation of control path and data path
* Understanding of register file read/write timing
* Establishing the architectural foundation for pipelining

This stage served as a conceptual baseline and was not intended for FPGA deployment.

---

### Stage 1 — First Pipelined Implementation

This stage transitions the design to a **RISC-V–inspired 5-stage pipeline**:

```
IF → ID → EX → MEM → WB
```

The focus is on **clean modular boundaries, explicit pipeline registers, and correct data/control propagation**.

#### Implemented Components

* **Instruction Set Definition**

  * Custom Tiny RV-like ISA with a minimal instruction subset
  * Explicit instruction field partitioning (opcode, rd, rs1, rs2, imm)
  * Enumerated opcode and ALU operation types for readability and scalability

* **Instruction Fetch (IF) Stage**

  * Program Counter (PC) register with sequential update (PC + 4)
  * Instruction ROM preloaded from a hex file
  * Standalone simulation verified

* **Register File**

  * 32 × 32-bit general-purpose registers
  * Dual-read, single-write architecture
  * Register x0 hardwired to zero
  * Parameterized synchronous/asynchronous read behavior

* **Write-Back (WB) Stage**

  * Correct selection between ALU result and memory load data
  * Generation of write-enable and destination register signals
  * Clean interface to the register file

* **EX/MEM Pipeline Register**

  * ALU result
  * Store data
  * Destination register index
  * Load indicator

* **MEM/WB Pipeline Register**

  * Memory read data
  * ALU result
  * Destination register index
  * Write-back control signals

This structured interface design ensures that future features such as hazard detection and forwarding can be integrated without large-scale refactoring.

---

### Design Philosophy

* **Clarity over completeness**
  A minimal instruction set is used to keep the focus on pipeline behavior.

* **Explicit stage responsibility**
  Each pipeline stage has a single, well-defined role.

* **FPGA-oriented engineering**
  Signal ownership, timing behavior, and debuggability are prioritized over feature count.

---

### Stage 2 — Hazard Handling & Performance Analysis

---

## Pipeline Architecture
### Overview

MiniRV-Pipe implements a lightweight 5-stage instruction-driven pipeline inspired by RISC-V microarchitecture principles.  
The design focuses on clarity, minimalism, and timing-aware FPGA implementation, rather than full ISA completeness.

The pipeline consists of the following stages:
IF → ID → EX → MEM → WB


Each stage performs a single well-defined task, and all inter-stage state is stored explicitly in pipeline registers.

---

### Instruction Fetch (IF)

The IF stage maintains the program counter (PC) and fetches instructions from a read-only instruction memory (ROM).  
The PC increments sequentially (PC + 4). Control-flow changes such as branch or jump are intentionally omitted to reduce design complexity.

**Outputs to IF/ID pipeline register:**
- Fetched instruction  
- (Optional) PC value for debugging

---

### Instruction Decode (ID)

The ID stage decodes the instruction fields and reads source operands from the register file.  
Immediate values for memory instructions are extracted and sign-extended in this stage.

**Key responsibilities:**
- Instruction field decoding (rs1, rs2, rd)
- Register file read
- Immediate generation
- Instruction classification (ALU / LOAD / STORE)

**Outputs to ID/EX pipeline register:**
- Source register values (`rs1_val`, `rs2_val`)
- Register indices (`rs1`, `rs2`, `rd`)
- Immediate value (`imm`)
- Operation type (`op` or equivalent control flags)

---

### Execute (EX)

The EX stage performs arithmetic and address calculations using the ALU.  
It is also the central point for data hazard resolution, where forwarding logic selects the correct operand sources.

**Key responsibilities:**
- ALU computation
- Effective address calculation for LOAD/STORE
- Forwarding resolution for source operands
- Preparation of store data

**Outputs to EX/MEM pipeline register:**
- ALU result (`alu_res`)
- Store data (after forwarding)
- Destination register index (`rd`)
- Control flags (`is_load`, `is_store`, `regwrite`)

---

### Memory Access (MEM)

The MEM stage interfaces with data memory (BRAM).  
Depending on the instruction type, it performs a memory read (LOAD) or write (STORE).  
ALU-only instructions bypass memory without side effects.

**Key responsibilities:**
- Data memory read/write
- Passing execution results forward

**Outputs to MEM/WB pipeline register:**
- Memory read data (`mem_data`)
- ALU result (`alu_res`)
- Destination register index (`rd`)
- Write-back control signals

---

### Write Back (WB)

The WB stage updates the architectural register file.  
The write-back value is selected between the ALU result and memory data.

**Key responsibilities:**
- Result selection (ALU vs memory)
- Register file write-back

---

![MiniRV Pipeline](docs/minirv_pipeline.png)
### Pipeline Diagram Explanation

The diagram illustrates the simplified 5-stage pipeline organization of MiniRV-Pipe.
Only the essential data paths and pipeline registers are shown, while complex control
logic (e.g., branch handling) is intentionally omitted.

Each pipeline stage is isolated by an explicit pipeline register, ensuring clear
separation of responsibilities and enabling straightforward timing analysis.

**Stage-level data flow overview:**

- **IF (Instruction Fetch)**  
  Fetches instructions sequentially from instruction ROM using the program counter (PC).
  The PC is updated by a fixed increment (PC + 4).

- **ID (Instruction Decode)**  
  Decodes instruction fields and reads source operands from the register file.
  Immediate values are generated in this stage and forwarded to execution.

- **EX (Execute)**  
  Performs ALU operations and effective address calculation for memory instructions.
  This stage also resolves data hazards using forwarding paths from later pipeline stages.

- **MEM (Memory Access)**  
  Interfaces with data memory for load and store instructions.
  ALU-only instructions bypass memory access without side effects.

- **WB (Write Back)**  
  Writes results back to the architectural register file.
  The write-back value is selected between the ALU result and memory read data.

The diagram highlights how instruction data and control information flow strictly
forward through the pipeline, while forwarding paths allow recently computed results
to be reused without stalling whenever possible.

## Instruction Set
### Supported Instructions

MiniRV-Pipe implements a minimal RV-inspired instruction set focused on arithmetic
and memory operations. The supported instructions are summarized below:

| Instruction | Type | Description                |
|-------------|------|----------------------------|
| ADD         | R    | rd = rs1 + rs2             |
| SUB         | R    | rd = rs1 - rs2             |
| AND         | R    | rd = rs1 & rs2             |
| LOAD        | I    | rd = MEM[rs1 + imm]        |
| STORE       | S    | MEM[rs1 + imm] = rs2       |

---

### Instruction Format

All instructions are encoded using a fixed 32-bit format. The bit fields are defined
as follows:
[31:28] opcode
[27:23] rd
[22:18] rs1
[17:13] rs2
[12:0] imm

- `opcode` specifies the instruction operation type.
- `rd` is the destination register index.
- `rs1` and `rs2` are source register indices.
- `imm` is a sign-extended immediate value used by memory instructions.

For R-type instructions, the `imm` field is ignored.  
For LOAD and STORE instructions, `imm` is used for effective address calculation.

## Hazard Handling Strategy

## Performance Result

## Design Trade-offs
