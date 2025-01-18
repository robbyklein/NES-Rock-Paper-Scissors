	.proc nmi_handler
	;     Save registers.
	pha
	txa
	pha
	tya
	pha

	;   Only continue if next frame is ready
	lda frame_ready
	bne Done

	;   Update the sprites
	jsr update_sprites

	;   Update the ppu mask
	jsr update_ppu_mask

	;   Render background tiles
	jsr render_vram_buffer

	;   Reset scroll from ppu writes
	jsr reset_scroll

	;   Mark that we've handled the start of this frame already.
	LDA #$01
	STA frame_ready

	;   Increment frame count
	inc nmi_counter

Done:
	; Restore registers.
	pla
	tay
	pla
	tax
	pla

	rti
	.endproc
