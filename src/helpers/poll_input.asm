.proc poll_input

readjoy:
	;   load a with last input
	lda input
	sta previous_input
	;   get new input
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
