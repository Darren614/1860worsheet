// IntegerDivision.asm
@R0
D=M
@x
M=D         // x = R0
@R1
D=M
@y
M=D         // y = R1

// Check that the divisor is 0
@y
D=M
@DIVIDE_BY_ZERO
D;JEQ       // if y=0 jump

// 检查溢出情况（x=-32768且y=-1）
@x
D=M
@32768
D=D+A       // D = x + 32768
@CHECK_Y
D;JEQ       // if x=-32768 check y

// Normal division process
@PROCEED
0;JMP

(CHECK_Y)
@y
D=M
@1
D=D+A       // D = y + 1
@OVERFLOW
D;JEQ       // if y=-1 jump

(PROCEED)
// Compute symbol mark
@x
D=M
@x_sign
M=0         //  default x is non-negative
@X_NEG
D;JLT       // If x is negative, jump
(X_RETURN)
@y
D=M
@y_sign
M=0         // default y is non-negative
@Y_NEG
D;JLT       // If y is negative, jump
(Y_RETURN)

//Calculated absolute value
@x
D=M
@x_abs
M=D
@x_sign
D=M
@SKIP_X_NEG
D;JEQ
@x_abs
M=!M
M=M+1       // x_abs = -x
(SKIP_X_NEG)

@y
D=M
@y_abs
M=D
@y_sign
D=M
@SKIP_Y_NEG
D;JEQ
@y_abs
M=!M
M=M+1       // y_abs = -y
(SKIP_Y_NEG)

//variable initialization
@x_abs
D=M
@remainder
M=D         // remainder = x_abs
@m_abs
M=0         // m_abs = 0

// Division loop
(LOOP)
@remainder
D=M
@y_abs
D=D-M
@END_LOOP
D;JLT       // if remainder < y_abs，END
@y_abs
D=M
@remainder
M=M-D       // remainder -= y_abs
@m_abs
M=M+1       // m_abs += 1
@LOOP
0;JMP

(END_LOOP)
// Adjust quotient symbol
@x_sign
D=M
@y_sign
D=D-M
@SAME_SIGN
D;JEQ       // Skip if the symbol is the same
@m_abs
M=-M        // If the signs are different, take the opposite
(SAME_SIGN)

//Adjust the remainder sign
@x_sign
D=M
@Q_POS
D;JEQ       
@remainder
M=-M       
(Q_POS)

// 存储结果
@m_abs
D=M
@R2
M=D         // R2 = m
@remainder
D=M
@R3
M=D         // R3 = q
@R4
M=0         // R4 = 0（valid）
@END
0;JMP

// 异常处理分支
(DIVIDE_BY_ZERO)
@R4
M=1         // R4 = 1（invalid）
@END
0;JMP

(OVERFLOW)
@R4
M=1         
@END
0;JMP

// Symbol calculation auxiliary label
(X_NEG)
@x_sign
M=1         // x is negative
@X_RETURN
0;JMP

(Y_NEG)
@y_sign
M=1         // y is negative
@Y_RETURN
0;JMP

(END)
@END
0;JMP       // END