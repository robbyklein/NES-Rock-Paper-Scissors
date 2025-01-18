.proc clear_vram_buffer
		ldy #$00 ;buffer index
		lda #$00 ;data
	loop:
		cpy #$40
		beq done
		sta vram_buffer, y
		iny
		jmp loop

	done:
		sta vram_buffer_position
		rts
.endproc

