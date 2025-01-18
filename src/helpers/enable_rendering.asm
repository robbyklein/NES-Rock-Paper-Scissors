.proc enable_rendering
	lda #%00011110
	sta PPU_MASK
	sta ppu_mask_next_value
	sta ppu_mask_value

	rts
.endproc
