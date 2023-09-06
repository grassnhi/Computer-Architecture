.data
array: .space 40 # An array with 10 int elements
string: .asciiz "Please enter 10 integer numbers.\n"

.text
main:
    # Print string
    li $v0, 4
    la $a0, string
    syscall

    # Load array and calculate sum ($t0)
    la $t0, array
    li $s0, 0
    li $t1, 0           
    li $t2, 10

loop: 
    beq $t1, $t2, print
    li $v0, 5
    syscall
    sw $v0, 0($t0) 
    add $s0, $s0, $v0
    addi $t0, $t0, 4
	addi $t1, $t1, 1
    j loop
    
print:
    addi $a0, $s0, 0

    li $v0, 1 
    syscall

    # Exit 
    li $v0, 10          
    syscall