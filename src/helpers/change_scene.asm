.proc change_scene
	;Disable rendering
	jsr disable_rendering

	;Set scene loaded flag
	lda #$00
	sta scene_loaded

  ;Reset scroll
  sta scroll_x
  sta scroll_y

	;Clear the vram buffer
	jsr clear_vram_buffer

	; Clear first table
	lda #$20 ; start
	sta scratch
	lda #$23 ; end
	sta scratch+1
	jsr clear_nametable

	; Clear second table
	lda #$24 ; start
	sta scratch
	lda #$27 ; end
	sta scratch+1
	jsr clear_nametable

	; Set new scene
	lda next_scene
	sta active_scene

	; Reenable render
	jsr enable_rendering

	rts
.endproc
