// IntegerDivision.asm

// Save R0 and R1 into temporary registers
@R0
D=M
@R5
M=D             // R5 = x
@R1
D=M
@R6
M=D             // R6 = y

// Check if y is zero (invalid division)
@R6
D=M
@INVALID_DIVISION_BY_ZERO
D;JEQ

// Check if x is -32768 and y is -1 (invalid division)
@R5
D=M
@32768
D=D+A           // If x == -32768, D == 0
@CHECK_Y_MINUS1
D;JEQ
@VALID_DIVISION
0;JMP

(CHECK_Y_MINUS1)
@R6
D=M
@1
D=D+A           // If y == -1, D == 0
@INVALID_OVERFLOW
D;JEQ
@VALID_DIVISION
0;JMP

(INVALID_DIVISION_BY_ZERO)
@0
D=A
@R2
M=D             // R2 = 0
@R3
M=D             // R3 = 0
@1
D=A
@R4
M=D             // R4 = 1 (invalid)
@END
0;JMP

(INVALID_OVERFLOW)
@0
D=A
@R2
M=D             // R2 = 0
@R3
M=D             // R3 = 0
@1
D=A
@R4
M=D             // R4 = 1 (invalid)
@END
0;JMP

(VALID_DIVISION)
// Compute signs of x and y
@R5
D=M
@X_IS_NEGATIVE
D;JLT
(X_IS_POSITIVE)
@sign_x
M=1
@CHECK_Y_SIGN
0;JMP
(X_IS_NEGATIVE)
@sign_x
M=-1

(CHECK_Y_SIGN)
@R6
D=M
@Y_IS_NEGATIVE
D;JLT
(Y_IS_POSITIVE)
@sign_y
M=1
@COMPUTE_ABS_X
0;JMP
(Y_IS_NEGATIVE)
@sign_y
M=-1

(COMPUTE_ABS_X)
@R5
D=M
@abs_x
M=D
@abs_x
D=M
@MAKE_ABS_X_POS
D;JGE
@abs_x
M=-D
(MAKE_ABS_X_POS)

(COMPUTE_ABS_Y)
@R6
D=M
@abs_y
M=D
@abs_y
D=M
@MAKE_ABS_Y_POS
D;JGE
@abs_y
M=-D
(MAKE_ABS_Y_POS)

// Compute quotient_abs (abs_x // abs_y)
@quotient_abs
M=0
@abs_x
D=M
@remainder_abs
M=D

(DIV_LOOP)
@abs_y
D=M
@remainder_abs
D=M-D
@END_DIV_LOOP
D;JLT
@abs_y
D=M
@remainder_abs
M=M-D
@quotient_abs
M=M+1
@DIV_LOOP
0;JMP

(END_DIV_LOOP)

// Determine sign of m
@sign_x
D=M
@sign_y
D=D*M
@sign_m
M=D

// Calculate m = quotient_abs * sign_m
@quotient_abs
D=M
@sign_m
D=D*M
@m
M=D

// Compute product = y * m (using absolute values and sign)
@R6
D=M
@abs_y_copy
M=D
@abs_y_copy
D=M
@MAKE_ABS_Y_COPY_POS
D;JGE
@abs_y_copy
M=-D
(MAKE_ABS_Y_COPY_POS)

@m
D=M
@abs_m
M=D
@abs_m
D=M
@MAKE_ABS_M_POS
D;JGE
@abs_m
M=-D
(MAKE_ABS_M_POS)

// Multiply abs_y_copy and abs_m
@product_abs
M=0
@abs_m
D=M
@counter
M=D

(MULT_LOOP)
@counter
D=M
@END_MULT
D;JEQ
@abs_y_copy
D=M
@product_abs
M=M+D
@counter
M=M-1
@MULT_LOOP
0;JMP

(END_MULT)

// Determine product_sign
@R6
D=M
@y_negative
M=0
@CHECK_Y_SIGN_FOR_PRODUCT
D;JGE
@y_negative
M=1

(CHECK_Y_SIGN_FOR_PRODUCT)
@m
D=M
@m_negative
M=0
@CHECK_M_SIGN_FOR_PRODUCT
D;JGE
@m_negative
M=1

(CHECK_M_SIGN_FOR_PRODUCT)
@y_negative
D=M
@m_negative
D=D-M
@SAME_SIGN_PRODUCT
D;JEQ
@product_sign
M=-1
@END_PRODUCT_SIGN
0;JMP

(SAME_SIGN_PRODUCT)
@product_sign
M=1

(END_PRODUCT_SIGN)
@product_abs
D=M
@product_sign
D=D*M
@product
M=D

// Compute q = x - product
@R5
D=M
@product
D=D-M
@q
M=D

// Set R2, R3, R4
@m
D=M
@R2
M=D
@q
D=M
@R3
M=D
@0
D=A
@R4
M=D

(END)
@END
0;JMP