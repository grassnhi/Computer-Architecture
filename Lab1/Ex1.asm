.data 
string: .asciiz "Please enter an integer number:\n"
result: .asciiz "Increase by 1: "

.text 
main:
    # print string
	li $v0, 4 
	la $a0, string 
	syscall
	
    # Read int
	li $v0, 5 
	syscall 
	
    # Increase
	addi $t0, $v0, 1 
	
    # Print int++
    li $v0, 4
    la $a0, result
    syscall

    addi $a0, $t0, 0 
    
	li $v0, 1 
	syscall 
	
    # Exit
	li $v0, 10 
	syscall