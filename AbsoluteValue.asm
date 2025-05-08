// AbsoluteValue.asm
// Computes z = |x| where x is in R0, stores result in R1
// R2: 1 if negative, 0 otherwise
// R3: 1 if overflow (when x = -32768), 0 otherwise


@R0
D=M  // Load R0 value into D register
@POSITIVE  // Prepare to jump to positive handling
D;JGE  // If D >= 0 (non-negative), jump to POSITIVE

// Negative number handling
@-32768      // Load minimum negative constant (-32768)
D=D+A        // D = original value + (-32768)
@IS_MIN      // Prepare jump for special case handling
D;JEQ        // If D == 0 (original was -32768), jump to IS_MIN

// Regular negative handling
@R0
D=!M         //  Bitwise NOT 
D=D+1        // Add 1 to get two's complement (absolute value)
@R1
M=D          // Store result in R1
@R2
M=1          // Set negative flag (R2=1)
@R3
M=0          // Set overflow flag (R3=0)
@END
0;JMP        // Jump to end

(IS_MIN)  // Handle -32768 special case
@R0        // Load original value address
D=M        // Get original value (-32768)
@R1
M=D        // Preserve R1=R0 as required
@R2
M=1          // Set negative flag (R2=1)
@R3
M=1          // Set overflow flag (R3=1)
@END
0;JMP        // Jump to end

(POSITIVE)   // Non-negative handling
@R0
D=M          // Reload original value
@R1
M=D          // Directly store in R1
@R2
M=0          // Set negative flag (R2=0)
@R3
M=0          // Set overflow flag (R3=0)

(END)        // Program termination
@END
0;JMP        // Infinite loop to halt