# Simple-RISC-Processor
design and verify a simple multi cycle RISC processor in Verilog

## Partners

```
👷[Mohammed Abed Alkareem](https://github.com/Mohammed-Abed-Alkareem)
👷‍♀️ Mona Dweikat
```


## Processor Specifications
1. The instruction size and the words size is 32 bits
2.  16 32-bit general-purpose registers: from R0 to R15.
3. 32-bit special purpose register for the program counter (PC)
4. 32-bit special purpose register for the stack pointer (SP), which points to the topmost empty element of the stack. This register is visible to the programmer.
5. The program memory layout comprises the following three segments:

- **Data Segment**
- **Code Segment**
- **Stack Segment**

    The stack segment is a Last In First Out (LIFO) data structure. The machine has explicit instructions that enable the programmer to push/pop elements on/from the stack. The stack stores the return address, registers’ values upon function calls, etc.

6. The processor has two separate physical memories, one for instructions and the other one for data. The data memory stores both the static data segment and the stack segment.
7. Four instruction types (R-type, I-type, J-type, and S-type).
8. Separate data and instructions memories
9. Word-addressable memory
10. You need to generate the required signals from the ALU to calculate the condition branch outcome (taken/ not taken). These signals might include zero, carry, overflow, etc.

## Instruction Types and Formats

As mentioned above, this ISA has four instruction formats: R-type, I-type, J-type, and S-type. These types share a common 6-bit opcode field that determines the specific operation of the instruction.

### R-Type (Register Type)

| Opcode | Rd   | Rs1  | Rs2  | Unused |
|--------|------|------|------|--------|
| 6 bits | 4 bits| 4 bits | 4 bits | 14 bits |

- 4-bit Rd: destination register
- 4-bit Rs1: first source register
- 4-bit Rs2: second source register
- 14-bit unused

### I-Type (Immediate Type)

| Opcode | Rd   | Rs1  | Immediate | Mode |
|--------|------|------|-----------|------|
| 6 bits | 4 bits | 4 bits | 16 bits  | 2 bits|

- 4-bit `Rd`: destination register
- 4-bit `Rs1`: first source register
- 4-bit `Rs2`: second source register (for R-type)
- 16-bit `Immediate`: unsigned for logic instructions, and signed otherwise.
- 2-bit `Mode`: used with load/store instructions only
  - 00: no increment/decrement of the base register
  - 01: post-increment the base register
  - 10-11: unused


| Mode Value | Action                                |
|------------|---------------------------------------|
| 00         | `lw Rd, imm(Rs1)` # No inc/dec of the base register                   |
| 01         | `LW.POI Rd, imm (Rs1)`  # load word pre-increment  # load word post-increment <br> After the address is sent to the memory, the base register is incremented  <br>   Reg[Rs1] = Reg[Rs1] + 1 |     
| 10         | Unused  |
| 11         | Unused  |


### J-Type (Jump Type)
This type includes the following instruction formats. The opcode is used to distinguish each instruction

#### Unconditional Jump
| Opcode | Jump Offset |
|--------|-------------|
| 6 bits | 26 bits     |

- `jmp L`: Unconditional jump to the target `L`.

#### Call Function
| Opcode | Jump Offset |
|--------|-----------------|
| 6 bits | 26 bits         |

- `call F`: Call the function `F`.
  - The return address is pushed onto the stack.
  - The target address is calculated by concatenating the most significant 6 bits of the current PC with the 26-bit offset.

#### Return from Function
| Opcode | Unused |
|--------|--------|
| 6 bits | 26 bits |

- `ret`: Return from a function.
  - The next PC will be the top element of the stack.


### S-Type (Stack)

#### Push One
| Opcode | Rd | Rs1  | Unused  |
|--------|-------------|--------------|------------------|
| 6 bits| 4 bits        | 4 bits        | 18 bits        |


- `push.1 Rd`: Push one. Push the value of `Rd` on the top of the stack.


#### Pop One
| Opcode | Rd | Rs1  | Unused  |
|--------|-------------|--------------|------------------|
| 6 bits| 4 bits        | 4 bits        | 18 bits        |

- `pop.1 Rd`: Pop one. Pop the stack and store the topmost element in `Rd`.



