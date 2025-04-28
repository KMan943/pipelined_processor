# MIPS 5-Stage Pipelined Processor

This project implements a **MIPS 32-bit 5-stage pipelined processor** in **VHDL**, simulating basic pipelined execution of MIPS subset instructions with hazard handling.

## Pipeline Stages
- **IF (Instruction Fetch)**
- **ID (Instruction Decode / Register Fetch)**
- **EX (Execute / ALU)**
- **MEM (Memory Access)**
- **WB (Write Back)**

Each stage has its dedicated pipeline registers:
- `IF/ID`
- `ID/EX`
- `EX/MEM`
- `MEM/WB`

## Features
- Implements a MIPS subset, can be found in the `implemented_isa` file
- 32 general-purpose registers (Register File)
- Sign-extension for immediate values
- ALU control logic for instruction-specific operations
- Branch resolution in MEM stage
- **Basic stalling** for load-use data hazards
- **No forwarding** (yet) — stalls are inserted when needed
- Data memory (read/write support)
- Jump and branch handling

## How to Simulate
1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/mips-pipelined-processor.git
   ```
2. Open the project_1.xpr file in vivado
3. Run the simulation
4. Observe the waveforms to verify pipeline behavior.

## Important Notes
- **Stalls**: Only stalling is implemented (no data forwarding yet). You must stall if an instruction depends on the result of a previous `lw`.
- **Zero register**: `$zero` (register 0) is hard-wired to 0.

## TODO / Future Work
- Add full **data forwarding** logic
- Add support for **hazard detection** module (dynamic stall insertion)
- Implement **pipeline flushing** for control hazards (branches)


