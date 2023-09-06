.data
array: .space 40 # An array with 10 int elements
string: .asciiz "Please enter 10 integer numbers:\n"

.text
main:
    # Print string
    li $v0, 4
    la $a0, string
    syscall

    # Load array and calculate sum ($t0)
    la $t0, array

    li $v0, 5 
	syscall 
	sw $v0, 0($t0) 
	move $t1, $v0 

    li $v0, 5
    syscall
    sw $v0, 4($t0) 
	add $t1, $t1, $v0

    li $v0, 5
    syscall
    sw $v0, 8($t0) 
	add $t1, $t1, $v0

    li $v0, 5
    syscall
    sw $v0, 12($t0) 
	add $t1, $t1, $v0

    li $v0, 5
    syscall
    sw $v0, 16($t0) 
	add $t1, $t1, $v0

    li $v0, 5
    syscall
    sw $v0, 20($t0) 
	add $t1, $t1, $v0

    li $v0, 5
    syscall
    sw $v0, 24($t0) 
	add $t1, $t1, $v0

    li $v0, 5
    syscall
    sw $v0, 28($t0) 
	add $t1, $t1, $v0

    li $v0, 5
    syscall
    sw $v0, 32($t0) 
	add $t1, $t1, $v0

    li $v0, 5
    syscall
    sw $v0, 36($t0) 
	add $t1, $t1, $v0

    # Print result
    addi $a0, $t1, 0
    li $v0, 1 
    syscall

    # Exit
    li $v0, 10
    syscall