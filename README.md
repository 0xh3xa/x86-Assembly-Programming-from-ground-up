## x86-Assembly-Programming-from-ground-up

Assembly code from the book Programming form group up by Jonathan Bartlett includes code for each chapter.

The book follows AT&T dialect assembly.

### How to run?

You can use `run-asm. sh` bash file to assemble, and link, both using the following suffix `asm`, `link`, `all`

```
./run-asm.sh chapter-10/integer-to-string.s asm
```

### Quick Guide

> Chapter 1

Introduction to programming in general, defining what are machine code, assembly, and high-level language.

> Chapter 2

Computer architecture, taking about CPU (ALU, registers, fetch-decode-execution cycle), RAM, data types, and address space.

Data accessing modes include the following:

|Mode|Description|
|--------------|--------------|
|Immediate mode|`mov $1, %eax`|
|Register addressing mode|instruction contains register to access|
|Direct addressing mode|instruction contains the memory address to access|
|Indexed addressing mode|instructions contain a  memory address to access and specify an index register to offset that address|
|Indirect addressing mode|instruction contains a register that includes a pointer to where the data should be accessed|
|Base pointer addressing mode|similar to indirect addressing, but you also include a number called the offset to add to the register's value before using it for lookup|

>  Chapter 3

First, programming in the assembly includes existing status and how to assemble and link the code.

> Chapter 4

Introduction to functions and programs like factorial and power.

> Chapter 5

Dealing with files and I/O operations include: file descriptor, creating the file, open file for reading, writing, or appending.

> Chapter 6

Records and how to read/write to records.

> Chapter 7

Develop robust programs and handle errors in the program's flow.

> Chapter 8

Libraries and how to link them.

> Chapter 9

Dynamic memory allocates and deallocates.
