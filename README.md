# MiniRV-Pipe
A lightweight instruction-driven FPGA pipeline inspired by RISC-V
## Project Motivation

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

## Instruction Set

## Hazard Handling Strategy

## Performance Result

## Design Trade-offs