## Instructions’ Encoding
For simplicity, you are required to implement a subset only of this processor’s ISA. The table below shows the different instructions you are required to implement. It shows their type, the opcode value, and their meaning in RTN (Register Transfer Notation). Although the instruction set is reduced, it is still rich enough to write useful programs.



| Instr | Meaning                           | Opcode Value | Type              |
|-------|-----------------------------------|--------------|-------------------|
| AND   | `Reg(Rd) = Reg(Rs1) & Reg(Rs2)`   | 000000       | R-Type            |
| ADD   | `Reg(Rd) = Reg(Rs1) + Reg(Rs2)`   | 000001       | R-Type            |
| SUB   | `Reg(Rd) = Reg(Rs1) - Reg(Rs2)`   | 000010       | R-Type            |
| ANDI  | `Reg(Rd) = Reg(Rs1) & Imm16`      | 000011       | I-Type            |
| ADDI  | `Reg(Rd) = Reg(Rs1) + Imm16`      | 000100       | I-Type            |
| LW    | `Reg(Rd) = Mem(Reg(Rs1) + Imm16)` | 000101       | I-Type            |
| LW.POI| `Reg(Rd) = Mem(Reg(Rs1) + Imm16)`<br>`Reg[Rs1] = Reg[Rs1] + 4` | 000110 | I-Type |
| SW    | `Mem(Reg(Rs1) + Imm16) = Reg(Rd)` | 000111       | I-Type            |
| BGT   | If (Reg(Rd) > Reg(Rs1))<br>Next PC = PC + sign_extended(Imm16)<br>Else PC = PC + 4 | 001000 | I-Type |
| BLT   | If (Reg(Rd) < Reg(Rs1))<br>Next PC = PC + sign_extended(Imm16)<br>Else PC = PC + 4 | 001001 | I-Type |
| BEQ   | If (Reg(Rd) == Reg(Rs1))<br>Next PC = PC + sign_extended(Imm16)<br>Else PC = PC + 4 | 001010 | I-Type |
| BNE   | If (Reg(Rd) != Reg(Rs1))<br>Next PC = PC + sign_extended(Imm16)<br>Else PC = PC + 4 | 001011 | I-Type |
| JMP   | Next PC = {PC[31:26], Immediate26} | 001100       | J-Type            |
| CALL  | Next PC = {PC[31:26], Immediate26}<br>PC + 4 is pushed on the stack | 001101 | J-Type |
| RET   | Next PC = top of the stack        | 001110       | J-Type            |
| PUSH.1| Rd is pushed on the top of the stack | 001111     | S-Type            |
| POP.1 | The top element of the stack is popped, and it is stored in the Rd register | 100000 | S-Type |


## Data Path
![Data Path](/pictures/datapath.png)

## Finite State Machine
![Data Path](/pictures/StateDiagram.png)
### Signals
| Signal Name    | Signal Description                                           | Cases                              |
| --------------- | ------------------------------------------------------------ | ----------------------------------- |
| PC src          | Determines the next value of the PC                           | 0: Pc = Pc + 1<br/>1: PC = {PC[31:26], Immediate26 }<br/>2: PC = PC + sign_extended (Imm16)<br/>3: PC = top of the stack |
| Dst Reg         | Determines on which register to write                         | 0: RW = Rs1<br/>1: RW = Rd         |
| RB              | Determines the second register                                | 0: RB = Rs2<br/>1: RB = Rd         |
| En W            | Enable / disable the write on the registers                   | 0: write disabled<br/>1: write enabled |
| Write value     | Determines the value to be written on the register             | 0: write the value from stage 4 incremented by 1<br/>1: write the value from stage 5 |
| ALU src         | Determines the first input of the ALU                         | 0: B = Immediate<br/>1: B = BusB   |
| ALU op          | Determine the operation for the ALU                           | 0: AND<br/>1: ADD<br/>2: SUB        |
| Mem R           | Enable read from memory                                       | 0: disable<br/>1: enable            |
| Mem W           | Enable write to memory                                        | 0: disable<br/>1: enable            |
| WB              | Determine the return value from stage 5                       | 0: data from ALU<br/>1: data from memory |
| ext             | Determine logical or signed extension                         | 0: logical extension<br/>1: signed extension |
| new sp          | Determines the new value of the stack pointer                  | 0: same as it is<br/>1: decremented by 1<br/>2: incremented by 1 |
| stack/mem       | Determines if the address for the data to be stored in the memory or pushed in the stack | 0: calculated address of the memory<br/>1: stack pointer |
| address/data    | Determines if the data stored in the memory from the registerfile or the pc+1 | 0: data from register file<br/>1: pc +1 |



