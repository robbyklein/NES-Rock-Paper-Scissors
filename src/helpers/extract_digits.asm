.proc extract_digits
    number := scratch+8       ; The number to be converted
    hundreds := scratch+9   ; Store hundreds digit
    tens := scratch+10       ; Store tens digit
    ones := scratch+11       ; Store ones digit

    ; Initialize digit storage
    lda #$00
    sta hundreds
    sta tens
    sta ones

    ; Extract hundreds digit
  extract_hundreds:
    lda number
    cmp #$64                ; Compare with 100
    bcc extract_tens        ; If less than 100, move to tens
    sec
    sbc #$64                ; Subtract 100
    sta number              ; Store the new value
    inc hundreds            ; Increment hundreds digit
    jmp extract_hundreds    ; Repeat until less than 100

  extract_tens:
    lda number
    cmp #$0A                ; Compare with 10
    bcc extract_ones        ; If less than 10, move to ones
    sec
    sbc #$0A                ; Subtract 10
    sta number              ; Store the new value
    inc tens                ; Increment tens digit
    jmp extract_tens        ; Repeat until less than 10

  extract_ones:
    lda number              ; Remaining value is the ones digit
    sta ones                ; Store in ones digit

    rts
.endproc
