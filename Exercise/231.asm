# fib function
fib:
    # if n == 0
    beq $a0, $zero, return0
    # if n == 1
    beq $a0, 1, return1
    # decrement n
    addi $t0, $a0, -1
    # call fib(n-1)
    jal fib
    # store result in $t1
    move $t1, $v0
    # decrement n again
    addi $t0, $t0, -1
    # call fib(n-2)
    jal fib
    # add the two results
    add $v0, $t1, $v0
    # return the final result
    jr $ra
return0:
    # return 0 if n == 0
    li $v0, 0
    jr $ra
return1:
    # return 1 if n == 1
    li $v0, 1
    jr $ra


// Ver 2:
fib:
    addi $sp, $sp, -12 # allocate space on the stack
    sw $ra, 8($sp) # save the return address
    sw $a0, 4($sp) # save the input argument
    beq $a0, 0, fib_return0 # return 0 if n == 0
    beq $a0, 1, fib_return1 # return 1 if n == 1

    addi $a0, $a0, -1 # decrement n
    jal fib # recursive call to fib(n-1)

    sw $v0, 0($sp) # save fib(n-1) to the stack

    lw $a0, 4($sp) # load n
    addi $a0, $a0, -2 # decrement n
    jal fib # recursive call to fib(n-2)

    lw $t0, 0($sp) # load fib(n-1)
    add $v0, $v0, $t0 # return fib(n-1) + fib(n-2)

    lw $ra, 8($sp) # restore the return address
    addi $sp, $sp, 12 # deallocate the stack space
    jr $ra # return to the caller

fib_return0:
    li $v0, 0 # return 0
    j fib_exit

fib_return1:
    li $v0, 1 # return 1

fib_exit:
    lw $ra, 8($sp) # restore the return address
    addi $sp, $sp, 12 # deallocate the stack space
    jr $ra # return to the caller
