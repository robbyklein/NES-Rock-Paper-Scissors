.proc intro_start
	;Set scroll for true centering
	lda #$04
	sta scroll_x
	lda #$00
	sta scroll_y

	;Load the title text
	lda #$0b                    ; length
	sta scratch
	lda #$21                    ; highbyte
	sta scratch+1
	lda #$cb                    ; lowbyte
	sta scratch+2
	lda #<IntroString           ; pointer
	sta scratch+3
	lda #>IntroString           ; pointer
	sta scratch+4
	jsr load_vram_segment

	;toggle scene loaded
	lda #$01
	sta scene_loaded
.endproc

.proc intro_update
  ;Display for 3~ seconds
  lda nmi_counter
  cmp #$40
	;cmp #$05
  bne done

  ;Erase the intro text
	lda #$0b                    ; length
	sta scratch
	lda #$21                    ; highbyte
	sta scratch+1
	lda #$cb                    ; lowbyte
	sta scratch+2
	lda #<IntroString           ; pointer
	sta scratch+3
	lda #>IntroString           ; pointer
	sta scratch+4
	lda #$01
  sta scratch+5
  jsr load_vram_segment

  ; Go to title screen
  lda #$02
  sta next_scene
done:
  rts
.endproc