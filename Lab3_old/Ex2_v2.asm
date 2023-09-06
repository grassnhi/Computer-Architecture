.data
u: .asciiz "Please enter the lower limit u: "
v: .asciiz "Please enter the upper limit v: "
a: .asciiz "Please enter the coefficient a: "
b: .asciiz "Please enter the coefficient b: "
c: .asciiz "Please enter the coefficient c: "
result: .asciiz "The result of the integral is: "
dx: .float 0.01

.text
main:
    li $v0, 4
    la $a0, u
    syscall

    li $v0, 6
    syscall
    mov.s $f1, $f0 # u

    li $v0, 4
    la $a0, v
    syscall

    li $v0, 6
	syscall # read v
	mov.s $f2, $f0 # $f2 = v

    li $v0, 4
    la $a0, a
    syscall

    li $v0, 6
	syscall # read a
	mov.s $f3, $f0 # $f3 = a

    li $v0, 4
    la $a0, b
    syscall

    li $v0, 6
	syscall # read b
	mov.s $f4, $f0 # $f4 = b

    li $v0, 4
    la $a0, c
    syscall

    li $v0, 6
	syscall # read c
	mov.s $f5, $f0 # $f5 = c

    li $t0, 0      # i=0
    l.s $f6, dx

	c.lt.s $f1, $f2 # Check if(u < v) or not
	li $v0, 1 # set flag = 1
	bc1f L1 # If(u >= v) goto L1
	j jump
	L1: 
	mov.s $f6, $f1 # $f6 = temp = u
	mov.s $f1, $f2 # u = v
	mov.s $f2, $f6 # v = temp
	li $v0, 0 # Set flag = 0 if u >= v
	
	jump:
	mov.s $f6, $f1 # Initialise x1 = u
	mtc1.d $zero, $f12
	cvt.s.w $f12, $f12 # Initialise result $f12 = 0
	Integral:
	c.lt.s $f6, $f2
	bc1f exit
	#calculate y = ax^2 + bx + c
	mul.s $f7, $f6, $f6 # x^2 
	mul.s $f7, $f7, $f3 # ax^2
	mul.s $f8, $f6, $f4 # bx
	add.s $f7, $f7, $f8 # ax^2 + bx
	add.s $f7, $f7, $f5 # ax^2 + bx + c
	add.s $f6, $f6, $f9 # x1 = x1 + gap
	mul.s $f7, $f7, $f9 # area of the rectangle
	add.s $f12, $f12, $f7
	jal Integral
	
	exit:
	
	beq $v0, 0, L2 
	j jumpp
	L2:
	mtc1 $v0, $f0
	cvt.s.w $f0, $f0
	sub.s $f12, $f0, $f12 # if(u >= v) result = -result
	
	jumpp:
	li $v0, 2
	syscall
	
	li $v0, 10
	syscall