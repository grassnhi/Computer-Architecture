.data
string: .asciiz "Please enter a postitive integer number:\n"
wrong: .asciiz "Wrong number! Exit Program...\n"
result: .asciiz "Fibonacci sequence: "
space: .asciiz " "

.text
main:
    li $v0, 4
    la $a0, string
	syscall

    li $v0, 5 
	syscall 
	move $s0, $v0 # $s0 = n

    blt $s0, 1, error

    li $t0, 0
    li $t1, 1
    
    # 1st fibo number
    li $v0, 1 
	move $a0, $t1
	syscall

    li $t2, 1 # i = 1

fibo:
    beq $t2, $s0, exit
    add $s1, $t0, $t1 # c = a + b

    # space
    li $v0, 4
	la $a0, space 
	syscall

    # Print
	li $v0, 1
	move $a0, $s1 
	syscall

    # move value and i++
    move $t0, $t1 
	move $t1, $s1 
	addi $t2, $t2, 1

	j fibo

error:
    li $v0, 4
    la $a0, wrong
	syscall
    
    j exit

exit:
    li $v0, 10
    syscall