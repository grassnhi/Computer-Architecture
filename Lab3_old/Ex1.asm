.data
shape: .asciiz "Which shape of area do you want to calculate?\n1: rectangle.\n2: square.\n3: circle.\n4: triangle.\n"
rectangle: .asciiz "Please enter the length and width of the rectangle: "
square: .asciiz "Please enter the side of the square: "
circle: .asciiz "Please enter the radius of the circle: "
triangle: .asciiz "Please enter the height and base of the triangle: "
result: .asciiz "Your area: "
half: .float 0.5
PI: .float 3.14

.text
main:
    li $v0, 4
	la $a0, shape
	syscall
	
	li $v0, 5
	syscall

    beq $v0, 1, RECT
	beq $v0, 2, SQR
	beq $v0, 3, CIRC
	beq $v0, 4, TRIA

RECT:
    li $v0, 4
	la $a0, rectangle
	syscall

    li $v0, 6
	syscall 
	mov.s $f1, $f0

    li $v0, 6
	syscall 
	mul.s $f12, $f0, $f1 
	
    j exit

SQR:
    li $v0, 4
	la $a0, rectangle
	syscall

    li $v0, 6
	syscall 
	mul.s $f12, $f0, $f0 
	
    j exit

CIRC:
    li $v0, 4
	la $a0, circle
	syscall

    li $v0, 6
	syscall 
    l.s $f12, PI
    mul.s $f0, $f0, $f0
	mul.s $f12, $f0, $f12 
	
    j exit

TRIA:
    li $v0, 4
	la $a0, triangle
	syscall

    li $v0, 6
	syscall 
	mov.s $f1, $f0

    li $v0, 6
	syscall 
    l.s $f12, half
	mul.s $f12, $f12, $f1 
	mul.s $f12, $f12, $f0 
	
    j exit

exit: 
    li $v0, 4
	la $a0, result
	syscall

	li $v0, 2 
	syscall
	
	li $v0, 10
	syscall