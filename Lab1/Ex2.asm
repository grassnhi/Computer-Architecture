.data
string: .asciiz "Please enter two integer numbers:\n"
result: .asciiz "Sum of them: "

.text
main: 
    # Print string
    li $v0, 4
    la $a0, string
    syscall

    # Read the first int
    li $v0, 5
    syscall

    # Change location to get last int
    move $t0, $v0

    # Read the second int 
    li $v0, 5
    syscall

    # Sum 2 int
    add $t0, $t0, $v0

    # Print result
    li $v0, 4
    la $a0, result
    syscall

    addi $a0, $t0, 0
    li $v0, 1 
	syscall 

    # Exit
    li $v0, 10 
	syscall