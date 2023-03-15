#PURPOSE: 	Count the characters until a numll byte is reached

#INPUT:  	The address of the character string
#OUTPUT:   Returs the count in %eax
.type count_chars, @function
.globl count_chars

.equ ST_STRING_START_ADDRESS, 8

count_chars:
    pushl %ebp
    movl %esp, %ebp

    movl $0, %ecx

    movl ST_STRING_START_ADDRESS(%ebp), %edx

    count_loop_start:
        movb (%edx), %al
        cmpb $0, %al
        je count_loop_end

        incl %ecx
        incl %edx
        jmp count_loop_start

    count_loop_end:
        movl %ecx, %eax

        movl %ebp, %esp
        popl %ebp
        ret
