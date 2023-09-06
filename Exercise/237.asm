.data

.text

main:
    # Load address of string into $t0
    la $t0, string

    # Initialize result to 0
    li $t1, 0

    # Initialize sign to 1 (positive)
    li $t2, 1

    # Read first character of string
    lb $t3, 0($t0)

    # Check if first character is '-'
    bne $t3, '-', positive

    # If first character is '-', set sign to -1 (negative)
    li $t2, -1

    # Increment string pointer
    addi $t0, $t0, 1

    # Read next character of string
    lb $t3, 0($t0)

positive:
    # Loop through string until null terminator is reached
    loop:
        # Check if character is a digit
        bge $t3, '0', digit
        bgt '9', $t3, not_digit

        # Multiply result by 10 and add digit
        sll $t1, $t1, 1
        sll $t1, $t1, 2
        sub $t3, $t3, '0'
        add $t1, $t1, $t3

        # Increment string pointer
        addi $t0, $t0, 1

        # Read next character of string
        lb $t3, 0($t0)

        # Repeat loop
        bne $t3, 0, loop

    # Apply sign to result
    mul $v0, $t1, $t2

    # Return result
    jr $ra

not_digit:
    # If a non-digit character is encountered, return -1
    li $v0, -1
    jr $ra

digit:
    # Do nothing
    nop

.data
string: .asciiz "12345"
