.data
array: .word 1, 2, 3, 5, 7, 9, 8, 6, 4, 0

.text
main:
	la $a0, array 
	li $a1, 10 

	jal max 

	# Print
    move $a0, $v0 
	li $v0, 1
	syscall 
	
	li $v0, 10
	syscall

max: 
    # stack for size, arr, return addr
	addi $sp, $sp, -12 
	sw $a1, 0($sp)	
	sw $a0, 4($sp) 
	sw $ra, 8($sp) 
	
	# Base case
	lw $t0, 0($a0) 
	slt $t1, $t0, $v0 
	beq $t1, 0, temp

	j jump

temp: 
    move $v0, $t0 # $v0 = temp
	
jump:
	beq $a1, 1, return 
	
	# Recursion sum(arr+1, k-1)
	addi $a0, $a0, 4 # arr++ 
	addi $a1, $a1, -1 # k--

	jal max

return: 
    lw $ra, 8($sp) 
	lw $a0, 4($sp) 
	lw $a1, 0($sp) 
	addi $sp, $sp, 12
	
	jr $ra