lock:
    ll $t0, 0($a0)
    bne $t0, $zero, lock
    li $t1, 1
    sc $t1, 0($a0)
    beq $t1, $zero, lock
    nop

unlock:
    sw $zero, 0($a0)

shvar:
    lock
    lw $t0, 0($a1)
    slt $t1, $t0, $a2
    beq $t1, $zero, store
    move $t0, $a2

store:
    sw $t0, 0($a1)
    unlock
    jr $ra
