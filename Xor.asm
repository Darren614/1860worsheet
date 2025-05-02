// compute z=x xor y, same as (x or y) and not(x and y)
// not modified the value initially stored in R0 and R1

@R0
D=M // D=x
@R1
D=D&M // D=x or y
D=!D // D=not(x or y)
//stored value at here temporarily
@temp1
M=D 

@R0
D=M
@R1
D=D|M
@temp1
D=D&M
@R2
M=D

