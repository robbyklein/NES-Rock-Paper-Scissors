.proc poll_input
    ; Ignore input if disabled
    lda input_mode
    bne readjoy
    lda #$00
    sta input
    rts

    readjoy:
        lda #$01
        sta JOY1
        sta input
        lsr a
        sta JOY1
    loop:
        lda JOY1
        lsr a
        rol input
        bcc loop
        rts
.endproc