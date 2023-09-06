.data
filename: .asciiz "E:\\text.txt"
read: .space 100
.text
main:
    # Declare string
    li $v0, 9 # system call code for dynamic allocation
    li $a0, 100 # $a0 contains number of bytes to allocate
    syscall
    move $s0, $v0 # move address in heap to $s0

    # Open the file
    li $v0, 13       # system call for open file
    la $a0, filename # input file name
    li $a1, 0        # Open for reading (flags are 0: read, 1: write)
    li $a2, 0        # mode is ignored
    syscall          # Open a file (file descriptor returned in $v0)
    move $s6, $v0    # Save the file descriptor

    # Read from the file
    li $v0, 14       # System call for read
    move $a0, $s6    # File descriptor
    move $a1, $s0    # Address of buffer to read into
    li $a2, 100      # Hardcoded buffer length
    syscall          # Read file

    # Close the file
    li $v0, 16       # System call for close file
    move $a0, $s6     # File descriptor to close
    syscall          # Close file

    # Print data read from the file
    li $v0, 4 
    move $a0, $s0
    syscall

    # Exit program
    li $v0, 10         
    syscall
