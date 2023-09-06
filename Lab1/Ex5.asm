.data
array: .word 1,2,3,4,5,6,7,8,9,10

.text
main:
    # Load and Sum
    la $t0, array
    lw $t1, 0($t0)
    lw $t2, 4($t0)
    add $t1, $t1, $t2
    lw $t2, 8($t0)
    add $t1, $t1, $t2
    lw $t2, 12($t0)
    add $t1, $t1, $t2
    lw $t2, 16($t0)
    add $t1, $t1, $t2
    lw $t2, 20($t0)
    add $t1, $t1, $t2
    lw $t2, 24($t0)
    add $t1, $t1, $t2
    lw $t2, 28($t0)
    add $t1, $t1, $t2
    lw $t2, 32($t0)
    add $t1, $t1, $t2
    lw $t2, 36($t0)
    add $t1, $t1, $t2
    
    # print
    addi $a0, $t1, 0
    li $v0, 1 
	syscall

    # Exit
    li $v0, 10
    syscall
    