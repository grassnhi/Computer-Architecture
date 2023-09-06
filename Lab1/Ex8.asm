.data
array: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
string: .asciiz "Please enter an integer numbers i (0 < i < 10):\n"

.text
main:
    # Print string
    li $v0, 4
    la $a0, string
    syscall

    # Read
    li, $v0, 5
    syscall

    # Multiply index by 4 to get offset
    sll $v0, $v0, 2
    lw $t1, array($v0)

    # Print result
    addi $a0, $t1, 0
    li $v0, 1 
    syscall

    # Exit
    li $v0, 10
    syscall