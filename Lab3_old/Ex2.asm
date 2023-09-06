.data
u: .asciiz "Please enter the lower limit u: "
v: .asciiz "Please enter the upper limit v: "
a: .asciiz "Please enter the coefficient a: "
b: .asciiz "Please enter the coefficient b: "
c: .asciiz "Please enter the coefficient c: "
result: .asciiz "The result of the integral is: "
half: .float 0.5
div3: .float 3.0

# ∫v_u (ax^2 + bx + c) dx = [a/3 * x^3 + b/2 * x^2 + c * x]v_u

.text
main:
    li $v0, 4
    la $a0, u
    syscall

    li $v0, 6
    syscall
    mov.s $f1, $f0 # u
    mul.s $f2, $f0, $f0 # u^2
    mul.s $f3, $f0, $f2 # u^3

    li $v0, 4
    la $a0, v
    syscall

    li $v0, 6
    syscall
    mov.s $f4, $f0
    mul.s $f5, $f0, $f0
    mul.s $f6, $f0, $f5

    li $v0, 4
    la $a0, a
    syscall

    li $v0, 6
    syscall
    l.s $f12, div3
    div.s $f0, $f0, $f12 # a/3
    mul.s $f3, $f0, $f3 # u^3 * a/3
    mul.s $f6, $f0, $f6 # v^3 * a/3

    li $v0, 4
    la $a0, b
    syscall

    li $v0, 6
    syscall
    l.s $f12, half
    mul.s $f0, $f0, $f12 # b/2
    mul.s $f2, $f0, $f2 # u^2 * b/2
    mul.s $f5, $f0, $f5 # v^2 * b/2

    li $v0, 4
    la $a0, c
    syscall

    li $v0, 6
    syscall
    mul.s $f1, $f0, $f1 # u * c
    mul.s $f4, $f0, $f4 # v * c

    add.s $f3, $f2, $f3
    add.s $f3, $f3, $f1
    add.s $f6, $f5, $f6
    add.s $f6, $f4, $f6
    sub.s $f12, $f6, $f3

    li $v0, 4
    la $a0, result
    syscall

    li $v0, 2 
	syscall
	
	li $v0, 10
	syscall