.data
array: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

.text
main:
	la $a0, array 
	li $a1, 10 # size 

	li $v0, 0 # sum = 0

	jal sum

	# print
    move $a0, $v0
    li $v0, 1 
	syscall 
	
    # exit
	li $v0, 10 
	syscall

sum:
    # stack for size, arr and return address
	addi $sp, $sp, -12 
	sw $a1, 0($sp)	
	sw $a0, 4($sp) 
	sw $ra, 8($sp) 
	
	# Base case k = 1
	lw $t0, 0($a0)
	add $v0, $v0, $t0 
	beq $a1, 1, return 
	
	# Recursion sum(arr+1, k-1)
	addi $a0, $a0, 4 
	addi $a1, $a1, -1 # k--
	jal sum
	
return:
    lw $ra, 8($sp) 
	lw $a0, 4($sp) 
	lw $a1, 0($sp) 
	addi $sp, $sp, 12
	jr $ra