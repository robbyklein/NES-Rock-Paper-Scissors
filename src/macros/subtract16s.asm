.macro subtract16s num1, num2, result
    sec             ; Ensure carry is set to start, affecting the borrow for subtraction.

    ; Subtract low bytes
    lda num1        ; Load the low byte of num1.
    sbc num2        ; Subtract the low byte of num2.
    sta result      ; Store the result's low byte.

    ; Subtract high bytes, including borrow
    lda num1+1      ; Load the high byte of num1.
    sbc num2+1      ; Subtract the high byte of num2, including any borrow.
    sta result+1    ; Store the result's high byte.
.endmacro