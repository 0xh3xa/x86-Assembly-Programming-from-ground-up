# System Call Numbers
.equ SYS_EXIT, 1
.equ SYS_READ, 3
.equ SYS_WRITE, 4
.equ SYS_OPEN, 5
.equ SYS_CLOSE, 6
.equ SYS_BAK, 45

# System Call Interrupt Number
.equ LINUX_SYSCALL_INT, 0x80

# Standard File Descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# Common Status Code
.equ END_OF_FILE, 0

# Options for open (%ecx)
# Look at /usr/include/asm/fcnt.h
.equ O_RDONLY, 0                                # Open read only
.equ O_CREATE_WRONLY_TRUNC, 03101               # Open create write only trunc
.equ CREATE_IF_N_EXIST_O_WR, 0101               # Create if not exist and open for write

# Permissions (%edx)
.equ PERM_NORMAL, 0666

# Stack frame args
.equ ST_ARGC, 0                                 # number of arguments
.equ ST_ARGV_0, 4                               # name of the program
.equ ST_ARGC_1, 8                               # file name
