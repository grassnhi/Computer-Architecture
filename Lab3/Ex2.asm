.data
u: .asciiz "Please enter the lower limit u: "
v: .asciiz "Please enter the upper limit v: "
a: .asciiz "Please enter the coefficient a: "
b: .asciiz "Please enter the coefficient b: "
c: .asciiz "Please enter the coefficient c: "
n: .float 100.0
zero: .float 0.0
one: .float 1.0
two: .float 2.0
three: .float 3.0
result: .asciiz "The result of the integral is: "


.text
main:
    li $v0, 4
    la $a0, u
    syscall

    li $v0, 6
    syscall
    mov.s $f1, $f0  # $f1 = u

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

    # Integral using definition
	sub.s $f6, $f2, $f1 # $f6 = v - u
    l.s $f7, n
	div.s $f6, $f6, $f7 # divide [u, v] by $f7
    #abs.s $f6, $f6

    li $t0, 1 # set flag = 1

    c.lt.s $f1, $f2 # Check if(u < v) or not
	bc1f switch # false, go to switch
	j initialise

	switch: 
        mov.s $f7, $f1 # $f7 = temp = u
        mov.s $f1, $f2 # u = v
        mov.s $f2, $f7 # v = temp
        li $t0, 0 # Set flag = 0 if u >= v

    initialise:
        mov.s $f7, $f1 # Initialise x1($f7) = u
        mtc1.d $zero, $f12
        cvt.s.w $f12, $f12 # Initialise result $f12 = 0
        l.s $f10, two
        l.s $f11, three
        l.s $f13, one

    calculate:
        c.le.s $f7, $f2
	bc1f checkSign

        mul.s $f8, $f7, $f7 # x^2 ($f7=x1 = x2 =..=x) 

        mul.s $f14, $f10, $f8 # 2x^2
        mul.s $f15, $f11, $f7 # 3x
        add.s $f14, $f14, $f15 # 2x^2+3x
        add.s $f15, $f14, $f13 # 2x^2+3x+1

        mul.s $f9, $f8, $f4 # bx^2
        mul.s $f8, $f8, $f7 # x^3
        mul.s $f8, $f8, $f3 # ax^3
        add.s $f8, $f8, $f9 # ax^3 + bx^2
        add.s $f8, $f8, $f5 # ax^2 + bx + c

        div.s $f8, $f8, $f15 # ()/()
        add.s $f7, $f7, $f6 # x1 = x1 + dx
        mul.s $f8, $f8, $f6 # area ()/() dx
        add.s $f12, $f12, $f8
        
        j calculate

    checkSign:
        beq $t0, 0, changeSign
	   j exit

    changeSign:
        l.s $f0, zero
        sub.s $f12, $f0, $f12 # if(u >= v) result = -result

    exit:
        li $v0, 4
        la $a0, result
        syscall

        li $v0, 2 
        syscall
        
        li $v0, 10
        syscall
