.proc play_start
  inc debug
  jsr disable_rendering

  ldx #$20 ; offset
  ldy #$00 ; position
  lda #<PlayBg
  sta scratch
  lda #>PlayBg
  sta scratch+1
:
  render_background_tiles:
    ; render each position
    lda PPU_STATUS
    stx PPU_ADDR
    sty PPU_ADDR
    lda (scratch),y
    sta PPU_DATA
    iny
    bne render_background_tiles
  ; Go to next page
  inc scratch+1
  inx
  cpx #$24
  bne :-

  jsr enable_rendering

  ; Scene loaded flag
  lda #$01
  sta scene_loaded

  ; enable input
  lda #$01
  sta input_mode

  ; reset scratch
  lda #$00
  sta scratch
  sta scratch+1
  sta scratch+2
  sta scratch+3
  sta scratch+4
  sta scratch+5

  rts
.endproc

.proc play_update

  ; Rendering selection
  lda scratch
  cmp #$01
  beq RenderPaperSelector
  cmp #$02
  beq RenderScissorsSelector
  cmp #$03
  bne RenderRockSelector
  lda #$00
  sta scratch
RenderRockSelector:
  LDA #$66 ; Y-coord of first sprite
  STA $0200 
  LDA #$2b ; tile number of first sprite
  STA $0201 
  LDA #$00 ; attributes of first sprite
  STA $0202 
  LDA #$87 ; X-coord of first sprite
  STA $0203
  jmp check_input
RenderPaperSelector:
  LDA #$76 ; Y-coord of first sprite
  STA $0200
  LDA #$2b ; tile number of first sprite
  STA $0201 
  LDA #$00 ; attributes of first sprite
  STA $0202 
  LDA #$90 ; X-coord of first sprite
  STA $0203
  jmp check_input
RenderScissorsSelector:
  LDA #$86 ; Y-coord of first sprite
  STA $0200
  LDA #$2b ; tile number of first sprite
  STA $0201 
  LDA #$00 ; attributes of first sprite
  STA $0202 
  LDA #$a8 ; X-coord of first sprite
  STA $0203

  ; Checking for input
check_input:
	lda input                   ; load the input
	and #BUTTON_DOWN           ; check if start is pressed
	sta scratch+1                ; save the result
	lda previous_input          ; Load the previous input
	eor  scratch+1                  ; Compare current and previous (detect change)
	and  scratch+1                    ; Mask to see if Start is newly pressed
	beq not_pressed             ; If 0, Start is not newly pressed
	;if down is pressed
	inc scratch

	; if not pressed
not_pressed:
	rts





Continue:
  rts
.endproc