// Xor.asm
// Computes R2 = R0 XOR R1 using formula: (R0 OR R1) AND NOT (R0 AND R1)

@R0
D=M          // Load R0 value into D register
@R1
D=D&M        // D = R0 & R1 (bitwise AND)
D=!D         // Invert bits: D = not(R0 & R1)
@temp1
M=D          // Store intermediate result: temp1 = NOT(R0 AND R1)

@R0
D=M          // Reload original R0 value
@R1
D=D|M        // D = R0 | R1 (bitwise OR)
@temp1
D=D&M        // Final calculation: D = (R0|R1) and not(R0&R1) → XOR result
@R2
M=D          // Store final result in R2

