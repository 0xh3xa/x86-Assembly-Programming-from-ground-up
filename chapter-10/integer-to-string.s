#%ecx will hold the count of characters processed
#%eax will hold the current value
#%edi will hold the base (10)

.equ ST_VALUE, 8
.equ ST_BUFFER, 12

.globl integer2string
.type integer2string, @function

integer2string:
    pushl %ebp
    movl %esp, %ebp

    movl $0, %ecx
    movl ST_VALUE(%ebp), %eax

    movl $10, %edi                              #base (10) in %edi
    
    conversion_loop:
        movl $0, %edx                           #reset %edx to zero

        divl %edi                               #div %eax / %edi

        addl $'0', %edx                         #%edx has the reminder, convert to ascii value
        
        pushl %edx

        incl %ecx                               #incremenet counter

        cmpl $0, %eax
        je end_conversion_loop

        jmp conversion_loop

        end_conversion_loop:
            movl ST_BUFFER(%ebp), %edx         #Get the pointer to the buffer in %edx

        copy_reversing_loop:
            popl %eax
            movb %al, (%edx)
            
            decl %ecx
            incl %edx                           #Go to the next byte

            cmpl $0, %ecx
            je end_copy_conversion_loop

            jmp copy_reversing_loop

        end_copy_conversion_loop:
            movb $0, (%edx)                     #Now write a null byte and return

            movl %ebp, %esp
            popl %ebp
            ret
