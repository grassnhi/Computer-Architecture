.data
shape: .asciiz "Which shape of volume do you want to calculate?\n1: Rectangular parallelepiped.\n2: Cube.\n3: Cylinder.\n"
errorInform: .asciiz "Wrong number! You need to enter a positive number! Exit program . . ."
rectangular: .asciiz "Please enter the length, width and height of the rectangle: "
cube: .asciiz "Please enter the edge of the cube: "
cylinder: .asciiz "Please enter the radius and height of the cylinder: "
result: .asciiz "Your volume: "
PI: .float 3.14
zero: .float 0.0

.text
main:
    li $v0, 4
	la $a0, shape
	syscall
	
	li $v0, 5
	syscall

    beq $v0, 1, RECT
	beq $v0, 2, CUBE
	beq $v0, 3, CYLD

RECT:
    li $v0, 4
	la $a0, rectangular
	syscall

    li $v0, 6
	syscall 

	l.s $f10, zero
	c.lt.s $f0, $f10
	bc1t error

	mov.s $f1, $f0

    li $v0, 6
	syscall 

	l.s $f10, zero
	c.lt.s $f0, $f10
	bc1t error

	mul.s $f12, $f0, $f1

	li $v0, 6
	syscall 

	l.s $f10, zero
	c.lt.s $f0, $f10
	bc1t error

	mul.s $f12, $f0, $f12 
	
    j exit

CUBE:
    li $v0, 4
	la $a0, cube
	syscall

    li $v0, 6
	syscall 

	l.s $f10, zero
	c.lt.s $f0, $f10
	bc1t error

	mul.s $f12, $f0, $f0 
    mul.s $f12, $f0, $f12
	
    j exit

CYLD:
    li $v0, 4
	la $a0, cylinder
	syscall

    li $v0, 6
	syscall 

	l.s $f10, zero
	c.lt.s $f0, $f10
	bc1t error

    l.s $f12, PI
    mul.s $f0, $f0, $f0
	mul.s $f12, $f0, $f12 

    li $v0, 6
	syscall 

	l.s $f10, zero
	c.lt.s $f0, $f10
	bc1t error

    mul.s $f12, $f0, $f12
	
    j exit

error:
	li $v0, 4
	la $a0, errorInform
	syscall
	j exit

exit: 
    li $v0, 4
	la $a0, result
	syscall

	li $v0, 2 
	syscall
	
	li $v0, 10
	syscall