#### R-Type Instructions
| OPCODE | PC src | Dst Reg | RB | En W | Write value | ALU src | ALU op | Mem R | Mem W | WB | ext | new sp | stack/mem | address/data |
| ------ | ------ | ------- | -- | ---- | ----------- | ------- | ------ | ----- | ----- | -- | --- | ------ | --------- | ------------ |
| AND    | 0      | 1       | 0  | 1    | 1           | 0       | 0      | 0     | 0     | x  | 0   | x      | x         | x            |
| ADD    | 0      | 1       | 0  | 1    | 1           | 1       | 0      | 0     | 0     | x  | 0   | x      | x         | x            |
| SUB    | 0      | 1       | 0  | 1    | 1           | 2       | 0      | 0     | 0     | x  | 0   | x      | x         | x            |

#### I-Type Instructions

| OPCODE | PC src | Dst Reg | RB | En W | Write value | ALU src | ALU op | Mem R | Mem W | WB | ext | new sp | stack/mem | address/data |
| ------ | ------ | ------- | -- | ---- | ----------- | ------- | ------ | ----- | ----- | -- | --- | ------ | --------- | ------------ |
| ANDI   | 0      | 1       | x  | 1    | 0           | 0       | 0      | 0     | 0     | 0  | 0   | x      | x         | x            |
| ADDI   | 0      | 1       | x  | 1    | 0           | 1       | 0      | 0     | 0     | 1  | 0   | x      | x         | x            |
| LW     | 0      | 1       | x  | 1    | 0           | 1       | 1      | 1     | 0     | 1  | 0   | x      | 0         | 0            |
| LW.POI | 0      | St2:0   | St5:1 | 1 | St2:0       | St5:1   | 0      | 1     | 1     | 0  | 1   | 0      | 1         | 1            |
| SW     | 0      | x       | 1  | 0    | 1           | 0       | 1      | 0     | 1     | 0  | 0   | 0      | 1         | x            |
| BGT Taken | 2   | x       | 1  | 0    | 1           | x       | 1      | 2     | 0     | 0  | x   | 1      | x         | x            |
| BGT not-Taken | 0 | x       | 1  | 0    | 1           | x       | 1      | 2     | 0     | 0  | x   | 1      | x         | x            |
| BLT Taken | 2   | x       | 1  | 0    | 1           | x       | 1      | 2     | 0     | 0  | x   | 1      | x         | x            |
| BLT not-Taken | 0 | x       | 1  | 0    | 1           | x       | 1      | 2     | 0     | 0  | x   | 1      | x         | x            |
| BEQ Taken | 2   | x       | 1  | 0    | 1           | x       | 1      | 2     | 0     | 0  | x   | 1      | x         | x            |
| BEQ not-Taken | 0 | x       | 1  | 0    | 1           | x       | 1      | 2     | 0     | 0  | x   | 1      | x         | x            |
| BNE Taken | 2   | x       | 1  | 0    | 1           | x       | 1      | 2     | 0     | 0  | x   | 1      | x         | x            |
| BNE not-Taken | 0 | x       | 1  | 0    | 1           | x       | 1      | 2     | 0     | 0  | x   | 1      | x         | x            |

#### J-Type Instructions
| OPCODE | PC src | Dst Reg | RB | En W | Write value | ALU src | ALU op | Mem R | Mem W | WB | ext | new sp | stack/mem | address/data |
| ------ | ------ | ------- | -- | ---- | ----------- | ------- | ------ | ----- | ----- | -- | --- | ------ | --------- | ------------ |
| JMP    | 1      | x       | x  | 0    | x           | x       | x      | 0     | x     | x  | 0   | x      | x         | x            |
| CALL   | 1      | x       | x  | 0    | x           | x       | x      | 0     | x     | x  | x   | 2      | 1         | 1            |
| RET    | 3      | x       | x  | 0    | x           | x       | x      | 1     | x     | 1  | x   | 1      | 1         | x            |


