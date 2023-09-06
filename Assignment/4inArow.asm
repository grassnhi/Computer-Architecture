.data
boolEnd:    .word 0
boolRem:    .word 0
boolUn:     .word 0
boolBl:     .word 0
count1:     .word 0
block1:     .word 1
remove1:    .word 1
undo1:      .word 3
viola1:     .word 3
count2:     .word 0
block2:     .word 1
remove2:    .word 1
undo2:      .word 3
viola2:     .word 3
curRow1:    .word 0
curRow2:    .word 0
o:          .byte 'O' 
x:          .byte 'X'
newline:    .byte '\n'
board:      .space 42 
name1:      .space 10
name2:      .space 10
begin:      .asciiz "\n===================\n|| FOUR IN A ROW ||\n===================\n"
dashLine:   .asciiz "  -------------\n"
index:      .asciiz "  0 1 2 3 4 5 6\n"
askName:    .asciiz "\nFirst, please choose your name (no more than 10 characters) and then, you will be assigned the piece randomly.\n"
player1:    .asciiz "Player 1: " 
player2:    .asciiz "Player 2: "   
rule:       .asciiz "\nEach of you have 3 times undo at the first move and 1 time block the next opponent's move unless there is a chance to win.\nBesides, if you place your piece in an inappropriate position, the move will be restarted, which also counts as a violation.\nWhen you get a violation over 3 times, you will lose this game.\n\nNow, let the one with the piece O go first.\n"
askCol:     .asciiz "\nPlease choose a column: "
notCol:     .asciiz "\nInappropriate column! You get a violation! Please choose a column again:"
askUndo:    .asciiz "Do you want to undo your move? 1: yes, 0: no.\n"
askRemove:  .asciiz "\nDo you want to remove one arbitrary piece of the opponent? You cannot drop a piece if choosing this function.\nRemember that you have only 1 time 1: yes, 0: no.\n"
notHere:    .asciiz "There are not any of your opponent's pieces here! Choose another position."
whichCol:   .asciiz "\nWhich column? Please enter the index of the column: "
whichRow:   .asciiz "Which row? Please enter the index of row: "
askBlock:   .asciiz "\nDo you want to block the next opponent move? You have only 1 time. 1: yes, 0: no.\n"
blocked:    .asciiz "\nBlocked. Now, it's your turn!"
invalid:    .asciiz "\nInvalid character! Please enter 1: yes, 0: no.\n"
name:       .asciiz "\nPlayer: "
violation:  .asciiz "Violation: "
undo:       .asciiz "\nUndo: "
winner:     .asciiz "Congratulation! Winner: "
total:      .asciiz "Total piece on the board: "
piece:      .asciiz " -> Piece: "
draw:        .asciiz "Draw! No player wins!\n"

.text
main:
	li $s6, 6           # $s6 = 6
	li $s7, 7           # $s7 = 7 
	lb $s0, o           # $s0 = 'O' ~ $s1
	lb $s3, x           # $s3 = 'X' ~ $s2
	
# Start the game
	la $a0, begin
	li $v0, 4
	syscall 

    jal printBoard

# Ask players' names 
    la $a0, askName
	li $v0, 4
	syscall

    la $a0, player1
	li $v0, 4
	syscall

    # Read name
    la $a0, name1 
    addi $a1, $0, 10 
    li $v0, 8 
    syscall

    la $a0, player2
	li $v0, 4
	syscall

    la $a0, name2 
    addi $a1, $0, 10 
    li $v0, 8 
    syscall

# Assign piece randomly and match each name with each piece 
    li $v0, 42          # random call
    li $a1, 2           # upper bound
    syscall
    move $t0, $a0       # $t0 store the random
	
    beq $t0, 0, assign0
    beq $t0, 1, assign1

    assign0: 
        la $s1, name1   
    	la $s2, name2

        la $a0, player1
        li $v0, 4
        syscall

        la $a0, ($s1)
        li $v0, 4
        syscall 

        la $a0, piece
        li $v0, 4
        syscall 

        # print char
        add $a0, $0, $s0 # $s0 = 'O' ~ name1
        li $v0, 11 
        syscall

        la $a0, newline
        li $v0, 4
        syscall

        la $a0, player2
        li $v0, 4
        syscall

        la $a0, ($s2)
        li $v0, 4
        syscall 

        la $a0, piece
        li $v0, 4
        syscall

        add $a0, $0, $s3
        li $v0, 11 
        syscall

        j startPlay

    assign1:
        la $s1, name2  
    	la $s2, name1

        la $a0, player1 
        li $v0, 4
        syscall

        la $a0, ($s2)
        li $v0, 4
        syscall 

        la $a0, piece
        li $v0, 4
        syscall

        add $a0, $0, $s3
        li $v0, 11 
        syscall

        la $a0, newline
        li $v0, 4
        syscall

        la $a0, player2
        li $v0, 4
        syscall

        la $a0, ($s1)
        li $v0, 4
        syscall 

        la $a0, piece
        li $v0, 4
        syscall

        add $a0, $0, $s0
        li $v0, 11 
        syscall

        j startPlay

    startPlay:
        la $a0, rule
        li $v0, 4
        syscall

        jal firstMove
        jal playGame
    
    # Exit
    li $v0, 10
	syscall



# # # # # # # # # # #  ---  FIRST MOVE  ---   # # # # # # # # # # # # # #
# Player MUST drop the piece in the centre column!                      #
# -> Wrong column => count as a violation.                              #
# -> Input: cloumn index 3 => $a1                                       #
# -> Changing value: number of violation, each number of piece's count  #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
firstMove:
    addi $sp, $sp, -4 
	sw $ra, ($sp) 

    li $t9, 0 # turn = 0

    move $a1, $s1
    la $t1, viola1
    lw $a2, 0($t1)
    la $t2, undo1
    lw $a3, 0($t2)
   

    jal printTurn

    move $a2, $s0

    eachTurn:
        addi $t9, $t9, 1
        li $t1, 0 # save violation 

        la $a0, askCol
        li $v0, 4
        syscall

        li $v0, 5
        syscall
        move $a1, $v0 # $a1 = col

        beq $a1, 3, rightCol 

    violate:
        beq $t1, 3, checkTurn

        la $a0, notCol
        li $v0, 4
        syscall

        li $v0, 5
        syscall
        move $a1, $v0

        addi $t1, $t1, 1
        beq $a1, 3, calVio
        j violate

    checkTurn:
        beq $t9, 1, loseGameO
        beq $t9, 2, loseGameX
    
    loseGameO:
        la $a0, winner
        li $v0, 4
        syscall

        la $a0, ($s2)
        li $v0, 4
        syscall 

        la $a0, total
        li $v0, 4
        syscall

        li $v0, 1         
        lw $a0, count2
        syscall

        la $t2, boolEnd
        li $t3, 1
        sw $t3, 0($t2)

        j endFirstMove

    loseGameX:
        la $a0, winner
        li $v0, 4
        syscall

        la $a0, ($s1)
        li $v0, 4
        syscall 

        la $a0, total
        li $v0, 4
        syscall

        li $v0, 1         
        lw $a0, count1
        syscall

        la $t2, boolEnd
        li $t3, 1
        sw $t3, 0($t2)

        j endFirstMove

    calVio:
        beq $t9, 1, calVio1
        beq $t9, 2, calVio2

    calVio1:
        la $t2, viola1
        lw $t3, 0($t2)
        sub $t3, $t3, $t1
        sw $t3, 0($t2)
        j rightCol

    calVio2:
        la $t2, viola2
        lw $t3, 0($t2)
        sub $t3, $t3, $t1
        sw $t3, 0($t2)

        j rightCol

    rightCol:    
        jal checkCol
        beq $t9, 1, increaseO
        beq $t9, 2, increaseX

    increaseO:
        la $t3, count1
        lw $t4, 0($t3)
        addi $t4, $t4, 1
        sw $t4, 0($t3)
        j printLabel

    increaseX:
        la $t3, count2
        lw $t4, 0($t3)
        addi $t4, $t4, 1
        sw $t4, 0($t3)
        j printLabel

    printLabel:
        jal printBoard
    
    beq $t9, 2, endFirstMove

    move $a1, $s2
    la $t1, viola2
    lw $a2, 0($t1)
    la $t2, undo2
    lw $a3, 0($t2)
   
    jal printTurn

    move $a2, $s3

    j eachTurn

    endFirstMove:
        lw $ra, ($sp) # Restore return address
        addi $sp, $sp, 4 # Pop stack
        jr $ra


# # # # # # # # # # # #   ---  PLAYGAME   ---   # # # # # # # # # # # # # 
# Each player has 1 turn and 3 selections, choose one or some           #
# - remove (lose turn), undo, block (other cannot move == get 1 move)   #
# - No parameters and return value                                      #
# - Changing value: number of selections, piece counts                  #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
playGame:
    addi $sp, $sp, -4 # Make space for 1 item
	sw $ra, ($sp) # Store return address

    la $t2, boolEnd
    lw $t3, 0($t2)
    beq $t3, 1, endGame

    playerO:
        # Reset after each turn
        li $a0, 0
        sw $a0, boolUn
        sw $a0, boolBl
        sw $a0, boolRem

        move $a1, $s1
        la $t1, viola1
        lw $a2, 0($t1)
        la $t2, undo1
        lw $a3, 0($t2)

        jal printTurn

        # remove1 = 0, no remove left, false remove
        la $t1, remove1
        lw $a1, 0($t1)
        beq $a1, 0, falseRemove1
        
        move $a2, $s3  # X
        la $t1, count2 # count X
        lw $a3, 0($t1)
        # but remove1 = 1=> jump to ask, if yes, boolRemove = 1
        jal removePiece # if no boolRem = 0

        la $t1, remove1
        sw $a1, 0($t1)

        # boolRemove = 1 => loss this turn, jump to X
        la $t1, boolRem
        lw $a2, 0($t1)
        beq $a2, 0, falseRemove1 # if not, falseRemove
        j playerX

        falseRemove1:
            la $t1, boolUn
            li $a0, 0
            sw $a0, 0($t1)

            la $a0, askCol 
            li $v0, 4
            syscall

            li $v0, 5
            syscall
            move $a1, $v0 # $a1 = col
            move $s4, $v0
            
            # check column, violation = 0, have winner, boolEnd = 1
            move $a2, $s0 # 'O' to $a2 
            la $t2, viola1
            lw $a3, 0($t2) # $a3 = num of violat1
            la $t3, count1
            lw $v0, 0($t3) # $v0 = count
            la $t4, curRow1
            lw $v1, 0($t4)

            jal checkViolation

            la $t2, viola1
            sw $a3, 0($t2)
            la $t3, count1
            sw $v0, 0($t3)
            la $t4, curRow1
            sw $v1, 0($t4)

            # iff boolEnd = 1, endGame, else continue
            la $t1, boolEnd
            lw $a0, 0($t1)
            beq $a0, 0, continue1
            move $a2, $s2 # $a2 = name2
            la $t2, count2
            lw $a3, 0($t2) # $a3 = piece
            jal printWinner
            j endGame

            # Show piece and checkWin, if have winner, boolEnd = 1
            continue1:
            jal printBoard

            move $a1, $s0 # piece O
            move $a2, $s1 # name1
            la $t2, count1 # count1
            lw $a3, 0($t2)

            jal checkWin 

            # iff boolEnd = 1, endGame, else continue
            la $t1, boolEnd
            lw $a0, 0($t1)
            beq $a0, 1, endGame

            # undo1 = 0, no undo left, pass, not ask, jump to falseUndo
            la $t1, undo1
            lw $a0, 0($t1) # $a0 = undoes
            beq $a0, 0, falseUndo1 

            move $a1, $s4 # a1 = col
            la $t2, count1
            lw $a2, 0($t2) # $a2 = count piece
            la $t2, curRow1
            lw $a3, 0($t2) # a3 = curRow
            
            # undo1 #0, jump to ask and if chosen undo, boolUndo = 1, remove piece
            jal undoMove # if not, boolUndo = 0 !!!!

            la $t1, undo1
            sw $a0, 0($t1)
            la $t2, count1
            sw $a2, 0($t2) # $a2 = count piece
            la $t2, curRow1
            sw $a3, 0($t2)

            # boolUndo = 0, pass else player choose undo, so ask column again
            la $t1, boolUn
            lw $a0, 0($t1)
            beq $a0, 0, falseUndo1
            j falseRemove1

        falseUndo1:
            # block1 = 0, no block left, falseBlock -> X
            la $t1, block1
            lw $a2, 0($t1)
            beq $a2, 0, falseBlock1
            
            move $a1, $s3 
            # elsee ask to block, if yes, boolBl = 1
            jal blockMove

            la $t1, block1
            sw $a2, 0($t1)

            # iff boolBl = 0, falseBlock-> X, else X loss turn, O again
            la $t1, boolBl
            lw $a0, 0($t1)
            beq $a0, 0, falseBlock1
            j playerO

        falseBlock1:
            j playerX


    playerX:
        li $a0, 0
        sw $a0, boolBl
        sw $a0, boolRem
        sw $a0, boolUn

        move $a1, $s2
        la $t1, viola2
        lw $a2, 0($t1)
        la $t2, undo2
        lw $a3, 0($t2)

        jal printTurn

        la $t1, remove2
        lw $a1, 0($t1)
        beq $a1, 0, falseRemove2

        move $a2, $s0
        la $t1, count1 # count O
        lw $a3, 0($t1)

        jal removePiece

        la $t1, remove2
        sw $a1, 0($t1)
        
        la $t1, boolRem
        lw $a2, 0($t1)
        beq $a2, 0, falseRemove2
        j playerO

        falseRemove2:
            la $t1, boolUn
            li $a0, 0
            sw $a0, 0($t1)

            la $a0, askCol
            li $v0, 4
            syscall

            li $v0, 5
            syscall
            move $a1, $v0
            move $s4, $v0

            move $a2, $s3
            la $t2, viola2
            lw $a3, 0($t2)
            la $t3, count2
            lw $v0, 0($t3)
            la $t4, curRow2
            lw $v1, 0($t4)

            jal checkViolation

            la $t2, viola2
            sw $a3, 0($t2)
            la $t3, count2
            sw $v0, 0($t3)
            la $t4, curRow2
            sw $v1, 0($t4)

            la $t1, boolEnd
            lw $a0, 0($t1)
            beq $a0, 0, continue2
            move $a2, $s1 # $a2 = name1
            la $t2, count1
            lw $a3, 0($t2) # $a3 = piece
            jal printWinner
            j endGame

            continue2:
            jal printBoard

            move $a1, $s3 # piece X
            move $a2, $s2 # name2
            la $t2, count2 # count2
            lw $a3, 0($t2)

            jal checkWin

            la $t1, boolEnd
            lw $a0, 0($t1)
            beq $a0, 1, endGame

            la $t1, undo2
            lw $a0, 0($t1)
            beq $a0, 0, falseUndo2

            move $a1, $s4 # a1 = col
            la $t2, count2
            lw $a2, 0($t2) # $a2 = count piece
            la $t2, curRow2
            lw $a3, 0($t2) # a3 = curRow

            jal undoMove

            la $t1, undo2
            sw $a0, 0($t1)
            la $t2, count2
            sw $a2, 0($t2) # $v0 = count piece
            la $t2, curRow2
            sw $a3, 0($t2)

            la $t1, boolUn
            lw $a0, 0($t1)
            beq $a0, 0, falseUndo2
            j falseRemove2

        falseUndo2:
            la $t1, block2
            lw $a2, 0($t1)
            beq $a2, 0, falseBlock2

            move $a1, $s0
            jal blockMove

            la $t1, block2
            sw $a2, 0($t1)

            la $t1, boolBl
            lw $a0, 0($t1)
            beq $a0, 0, falseBlock2
            j playerX

        falseBlock2:
            j playerO

    endGame:
        lw $ra, ($sp) 
        addi $sp, $sp, 4 
        jr $ra


# # # # # #   ---  PRINTBOARD   ---   # # # # # # # # 
# Function to show the board and the change on it.  #
# - No parameter and no return value                #
# - Show index of the column (from 0 to 5).         #
# - Show the pieces placed on the board.            #
# # # # # # # # # # # # # # # # # # # # # # # # # # #
printBoard:
    addi $sp, $sp, -4 
	sw $ra, ($sp)

    li $t2, 0 # row index => i
    loop1:
        beq $t2, $s6, endLoop1
        
        move $a0, $t2 
        li $v0, 1
        syscall
        
        li $a0, 32 # Ascii 32 = ' '
        li $v0, 11 # Print space
        syscall

        li $t3, 0 # column index => j
        loop2:
            beq $t3, $s7, endLoop2

            mul $t4, $t2, $s7 # $t4 = i * column
		    add $t4, $t4, $t3 # $t4 = i * column + j
            
            lb $a0, board($t4)
            bne $a0, 0, printPiece
            li $a0, 46 # Ascii 46 = '.'
            printPiece:
            li $v0, 11
            syscall

            li $a0, 32 # Ascii 32 = ' '
            li $v0, 11 # Print space
            syscall

            addi $t3, $t3, 1 # j++
		    j loop2 
        endLoop2:

        lb $a0, newline
        li $v0, 11
        syscall 

        addi $t2, $t2, 1 # i++
        j loop1 
    endLoop1:

    la $a0, dashLine
	li $v0, 4
	syscall 
	
	la $a0, index
	li $v0, 4
	syscall
	
	lb $a0, newline
	li $v0, 11
	syscall

    lw $ra, ($sp) 
    addi $sp, $sp, 4 
    jr $ra


# # # # # # # # # # # #   ---   PRINTTURN   ---   # # # # # # # # # # # # # # 
# - Function for print name, number of violations and undo of each player   # 
# - Arguments: $a1, $a2, $a3 respectively ~ printed information             #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
printTurn:
    addi $sp, $sp, -4 
	sw $ra, ($sp)

    la $a0, name
    li $v0, 4
    syscall 

    move $a0, $a1
    li $v0, 4
    syscall 

    la $a0, violation
    li $v0, 4
    syscall 

    move $a0, $a2
    li $v0, 1
    syscall

    la $a0, undo
    li $v0, 4
    syscall 

    move $a0, $a3
    li $v0, 1
    syscall

    lw $ra, ($sp) 
	addi $sp, $sp, 4 
	jr $ra


# # # # # # # # # #   ---   REMOVEPIECE   ---   # # # # # # # # # # # 
# Function to ask to remove and remove piece if player choose yes   #
# Input: $a1 = remove, $a2 = other piece, $a3 = count other         #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
removePiece:
    addi $sp, $sp, -4 
	sw $ra, ($sp)

    beq $a1, 0, endRemove # a1 = remove

    la $a0, askRemove
    li $v0, 4
    syscall 

    li $v0, 12
	syscall
    move $t1, $v0 # $t1 = answer (1: yes, 0: no)
	
    seq $t2, $t1, 48 # If($t1 == 0) $t2 = 1 else $t2 = 0 (ascii 48 = '0')
	seq $t3, $t1, 49 # If($t1 == 1) $t3 = 1 else $t3 = 0 (ascii 49 = '1')
	or $t2, $t2, $t3 # If($t1 == 0 || $t1 == 1) $t2 = 1 else $t2 = 0
	
    loop10:
        beq $t2, 1, endLoop10

        la $a0, invalid
        li $v0, 4
        syscall 
            
        li $v0, 12
        syscall 
        move $t1, $v0 # $t1 = answer (1: yes, 0: no)
        
        seq $t2, $t1, 48 # If($t1 == 0) $t2 = 1 else $t2 = 0 (ascii 48 = '0')
        seq $t3, $t1, 49 # If($t1 = =1) $t3 = 1 else $t3 = 0 (ascii 49 = '1')
        or $t2, $t2, $t3 # If($t1 == 0 || $t1 == 1) $t2 = 1 else $t2 = 0
            
        j loop10
	endLoop10:
    
    beq $t1, 48, endRemove

    findPosition:
        la $a0, whichCol
        li $v0, 4
        syscall 

        li $v0, 5
        syscall
        move $t5, $v0

        la $a0, whichRow
        li $v0, 4
        syscall 

        li $v0, 5
        syscall
        move $t4, $v0

        mul $t2, $t4, $s7 # $t2 = Row * column
        add $t1, $t2, $t5 # $t1 = Row * column + col
            
        lb $t3, board($t1) 
        beq $t3, $zero, askPosition
        beq $t3, $a2, askPosition
        
        j found

    askPosition:
        la $a0, notHere
        li $v0, 4
        syscall 
        
        j findPosition

    found:
        sb $zero, board($t1)

        addi $a1, $a1, -1
        addi $a3, $a3, -1

        la $t1, boolRem
        li $t2, 1
        sw $t2, 0($t1)

        move $t0, $t4 # i = row
        loopMove:
            beq $t0, 0, endLoopMove # i > 0

            mul $t1, $t0, $s7 # $t1 = i * column
		    add $t1, $t1, $t5 # $t1 = i * column + col

            addi $t2, $t0, -1
            mul $t2, $t2, $s7 # $t2 = (i-1) * column
		    add $t2, $t2, $t5 # $t2 = $t2 + col

            lb $t3, board($t2)
            bne $t3, $zero, moving
            sb $zero, board($t1)
            j endLoopMove

            moving:
                sb $t3, board($t1)

            addi $t0, $t0, -1 
            j loopMove

        endLoopMove:
            jal printBoard

    endRemove:
        lw $ra, ($sp) 
        addi $sp, $sp, 4 
        jr $ra


# # # # # # # # # # #    ---   CHECKVIOLATION   ---   # # # # # # # # # # # #
# Input: $a1 = col, $a2 = piece, $a3 = violate, $v0 = count, $v1 = curRow   #
# If wrong index of column, violation--, ask col again and change curRow    #
# No violate left => return boolEnd = 1                                     #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
checkViolation:
    addi $sp, $sp, -4
    sw $ra, ($sp)

    li $a0, 0 # return value for check col
    loopViolate:
		jal checkCol # valid: $a0 = 1 else $a0 = 0 and $a3--
		beq $a0, 1, endViolation # $a0 = 1 end, $a0 false then 
		bne $a3, 0, restartMove # If(violate = 0) player lose, else restart the move
		li $a0, 1
		sw $a0, boolEnd # for case lose: end = true
		
		j endViolation
		
    restartMove:
		addi $sp, $sp, -8 
		sw $v0, ($sp) # $v0: piecee count
		sw $a0, 4($sp) # $a0: flag of checkColumn 
		
        la $a0, notCol
		li $v0, 4
		syscall 
		
        li $v0, 5
		syscall 
		move $a1, $v0 
		
        addi $a3, $a3, -1 

		lw $v0, ($sp) 
		lw $a0, 4($sp) 
		addi $sp, $sp, 8 

		j loopViolate 

    endViolation:
        lw $ra, ($sp) 
        addi $sp, $sp, 4
        jr $ra



# # # # # # # # # # # # # # #   --- CHECKCOL  ---   # # # # # # # # # # # # # # # # # # # #  
# - Input: index of column => $a1, piece => $a2, violation => $a3, count $v0, curRow $v1  #       
# -> If the index is ok => place piece, update curRow else return only                    #
# - Return value: $a0 => true for valid else false                                        #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
checkCol:
    addi $sp, $sp, -4 
	sw $ra, ($sp)

    slti $t0, $a1, 0 # If(col < 0) $t0 = 1 else $t0 = 0
	slt $t1, $a1, $s7 # If(col < column) $t1 = 1 else $t1 = 0
	seq $t1, $t1, 0 # If(col >= column) $t1 = 1 else $t1 = 0
	or $t0, $t0, $t1 # If(col < 0 || col >= column) $t0 = 1 else $t0 = 0
	beq $t0, 1, endCheckCol # If col invalid -> return

    addi $t0, $s6, -1 # i = row - 1
	loopCheck:
		beq $t0, -1, endCheckCol 

		mul $t1, $t0, $s7 # $t1 = i * column
		add $t1, $t1, $a1 # $t1 = i * column + col
		
        lb $t2, board($t1) # $t2 = board[i][col]
		beq $t2, 0, endCheck # If board[i][col] null -> valid -> break the loop
		
        addi $t0, $t0, -1 
		j loopCheck 

	endCheck: 
        sb $a2, board($t1) 

        addi $v0, $v0, 1

        move $v1, $t0
        
        li $a0, 1 # valid, add piece ok => $a0 = true

    endCheckCol:
        lw $ra, ($sp) 
        addi $sp, $sp, 4 
        jr $ra


# # # # # # # # # #   ---   PRINTWINNER   ---   # # # # # # # # # # # 
# - Function for print name, total number of piece of the winner    #  
# - Arguments: $a2 : name winner,  $a3: piece count                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
printWinner:
    addi $sp, $sp, -4 
	sw $ra, ($sp)
    
    la $a0, winner
    li $v0, 4
    syscall 

    move $a0, $a2
    li $v0, 4
    syscall

    la $a0, total
    li $v0, 4
    syscall

    move $a0, $a3
    li $v0, 1
    syscall

    lw $ra, ($sp) 
    addi $sp, $sp, 4 
    jr $ra


# # # # # # # # # # #   ---   CHECKWIN   ---    # # # # # # # # # # # # #
# Function to check whether player wins or the game ends with draw      #
# - Input $a1 (piece), $a2 (other name), $a3 (other piece)              #
# - Return with boolEnd is true (print result and exit game) or false.  #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
checkWin:
    addi $sp, $sp, -4 
	sw $ra, ($sp)

    addi $t0, $s6, -1 # row index: Initialise i = row - 1
	L1Win:
		beq $t0, -1, endL1Win # While(i >= 0) do
		li $t1, 0 # column index: Initialise j = 0
		L2Win:
		beq $t1, $s7, endL2Win # While(j < row) do
		
	# === VERTICAL === #
		# i > 2
		sgt $t3, $t0, 2 # If(i > 2) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i][j]
		mul $t2, $t0, $s7 # $t2 = i * column
		add $t2, $t2, $t1 # $t2 = i * column + j
		lb $a0, board($t2) # $a0 = board[i][j]
		seq $t4, $a0, $a1 # If(board[i][j] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i-1][j]
		addi $t2, $t0, -1 # $t2 = i - 1
		mul $t2, $t2, $s7 # $t2 = (i-1) * column
		add $t2, $t2, $t1 # $t2 = (i-1) * column + j
		lb $a0, board($t2) # $a0 = board[i-1][j]
		seq $t4, $a0, $a1 # If(board[i-1][j] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i-2][j]
		addi $t2, $t0, -2 # $t2 = i - 2
		mul $t2, $t2, $s7 # $t2 = (i-2) * column
		add $t2, $t2, $t1 # $t2 = (i-2) * column + j
		lb $a0, board($t2) # $a0 = board[i-2][j]
		seq $t4, $a0, $a1 # If(board[i-2][j] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i-3][j]
		addi $t2, $t0, -3 # $t2 = i - 3
		mul $t2, $t2, $s7 # $t2 = (i-3) * column
		add $t2, $t2, $t1 # $t2 = (i-3) * column + j
		lb $a0, board($t2) # $a0 = board[i-3][j]
		seq $t4, $a0, $a1 # If(board[i-3][j] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		beq $t3, 1, findWin # If($t3 == 1) player 1 wins
		
	# === HORIZONTAL === #
		# j < 4
		slti $t3, $t1, 4 # If(j < 4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i][j]
		mul $t2, $t0, $s7 # $t2 = i * column
		add $t2, $t2, $t1 # $t2 = i * column + j
		lb $a0, board($t2) # $a0 = board[i][j]
		seq $t4, $a0, $a1 # If(board[i][j] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i][j+1]
		mul $t2, $t0, $s7 # $t2 = i * column
		add $t2, $t2, $t1 # $t2 = i * column + j
		addi $t2, $t2, 1 # $t2 = i * column + (j+1)
		lb $a0, board($t2) # $a0 = board[i][j+1]
		seq $t4, $a0, $a1 # If(board[i][j+1] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i][j+2]
		mul $t2, $t0, $s7 # $t2 = i * column
		add $t2, $t2, $t1 # $t2 = i * column + j
		addi $t2, $t2, 2 # $t2 = i * column + (j+2)
		lb $a0, board($t2) # $a0 = board[i][j+2]
		seq $t4, $a0, $a1 # If(board[i][j+2] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i][j+3]
		mul $t2, $t0, $s7 # $t2 = i * column
		add $t2, $t2, $t1 # $t2 = i * column + j
		addi $t2, $t2, 3 # $t2 = i * column + (j+3)
		lb $a0, board($t2) # $a0 = board[i][j+3]
		seq $t4, $a0, $a1 # If(board[i][j+3] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		beq $t3, 1, findWin # If($t3 == 1) player 1 wins
		
	# === UP DIAGONAL === #
		# i > 2
		sgt $t3, $t0, 2 # If(i > 2) $t3 = 1 else $t3 = 0
		# j < 4
		slti $t4, $t1, 4 # If(j < 4) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i][j]
		mul $t2, $t0, $s7 # $t2 = i * column
		add $t2, $t2, $t1 # $t2 = i * column + j
		lb $a0, board($t2) # $a0 = board[i][j]
		seq $t4, $a0, $a1 # If(board[i][j] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i-1][j+1]
		addi $t2,$t0, -1 # $t2 = i - 1
		mul $t2, $t2, $s7 # $t2 = (i-1) * column
		add $t2, $t2, $t1 # $t2 = (i-1) * column + j
		addi $t2, $t2, 1 # $t2 = (i-1) * column + (j+1)
		lb $a0, board($t2) # $a0 = board[i-1][j+1]
		seq $t4, $a0, $a1 # If(board[i-1][j+1] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i-2][j+2]
		addi $t2, $t0, -2 # $t2 = i - 2
		mul $t2, $t2, $s7 # $t2 = (i-2) * column
		add $t2, $t2, $t1 # $t2 = (i-2) * column + j
		addi $t2, $t2, 2 # $t2 = (i-2) * column + (j+2)
		lb $a0, board($t2) # $a0 = board[i-2][j+2]
		seq $t4, $a0, $a1 # If(board[i-2][j+2] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i-3][j+3]
		addi $t2, $t0, -3 # $t2 = i - 3
		mul $t2, $t2, $s7 # $t2 = (i-3) * column
		add $t2, $t2, $t1 # $t2 = (i-3) * column + j
		addi $t2, $t2, 3 # $t2 = (i-3) * column + (j+3)
		lb $a0, board($t2) # $a0 = board[i-3][j+3]
		seq $t4, $a0, $a1 # If(board[i-3][j+3] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 - 0
		beq $t3, 1, findWin # If($t3 == 1) player 1 wins
		
	# === DOWN DIAGONAL === #
		# i < 3
		slti $t3, $t0, 3 # If(i < 3) $t3 = 1 else $t3 = 0
		# j < 4
		slti $t4, $t1, 4 # If(j < 4) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i][j]
		mul $t2, $t0, $s7 # $t2 = i * column
		add $t2, $t2, $t1 # $t2 = i * column + j
		lb $a0, board($t2) # $a0 = board[i][j]
		seq $t4, $a0, $a1 # If(board[i][j] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i+1][j+1]
		addi $t2,$t0, 1 # $t2 = i + 1
		mul $t2, $t2, $s7 # $t2 = (i+1) * column
		add $t2, $t2, $t1 # $t2 = (i+1) * column + j
		addi $t2, $t2, 1 # $t2 = (i+1) * column + (j+1)
		lb $a0, board($t2) # $a0 = board[i+1][j+1]
		seq $t4, $a0, $a1 # If(board[i+1][j+1] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i+2][j+2]
		addi $t2, $t0, 2 # $t2 = i + 2
		mul $t2, $t2, $s7 # $t2 = (i+2) * column
		add $t2, $t2, $t1 # $t2 = (i+2) * column + j
		addi $t2, $t2, 2 # $t2 = (i+2) * column + (j+2)
		lb $a0, board($t2) # $a0 = board[i+2][j+2]
		seq $t4, $a0, $a1 # If(board[i+2][j+2] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i+3][j+3]
		addi $t2, $t0, 3 # $t2 = i + 3
		mul $t2, $t2, $s7 # $t2 = (i+3) * column
		add $t2, $t2, $t1 # $t2 = (i+3) * column + j
		addi $t2, $t2, 3 # $t2 = (i+3) * column + (j+3)
		lb $a0, board($t2) # $a0 = board[i+3][j+3]
		seq $t4, $a0, $a1 # If(board[i+3][j+3] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 - 0
		beq $t3, 1, findWin # If($t3 == 1) player 1 wins
        j continueCheckWin
		
        findWin:
            jal printWinner
        
            li $a0, 1
            sw $a0, boolEnd 

            j endCheckWin 
            

		continueCheckWin:
            addi $t1, $t1, 1 
            j L2Win 
		endL2Win:
		
        addi $t0, $t0, -1 # i--
        j L1Win # Continue loop i
	endL1Win:
	
# === DRAWN === #
	li $a0, 0
	jal checkFull 
	seq $t0, $a0, 1 # If(checkFull) $t0 = 1 else $t0 = 0
	lw $a0, boolEnd # $a0 = flag boolEnd
	seq $t1, $a0, 0 # If(!boolEnd) $t1 = 1 else $t1 = 0
	and $t0, $t0, $t1 # If($t0 && $t1) $t0 = 1 else $t0 = 0
	beq $t0, 0, endCheckWin # If(!checkFull || boolEnd) return
	
	la $a0, draw
	li $v0, 4
	syscall 
    
	li $a0, 1 
	sw $a0, boolEnd 
	
	endCheckWin:
        lw $ra, ($sp) 
        addi $sp, $sp, 4 
        jr $ra


# # # # # # # # # # #    ---   UNDOMOVE   ---   # # # # # # # # # # # # # 
# Function to ask if player want to undo their move                     #
# -> If yes, undo and ask col >< If no, exit function with boolUn = 0   #
# Input: $a0 = undo, $a1 = col, $a2 = count piece, $a3 = curRow         #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
undoMove:
    addi $sp, $sp, -4 
	sw $ra, ($sp)

	move $t5, $a0 # undo count

	beq $t5, 0, endUndo

    la $a0, askUndo
	li $v0, 4
	syscall

    li $v0, 12
	syscall
    move $t1, $v0 # (1: yes, 0: no)
	
    seq $t2, $t1, 48 # If($t1 == 0) $t2 = 1 else $t2 = 0 (ascii 48 = '0')
	seq $t3, $t1, 49 # If($t1 == 1) $t3 = 1 else $t3 = 0 (ascii 49 = '1')
	or $t2, $t2, $t3 # If($t1 == 0 || $t1 == 1) $t2 = 1 else $t2 = 0
		
    loopYN:
        beq $t2, 1, endLoopYN

        la $a0, invalid
        li $v0, 4
        syscall 
            
        li $v0, 12
        syscall 
        move $t1, $v0 
        
        seq $t2, $t1, 48 # If($t1 == 0) $t2 = 1 else $t2 = 0 (ascii 48 = '0')
        seq $t3, $t1, 49 # If($t1 = =1) $t3 = 1 else $t3 = 0 (ascii 49 = '1')
        or $t2, $t2, $t3 # If($t1 == 0 || $t1 == 1) $t2 = 1 else $t2 = 0
            
        j loopYN
	endLoopYN:
    la $t3, boolUn
    li $t4, 0
    sw $t4, 0($t3)

    move $a0, $t5
    
    beq $t1, 48, endUndo 
		
	mul $t1, $a3, $s7 # $t1 = curRow * column
	add $t1, $t1, $a1 # $t1 = curRow * column + col
	sb $zero, board($t1) # board[curRow][col] = '\0' 
	
    addi $a0, $a0, -1

    addi $a2, $a2, -1 # delete piece == count--

    la $t1, boolUn
    li $t2, 1
    sw $t2, 0($t1)
        

    endUndo:
    lw $ra, ($sp) 
    addi $sp, $sp, 4 
    jr $ra


# # # # # # # # # # #    ---   BLOCKMOVE    ---   # # # # # # # # # # # # # # 
# Function to ask if player want to block the next opponent's move          #
# -> If yes, pass the turn again to the player else return with boolBK = 0  #
# Input: $a1 = other piece, $a2 = block                                     #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
blockMove:
    addi $sp, $sp, -4 
	sw $ra, ($sp)

    la $a0, 0
    jal checkBlock # input $a0 F for ok T for nearly win
    
    beq $a0, 1, endBlock
    beq $a2, 0, endBlock # a2 = block

    la $a0, askBlock
    li $v0, 4
    syscall 

    li $v0, 12
	syscall
    move $t1, $v0 # $t1 = answer (1: yes, 0: no)
	
    seq $t2, $t1, 48 # If($t1 == 0) $t2 = 1 else $t2 = 0 (ascii 48 = '0')
	seq $t3, $t1, 49 # If($t1 == 1) $t3 = 1 else $t3 = 0 (ascii 49 = '1')
	or $t2, $t2, $t3 # If($t1 == 0 || $t1 == 1) $t2 = 1 else $t2 = 0
	
    loopTF:
        beq $t2, 1, endLoopTF

        la $a0, invalid
        li $v0, 4
        syscall # print string to inform invalid character
            
        li $v0, 12
        syscall # read character
        move $t1, $v0 # $t1 = answer (1: yes, 0: no)
        
        seq $t2, $t1, 48 # If($t1 == 0) $t2 = 1 else $t2 = 0 (ascii 48 = '0')
        seq $t3, $t1, 49 # If($t1 = =1) $t3 = 1 else $t3 = 0 (ascii 49 = '1')
        or $t2, $t2, $t3 # If($t1 == 0 || $t1 == 1) $t2 = 1 else $t2 = 0
            
        j loopTF
	endLoopTF:
    
    beq $t1, 48, endBlock

    addi $a2, $a2, -1

    la $a0, blocked
    li $v0, 4
    syscall

    la $t1, boolBl
    li $t2, 1
    sw $t2, 0($t1)

    endBlock:

    lw $ra, ($sp) 
    addi $sp, $sp, 4 
    jr $ra


# # # # # # #   ---   CHECKFULL   ---   # # # # # # # 
# Function to check if the board is full or not     #
# Input: $a0 = 0 (flag = false)                     #
# Output: $a0 = 1 if full, else $a0 = 0             #
# # # # # # # # # # # # # # # # # # # # # # # # # # #
checkFull:
    addi $sp, $sp, -4 
	sw $ra, ($sp)
    
    li $t0, 0 # i = 0
	loopI:
		beq $t0, $s6, endloopI 
		
        li $t1, 0 #  j = 0
		loopJ:
		beq $t1, $s7, endloopJ 

		mul $t2, $t0, $s7 # $t2 = i * column
		add $t2, $t2, $t1 # $t2 = i * column + j
		
        lb $t2, board($t2) # $t2 = board[i][j]
		beq $t2, 0, endCheckFull # If(board[i][j] null) return false
		
        addi $t1, $t1, 1 
		j loopJ 
		endloopJ:
	
	addi $t0, $t0, 1 
	j loopI 
	endloopI:

	li $a0, 1 # If every cell in board not null => return true
	
    endCheckFull:
        lw $ra, ($sp) 
        addi $sp, $sp, 4 
        jr $ra


# # # # # # #   ---    CHECKBLOCK   ---   # # # # # # 
# Function to check if there is a connection of 3   #
# Input: $a1 = piece other                          #
# Output: $a0 = 1 if 3 connected, else $a0 = 0      #
# # # # # # # # # # # # # # # # # # # # # # # # # # #
checkBlock:
    addi $sp, $sp, -4 
	sw $ra, ($sp)

    addi $t0, $s6, -1 # i = row - 1
	Bl1:
		beq $t0, -1, endBl1 # While(i >= 0) do
		li $t1, 0 # column index: Initialise j = 0
		Bl2:
		beq $t1, $s7, endBl2 # While(j < row) do
		
	# === VERTICAL === #
		# i > 1
		sgt $t3, $t0, 1 # If(i > 2) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i][j]
		mul $t2, $t0, $s7 # $t2 = i * column
		add $t2, $t2, $t1 # $t2 = i * column + j
		lb $a0, board($t2) # $a0 = board[i][j]
		seq $t4, $a0, $a1 # If(board[i][j] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i-1][j]
		addi $t2, $t0, -1 # $t2 = i - 1
		mul $t2, $t2, $s7 # $t2 = (i-1) * column
		add $t2, $t2, $t1 # $t2 = (i-1) * column + j
		lb $a0, board($t2) # $a0 = board[i-1][j]
		seq $t4, $a0, $a1 # If(board[i-1][j] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i-2][j]
		addi $t2, $t0, -2 # $t2 = i - 2
		mul $t2, $t2, $s7 # $t2 = (i-2) * column
		add $t2, $t2, $t1 # $t2 = (i-2) * column + j
		lb $a0, board($t2) # $a0 = board[i-2][j]
		seq $t4, $a0, $a1 # If(board[i-2][j] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		beq $t3, 1, nearWin # If($t3 == 1) player 1 wins
		
	# === HORIZONTAL === #
		# j < 5
		slti $t3, $t1, 5 # If(j < 4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i][j]
		mul $t2, $t0, $s7 # $t2 = i * column
		add $t2, $t2, $t1 # $t2 = i * column + j
		lb $a0, board($t2) # $a0 = board[i][j]
		seq $t4, $a0, $a1 # If(board[i][j] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i][j+1]
		mul $t2, $t0, $s7 # $t2 = i * column
		add $t2, $t2, $t1 # $t2 = i * column + j
		addi $t2, $t2, 1 # $t2 = i * column + (j+1)
		lb $a0, board($t2) # $a0 = board[i][j+1]
		seq $t4, $a0, $a1 # If(board[i][j+1] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i][j+2]
		mul $t2, $t0, $s7 # $t2 = i * column
		add $t2, $t2, $t1 # $t2 = i * column + j
		addi $t2, $t2, 2 # $t2 = i * column + (j+2)
		lb $a0, board($t2) # $a0 = board[i][j+2]
		seq $t4, $a0, $a1 # If(board[i][j+2] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		beq $t3, 1, nearWin # If($t3 == 1) player 1 wins
		
	# === UP DIAGONAL === #
		# i > 1
		sgt $t3, $t0, 1 # If(i > 2) $t3 = 1 else $t3 = 0
		# j < 5
		slti $t4, $t1, 5 # If(j < 4) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i][j]
		mul $t2, $t0, $s7 # $t2 = i * column
		add $t2, $t2, $t1 # $t2 = i * column + j
		lb $a0, board($t2) # $a0 = board[i][j]
		seq $t4, $a0, $a1 # If(board[i][j] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i-1][j+1]
		addi $t2,$t0, -1 # $t2 = i - 1
		mul $t2, $t2, $s7 # $t2 = (i-1) * column
		add $t2, $t2, $t1 # $t2 = (i-1) * column + j
		addi $t2, $t2, 1 # $t2 = (i-1) * column + (j+1)
		lb $a0, board($t2) # $a0 = board[i-1][j+1]
		seq $t4, $a0, $a1 # If(board[i-1][j+1] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i-2][j+2]
		addi $t2, $t0, -2 # $t2 = i - 2
		mul $t2, $t2, $s7 # $t2 = (i-2) * column
		add $t2, $t2, $t1 # $t2 = (i-2) * column + j
		addi $t2, $t2, 2 # $t2 = (i-2) * column + (j+2)
		lb $a0, board($t2) # $a0 = board[i-2][j+2]
		seq $t4, $a0, $a1 # If(board[i-2][j+2] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		beq $t3, 1, nearWin # If($t3 == 1) player 1 wins
		
	# === DOWN DIAGONAL === #
		# i < 4
		slti $t3, $t0, 3 # If(i < 3) $t3 = 1 else $t3 = 0
		# j < 5
		slti $t4, $t1, 4 # If(j < 4) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i][j]
		mul $t2, $t0, $s7 # $t2 = i * column
		add $t2, $t2, $t1 # $t2 = i * column + j
		lb $a0, board($t2) # $a0 = board[i][j]
		seq $t4, $a0, $a1 # If(board[i][j] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i+1][j+1]
		addi $t2,$t0, 1 # $t2 = i + 1
		mul $t2, $t2, $s7 # $t2 = (i+1) * column
		add $t2, $t2, $t1 # $t2 = (i+1) * column + j
		addi $t2, $t2, 1 # $t2 = (i+1) * column + (j+1)
		lb $a0, board($t2) # $a0 = board[i+1][j+1]
		seq $t4, $a0, $a1 # If(board[i+1][j+1] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		# $t2 = offset of board[i+2][j+2]
		addi $t2, $t0, 2 # $t2 = i + 2
		mul $t2, $t2, $s7 # $t2 = (i+2) * column
		add $t2, $t2, $t1 # $t2 = (i+2) * column + j
		addi $t2, $t2, 2 # $t2 = (i+2) * column + (j+2)
		lb $a0, board($t2) # $a0 = board[i+2][j+2]
		seq $t4, $a0, $a1 # If(board[i+2][j+2] == piece1) $t4 = 1 else $t4 = 0
		and $t3, $t3, $t4 # If($t3 && $t4) $t3 = 1 else $t3 = 0
		beq $t3, 1, nearWin # If($t3 == 1) nearWin
        j continueBl
		
        nearWin:
           li $a0, 1

           j endBl1 

		continueBl:
            addi $t1, $t1, 1
            j Bl2 
            
		endBl2:
        addi $t0, $t0, -1 
        j Bl1 

	endBl1:

    lw $ra, ($sp) 
    addi $sp, $sp, 4 
    jr $ra
