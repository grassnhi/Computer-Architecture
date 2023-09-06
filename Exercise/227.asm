    li      $t2, 0           # initialize $t2 to zero (j = 0)
    outerloop:
        beq     $t0, $s0, end # if i >= a, exit outer loop
        li      $t2, 0       # initialize $t2 to zero (j = 0)
        innerloop:
            beq     $t1, $s1, innerloop_end # if j >= b, exit inner loop
            sll     $t3, $t1, 2  # 4 * j
            add     $t3, $t3, $s2  # D + 4 * j
            add     $t4, $t0, $t1 # i + j
            sw      $t4, 0($t3)  # store i + j to D[4 * j]
            addi    $t1, $t1, 1 # j++
            j       innerloop   # jump to innerloop
        innerloop_end:
        addi    $t0, $t0, 1 # i++
        j       outerloop   # jump to outerloop
    end:


// Ver 2:

# initialize i to 0
li $t0, 0

outer_loop:
    # check if i >= a
    bge $t0, $s0, end_outer_loop
    
    # initialize j to 0
    li $t1, 0

    inner_loop:
        # check if j >= b
        bge $t1, $s1, end_inner_loop
        
        # calculate the array index
        sll $t2, $t1, 2
        add $t2, $t2, $s2
        
        # calculate i + j
        add $t3, $t0, $t1
        
        # store the result at the array index
        sw $t3, 0($t2)
        
        # increment j
        addi $t1, $t1, 1
        
        # go back to the start of the inner loop
        j inner_loop
        
    end_inner_loop:
        # increment i
        addi $t0, $t0, 1
        
        # go back to the start of the outer loop
        j outer_loop
        
end_outer_loop:
