.data
odd: .asciiz "\nSum of odd element: "
even: .asciiz "\nSum of even element: "
array: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 

.text
main:
    # Initialize
    li $s0, 0  
    li $s1, 0  
    la $t0, array         
    li $t1, 0           
    li $t2, 10  

    loop: 
        beq $t1, $t2, print
        lw $t3, 0($t0)
        add $s0, $s0, $t3
        addi $t0, $t0, 4
        lw $t4, 0($t0)
        add $s1, $s1, $t4
        addi $t0, $t0, 4
        addi $t1, $t1, 2
        j loop
    
    print: 
        li $v0, 4
        la $a0, even
        syscall

        addi $a0, $s0, 0
        li $v0, 1 
        syscall

        li $v0, 4
        la $a0, odd
        syscall

        addi $a0, $s1, 0
        li $v0, 1 
        syscall
    
    # Exit
    li $v0, 10
    syscall
