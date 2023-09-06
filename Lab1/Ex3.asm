.data
string: .asciiz "Please enter the value of 4 variables a, b c, and d:\n"
fResult: .asciiz "f = "
gResult: .asciiz "\ng = "

.text
main:
    # Print string
    li $v0, 4
    la $a0, string
    syscall

    # Read a
    li $v0, 5
    syscall

    move $s0, $v0

    # Read b
    li $v0, 5
    syscall

    move $s1, $v0

     # Read c
    li $v0, 5
    syscall

    move $s2, $v0

    # Read d
    li $v0, 5
    syscall

    move $s3, $v0

    # Calculate f = (a + b) − (c − d − 2)
    li $v0, 4
    la $a0, fResult
    syscall

    add $t0, $s0, $s1
    sub $t1, $s2, $s3
    addi $t1, $t1, -2
    sub $t0, $t0, $t1

    addi $a0, $t0, 0
    
    li $v0, 1
    syscall

    # Calculate g = (a + b) * 3 - (c + d) * 2
    li $v0, 4
    la $a0, gResult
    syscall

    add $t0, $s0, $s1
    add $t0, $t0, $t0
    add $t0, $t0, $t0
    add $t1, $s2, $s3
    add $t1, $t1, $t1
    add $t1, $t1, $t1
    sub $t0, $t0, $t1

    addi $a0, $t0, 0
    
    li $v0, 1
    syscall

    # Exit
	li $v0, 10 
	syscall