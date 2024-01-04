# Simple-RISC-Processor
design and verify a simple multi cycle RISC processor in Verilog



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
6. Four instruction types (R-type, I-type, J-type, and S-type).
7. Separate data and instructions memories
8. Byte addressable memory
9. Big endian byte ordering
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
  - 10: pre-increment the base register
  - 11: post-decrement the base register


| Mode Value | Action                                |
|------------|---------------------------------------|
| 00         | `lw Rd, imm(Rs1)` # No inc/dec of the base register                   |
| 01         | `LW.PRI Rd, imm(Rs1)`  # load word pre-increment <br>     Before the address is sent to the memory, the base register is incremented <br> Reg[Rs1] = Reg[Rs1] + 4  <br>   It is incremented by four because lw loads one word and the word size is 4 bytes     |
| 01         | `LW.POI Rd, imm (Rs1)`  # load word pre-increment  # load word post-increment <br> After the address is sent to the memory, the base register is incremented  <br>   Reg[Rs1] = Reg[Rs1] + 4 |     
| 11         | `LW.POD Rd, imm (Rs1)`  # load word post-decrement <br>    After the address is sent to the memory, the base register is decremented <br>Reg[Rs1] = Reg[Rs1] - 4     |


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

#### Jump to Address in Register
| Opcode | Rd   | Unused |
|--------|------|--------|
| 6 bits | 4 bits | 22 bits |

- `jr Rd`: Jump to the target address stored in the register `Rd`.

#### Call Function from Register
| Opcode | Rd   | Unused |
|--------|------|--------|
| 6 bits | 4 bits | 22 bits |

- `call.r Rd`: Call the function whose address is stored in the register `Rd`.

### S-Type (Stack)

#### Push One
| Opcode | Rd   | 
|--------|------|
| 6 bits | 4 bits|

- `push.1 Rd`: Push one. Push the value of `Rd` on the top of the stack.

#### Push Many
| Opcode | Rd   | Rs1  |
|--------|------|------|
| 6 bits | 4 bits | 14 bits |

- `push.m Rd, Rs1`: Push many. Push the values of the registers in the range `Rd` to `Rs1` in order on the top of the stack.

#### Pop One
| Opcode | Rd   |
|--------|------|
| 6 bits | 4 bits|

- `pop.1 Rd`: Pop one. Pop the stack and store the topmost element in `Rd`.

#### Pop Many
| Opcode | Rd   | Rs1  |
|--------|------|------|
| 6 bits | 4 bits | 14 bits |

- `pop.m Rd, Rs1`: Pop many. Pop the top `(Rs1 – Rd) + 1` elements from the stack, and store the values of these elements in the registers from `Rd` to `Rs1`.
  - The topmost element is stored in `Rd`, and so on.

## Instructions’ Encoding
For simplicity, you are required to implement a subset only of this processor’s ISA. The table below shows the different instructions you are required to implement. It shows their type, the opcode value, and their meaning in RTN (Register Transfer Notation). Although the instruction set is reduced, it is still rich enough to write useful programs.



| Instr | Meaning                           | Opcode Value | Type              |
|-------|-----------------------------------|--------------|-------------------|
| AND   | `Reg(Rd) = Reg(Rs1) & Reg(Rs2)`   | 000000       | R-Type            |
| ADD   | `Reg(Rd) = Reg(Rs1) + Reg(Rs2)`   | 000001       | R-Type            |
| SUB   | `Reg(Rd) = Reg(Rs1) - Reg(Rs2)`   | 000010       | R-Type            |
| OR    | `Reg(Rd) = Reg(Rs1) I Reg(Rs2)`   | 000011       | R-Type            |
| ANDI  | `Reg(Rd) = Reg(Rs1) & Imm16`      | 000100       | I-Type            |
| ADDI  | `Reg(Rd) = Reg(Rs1) + Imm16`      | 000101       | I-Type            |
| LW    | `Reg(Rd) = Mem(Reg(Rs1) + Imm16)` | 000110       | I-Type            |
| LW.PRI| `Reg(Rd) = Mem(Reg(Rs1) + 4 + Imm16)`<br>`Reg[Rs1] = Reg[Rs1] + 4` | 000111 | I-Type |
| LW.POI| `Reg(Rd) = Mem(Reg(Rs1) + Imm16)`<br>`Reg[Rs1] = Reg[Rs1] + 4` | 001000 | I-Type |
| LW.POD| `Reg(Rd) = Mem(Reg(Rs1) + Imm16)`<br>`Reg[Rs1] = Reg[Rs1] - 4` | 001001 | I-Type |
| SW    | `Mem(Reg(Rs1) + Imm16) = Reg(Rd)` | 001010       | I-Type            |
| BGT   | If (Reg(Rd) > Reg(Rs1))<br>Next PC = PC + sign_extended(Imm16)<br>Else PC = PC + 4 | 001011 | I-Type |
| BLT   | If (Reg(Rd) < Reg(Rs1))<br>Next PC = PC + sign_extended(Imm16)<br>Else PC = PC + 4 | 001100 | I-Type |
| BEQ   | If (Reg(Rd) == Reg(Rs1))<br>Next PC = PC + sign_extended(Imm16)<br>Else PC = PC + 4 | 001101 | I-Type |
| BNE   | If (Reg(Rd) != Reg(Rs1))<br>Next PC = PC + sign_extended(Imm16)<br>Else PC = PC + 4 | 001110 | I-Type |
| JMP   | Next PC = {PC[31:26], Immediate26} | 001111       | J-Type            |
| CALL  | Next PC = {PC[31:26], Immediate26}<br>PC + 4 is pushed on the stack | 010000 | J-Type |
| RET   | Next PC = top of the stack        | 010001       | J-Type            |
| JR    | Next PC = Reg[Rs1]                 | 010010       | J-Type            |
| CALL.R| Next PC = Reg[Rs1]<br>PC + 4 is pushed on the stack | 010011 | J-Type |
| PUSH.1| Rd is pushed on the top of the stack | 010100      | S-Type            |
| PUSH.M| Registers in the range Rd to Rs1 are pushed on the stack | 010101 | S-Type |
| POP.1 | The top element of the stack is popped, and it is stored in the Rd register | 010110 | S-Type |
| POP.M | Pop the top (Rs1 – Rd) + 1 elements from the stack,<br>and store the values of these elements in the registers from Rd to Rs1.<br>The topmost element is stored in Rd, and so on. | 010111 | S-Type |


## Data Path




## Modules

# To be Added ....
