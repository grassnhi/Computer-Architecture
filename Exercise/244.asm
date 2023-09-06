loop:
    ll $t0, 0($a1) # load the current value of shvar into t0
    bge $t0, $a2, end # if shvar >= x, jump to end
    move $t1, $a2 # move x into t1
    sc $t1, 0($a1) # try to store t1 back to shvar
    beqz $t1, loop # if store fails, repeat from the beginning
end:
