.data 
array: .space 40
string: .asciiz "Please enter 10 integer numbers:\n"
space: .asciiz " "

.text
main:
	li $v0, 4
	la $a0, string
	syscall
	
	li $t0, 0 # Initialise index i = 0

input: 
	beq $t0, 40, exit1 # While(i < 10) store input value into array

	li $v0, 5 # read int value
	syscall # $v0 = input

	sw $v0, array($t0) # arr[i] = $v0
	addi $t0, $t0, 4 # $t0 += 4 (1 int number is 4 bytes)

	j input
	
exit1:
	
	li $t0, 0 # i = 0
bubbleSort: 
	beq $t0, 36, exit2 # while(i < 9) do bubble sort descendingly

	li $t1, 0 # j = 0
	innerLoop: 
		beq $t1, 36, exit3 # while(j < 9) do

		addi $t2, $t1, 4 # $t3 = j + 1
		lw $t3, array($t1) # $t4 = arr[j]
		lw $t4, array($t2) # $t3 = arr[j+1]

		slt $t5, $t3, $t4 # Check whether arr[j] < arr[j+1] or not
		beq $t5, 0, exit4 # If(arr[j] < arr[j+1] swap, else break)

		sw $t3, array($t2) # arr[j+1] = arr[j]
		sw $t4, array($t1) # arr[j] = arr[j+1]
	exit4:

		addi $t1, $t1, 4 # j++

		j innerLoop # Continue inner loop	

	exit3:
		addi $t0, $t0, 4 # i++

		j bubbleSort # continue bubble sort

	exit2:
	
	li $t0, 0 # i = 0
	output: 
		beq $t0, 40, exit5 # while(i < 10) print the array after sorted descendingly

		li $v0, 1
		lw $a0, array($t0)
		syscall # print arr[i]

		li $v0, 4
		la $a0, space 
		syscall # print space between each element

		addi $t0, $t0, 4 # i++

		j output

	exit5:

	li $v0, 10
	syscall