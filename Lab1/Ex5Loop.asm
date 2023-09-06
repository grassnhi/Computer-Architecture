.data
array: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 

.text
main:
    # Initialize
    li $s0, 0   
    la $t0, array         
    li $t1, 0           
    li $t2, 10         

    loop:
        beq $t1, $t2, print  
        lw $t3, 0($t0)       
        add $s0, $s0, $t3  
        addi $t0, $t0, 4  # array[i+1]
        addi $t1, $t1, 1   # i++
        j loop            
        
    print:
        li $v0, 1           
        move $a0, $s0      
        syscall           

    # Exit 
    li $v0, 10          
    syscall            