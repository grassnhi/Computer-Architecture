.data
array: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

.text
main:
    la $t0, array
    li $t1, 0
    li $t2, 36

swap:  
    add $t3, $t1, $t0
    add $t4, $t2, $t0

    lw $t3, array($t3)   
    lw $t4, array($t4)
    sw $t4, array($t3)
    sw $t3, array($t4)
    addi $t1, $t1, 4
    addi $t2, $t2, -4
    bgt $t1, $t2, print
    j swap

print:
    bge $t1, 36, exit
    lw $a0, ($t0)
    li $v0, 1 
    syscall
    addi $t0, $t0, 4
    addi $t1, $t1, 4
    j print

exit:
    li $v0, 10
    syscall
