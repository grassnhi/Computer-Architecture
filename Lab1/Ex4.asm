.data
string: .asciiz "Please enter 5 different integer numbers:\n"
result: .asciiz "Reverse: "

.text
main:
    # Print string
    li $v0, 4
    la $a0, string
    syscall

    # Read ints
    li $v0, 5
    syscall
    move $s0, $v0

    li $v0, 5
    syscall
    move $s1, $v0

    li $v0, 5
    syscall
    move $s2, $v0

    li $v0, 5
    syscall
    move $s3, $v0

    li $v0, 5
    syscall
    move $s4, $v0

    # Print reverse:
    li $v0, 4
    la $a0, result
    syscall

    addi $a0, $s4, 0
    li $v0, 1 
	syscall 

    addi $a0, $s3, 0
    li $v0, 1 
	syscall 

    addi $a0, $s2, 0
    li $v0, 1 
	syscall 

    addi $a0, $s1, 0
    li $v0, 1 
	syscall 

    addi $a0, $s0, 0
    li $v0, 1 
	syscall 

    # Exit
    li $v0, 10
    syscall