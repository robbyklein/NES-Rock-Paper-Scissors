.macro add16s addr, value
    clc             ; Clear carry for the addition to handle carry correctly between bytes

    ; Add low bytes
    lda addr        ; Load the low byte of the first number
    adc value       ; Add the low byte of the second number
    sta addr        ; Store the result back to the low byte of the first number

    ; Add high bytes, including carry
    lda addr+1      ; Load the high byte of the first number
    adc value+1     ; Add the high byte of the second number along with any carry from the low byte addition
    sta addr+1      ; Store the result back to the high byte of the first number
.endmacro
