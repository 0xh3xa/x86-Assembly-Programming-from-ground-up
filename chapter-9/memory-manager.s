#PURPOSE: 	Program to manage memory usage - allocates
#           and deallocates memory as requrestd
#
#Notes:     The programs using these routines will ask
#           for a certain size of memory. We actually
#           use more than that size, but we put it
#           at the beginning, before the pointer
#           we hand back. We add a size field and
#           an AVAILABLE/UNAVAILABLE marker. So, then
#           memory looks like this
#
##########################################################
##Available Marker#Size of memory#Actual memory locations#
##########################################################
#                                 ^--Returned pointer
#                                    points here
#      The pointer we return only points to the actual
#      locations requrestd to make it easier for the
#      calling program. It also allows us to change our
#      structure without the calling program having to
#      change at all.

.include "linux.s"

.section .data

    heap_begin:                                     #This points to the geginning of the memory we are managing
        .long 0

    current_break:                                  #This points to one location past the memory we are managing
        .long 0
    
    ######Structure Information######
    .equ HEADER_SIZE, 8                             #size of space for memory region header
    .equ HDR_AVAIL_OFFSET, 0                        #locaation of the available flrag in the header
    .equ HDR_SIZE_OFFSET, 4                         #location of the size field in the header

    .equ UNAVAILABLE, 0
    .equ AVAILABLE, 1

.section .text
.globl allocate_init
.type allocate_init, @function
allocate_init:
    pushl %ebp
    movl %esp, %ebp

    movl $SYS_BAK, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL_INT

    incl %eax                                       #eax has last valid address, make it refers to first invalid address

    movl %eax, current_break
    movl %eax, heap_begin

    movl %ebp, %esp
    popl %ebp
    ret

#PURPOSE: 	    This function is used to grab a section of
#               memory. It checks to see if there are any
#               free blocks, and, if not, it asks Linux
#               for a new one.
#PARAMETERS:    This function has one parameter - the size
#            of the memory block we want to allocate
#
#RETURN VALUE:
#            This function returns the address of the
#            allocated memory in %eax. If there is no
#            memory available, it will return 0 in %eax
######PROCESSING########
#
#  %ecx - hold the size of the requested memory
#         (first/only paameter)
#  %eax - current memory region being examined
#  %ebx - current break position
#  %edx - size of the current memory region
#
#We scan through each memory region starting with
#heap_begin, We look at the size of each one, and if
#it has been allocated. If it's big enough for the
#requested size, and its available, it grabs that one.
#Linux for more memory. In that case, it moves
#current_break up
.globl allocate
.type allocate, @function

.equ ST_MEMORY_SIZE, 8

allocate:
    pushl %ebp
    movl %esp, %ebp

    movl current_break, %eax                       #Check if current_break is 0 cann allocate_init
    cmpl $0, %eax
    jne end_if

    call allocate_init

    end_if:

    movl ST_MEMORY_SIZE(%ebp), %ecx
    movl heap_begin, %eax
    movl current_break, %ebx

    alloc_loop_begin:
        cmpl %ebx, %eax
        je move_break

        movl HDR_SIZE_OFFSET(%eax), %edx

        cmpl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
        je next_location

        cmpl %edx, %ecx                            #If the space is available, compare
        jle allocate_here                          #the size to the needed size. If its
                                                   #big enough, go to allocate_here
    next_location:
        addl $HEADER_SIZE, %eax                    #The total size of the memory
        addl %edx, %eax                            #region is the sum of the size
                                                   #requested (currently stored)
                                                   #in %edx), plus another 8 bytes
                                                   #for the header (4 for the
                                                   #AVAILABLE/UNAVAILABLE flag,
                                                   #and 4 for the size of the
                                                   #region). So, adding %edx and $8
                                                   #to %eax will get the address
                                                   #of tthe next memory region
        
        jmp alloc_loop_begin

    allocate_here:
        movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
        addl $HEADER_SIZE, %eax

        jmp end_allocate

    move_break:
        addl $HEADER_SIZE, %ebx
        addl %ecx, %ebx

        pushl %eax
        pushl %ecx
        pushl %ebx

        movl $SYS_BAK, %eax
        int $LINUX_SYSCALL_INT

        cmpl $0, %eax
        je error

        popl %ebx
        popl %ecx
        popl %eax

        movl %ecx, HDR_SIZE_OFFSET(%eax)
        addl $HEADER_SIZE, %eax
        movl %ebx, current_break

        jmp end_allocate

    error:
        movl $0, %eax

    end_allocate:
        movl %ebp, %esp
        popl %ebp
        ret

.globl deallocate
.type deallocate, @function

.equ ST_MEMORY_SEG, 4

deallocate:
    movl ST_MEMORY_SEG(%esp), %eax                                       #normally this is 8(%ebp), but since we didn't push %ebp or move %esp to %ebp, we can just do 4(%esp)

    subl $HEADER_SIZE, %eax                                              #get the pointer to the real begining of the memory

    movl $AVAILABLE, HDR_AVAIL_OFFSET(%eax)

    ret
