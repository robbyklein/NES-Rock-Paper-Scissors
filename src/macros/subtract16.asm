.macro subtract16 num1, num2, result
    sec               ; Set carry to ensure proper borrow behavior.

    ; Subtract the 8-bit num2 from the low byte of num1.
    lda num1          ; Load the low byte of the 16-bit num1.
    sbc num2          ; Subtract the 8-bit num2.
    sta result        ; Store the result's low byte.

    ; Adjust the high byte of num1 for any borrow, and store it in the result's high byte.
    lda num1+1        ; Load the high byte of the 16-bit num1.
    sbc #0            ; Account for any borrow from the low byte subtraction.
    sta result+1      ; Store the result's high byte.
.endmacro