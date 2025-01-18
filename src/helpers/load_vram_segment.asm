.proc load_vram_segment
data_length := scratch
highbyte  := scratch+1
lowbyte   := scratch+2
data_pointer := scratch+3
eraseMode := scratch+5

	;   Load the vram buffer
	ldy #$00                    ; data index
	ldx vram_buffer_position    ; buffer index

	;   Load vram buffer with length
	lda data_length
	sta vram_buffer, x
	inx

	;   Load high byte
	lda highbyte
	sta vram_buffer, x
	inx

	;   Load low byte
	lda lowbyte
	sta vram_buffer, x
	inx

	; Load the data

load_loop:
	lda #$00
	cmp eraseMode
	bne tile
	lda (data_pointer), y

tile:
	sta vram_buffer, x
	iny
	inx
	cpy data_length
	bne load_loop

	;   Store a null terminator (optional, for debugging or signaling)
	lda #$00
	sta vram_buffer, x

	;   Store the next VRAM buffer position
	stx vram_buffer_position

	rts
	.endproc
