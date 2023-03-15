#PURPOSE: 	This program aims to use shared libc and dynamic linker

#INPUT:  	none

#OUTPUT:   none
.section .data
    hello_world:
        .ascii "Hello World!\n"

.section .text
.globl main

main:
    pushl $hello_world
    call printf

    pushl $0
    call exit