#### S-Type Instructions

| OPCODE  | PC src | Dst Reg | RB | En W | Write value | ALU src | ALU op | Mem R | Mem W | WB | ext | new sp | stack/mem | address/data |
| ------- | ------ | ------- | -- | ---- | ----------- | ------- | ------ | ----- | ----- | -- | --- | ------ | --------- | ------------ |
| PUSH.1  | 0      | x       | 1  | 0    | x           | x       | x      | 0     | x     | x  | x   | 2      | 1         | 0            |
| POP.1   | 0      | 1       | x  | 1    | x           | x       | x      | 1     | x     | 1  | x   | 1      | 1         | x            |



## Modules


### Register file

- [register_file.v](/verilog_files/src/Register/registerFile.v)
  a 32 bit register file with 16 registers
- [register_file_tb.v](/verilog_files/src/Register/registerFile_tb.v)
  test bench for the register file module
- waveform
  
![register file waveform](/pictures/waves/registerFile_wave.png)

### Instruction memory

- [instruction_memory.v](./processor_modules/RiscProcessor/processor/src/instruction_fetch/InstructionMemory.v)
  a 32 bit instruction memory with 256 words
- [instruction_memory_tb.v](.processor_modules/RiscProcessor/processor/src/instruction_fetch/instruction_memory_testbench.v)
  test bench for the instruction memory module
- waveform
  ![instruction memory waveform](./assets/instruction_memory_waveform.png)

### Data memory

- [data_memory.v](./processor_modules/RiscProcessor/processor/src/data_memory/data_memory.v)
  a 32 bit data memory with 256 words (last 32 word are used as stack)

- [data_memory_tb.v](./processor_modules/RiscProcessor/processor/src/data_memory/data_memory_testbench.v)
  test bench for the data memory module

- waveform
  ![data memory waveform](./assets/data_memory_waveform.png)
![data memory stack waveform](./assets/data_memory_waveform.png)

### ALU

- [alu.v](./processor_modules/RiscProcessor/processor/src/alu/alu.v)
  a 32 bit ALU with 5 operations ( ADD, SUB, AND, SL, SR ) and 2 flags ( zero, negative )

- [alu_tb.v](./processor_modules/RiscProcessor/processor/src/alu/alu_testbench.v)
  a test bench for the ALU module that tests all operations and the flags

- waveform
  ![alu waveform](./assets/alu_tb_waveform.png)

### PC Module

- [pc_module.v](./processor_modules/RiscProcessor/processor/src/instruction_fetch/pc_module.v)
  a 32 bit program counter logic module that handles Jump/Conditional Branches/Increment/Return

- [pc_module_tb.v](./processor_modules/RiscProcessor/processor/src/instruction_fetch/pc_module_testbench.v)
  a test bench for the PC module that tests all operations

- waveform
  ![pc module waveform](./assets/pc_module_tb_waveform.png)

### Stack Module ( LIFO Memory )

- [stack.v](./processor_modules/RiscProcessor/processor/src/stack/stack.v)
  a 32 bit stack module that handles push/pop operations on Last-In-First-Out memory and has a 32 word capacity

- [stack_testbench.v](./processor_modules/RiscProcessor/processor/src/stack/stack_testbench.v)
  a test bench for the stack module that tests all operations

- waveform
  ![stack waveform](./assets/stack_testbench.png)

## Control Unit ( FSM )

- [control_unit.v](./processor_modules/RiscProcessor/processor/src/control_unit/control_unit.v)
  a control unit that handles the control signals for the processor

- [control_unit_tb.v](./processor_modules/RiscProcessor/processor/src/control_unit/control_unit_testbench.v)
  a test bench for the control unit that tests all operations

- R/I Type Arithmatic/Logical Operations Waveform
  ![control unit waveform](./assets/control_unit/arithmatic_logical_waveform.png)
- Jump/Branch Operations Waveform
  ![control unit waveform](./assets/control_unit/jump_branch_waveform.png)


# To be Added ....
