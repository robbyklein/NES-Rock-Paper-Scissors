	.proc update_ppu_mask
	;     Load the next value
	lda   ppu_mask_next_value

	;   Store in ppu mask
	sta PPU_MASK

	;   Save to current value
	sta ppu_mask_value

	; Return
	rts
	.endproc
