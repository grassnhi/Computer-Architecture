.data 
string: .asciiz  "Ho Chi Minh City - University of Technology"
length: .word 43 
reverse: .space 43 

.text
main:
    li $t0, 0
    lw $t1, length
    add $t1, $t1, -1

loop:   
    lb $t2, string($t1)
    sb $t2, reverse($t0)
    addi $t0, $t0, 1 
	addi $t1, $t1, -1
    beq $t0, 43, print
    j loop

print:
    li $v0, 4
	la $a0, reverse
	syscall
	
	li $v0, 10
	syscall