



.proc title_start
	;Set scroll for true centering
	lda #$04
	sta scroll_x
	lda #$04
	sta scroll_y

	;Load the title text
	lda #$13                    ; length
	sta scratch
	lda #$21                    ; highbyte
	sta scratch+1
	lda #$a7                    ; lowbyte
	sta scratch+2
	lda #<TitleString           ; pointer
	sta scratch+3
	lda #>TitleString           ; pointer
	sta scratch+4
	lda #$00
  sta scratch+5
	jsr load_vram_segment

	;toggle scene loaded
	lda #$01
	sta scene_loaded

	rts
.endproc

.proc title_update
	lda #$0b                    ; Length
	sta scratch
	lda #$22                    ; High byte
	sta scratch+1
	lda #$0b                    ; Low byte
	sta scratch+2
	lda #<PressStartString      ; Pointer
	sta scratch+3
	lda #>PressStartString      ; Pointer
	sta scratch+4
	lda nmi_counter
	and #$3F                    ; Mask lower 6 bits (60-frame cycle)
	cmp #$1E                    ; Compare to 30
	bcc set_blink_off           ; If less than 30, show tiles
	jmp set_blink_on

set_blink_off:
	lda #$00                    ; Blink state: off
	sta scratch+5
	jmp blink_tiles

set_blink_on:
	lda #$01                    ; Blink state: on
	sta scratch+5

blink_tiles:
	jsr load_vram_segment

	;Enable input on 32nd frame if no input pressed
	lda nmi_counter
	cmp #$20                    ; check nmi counter
	bne skip_enabling_input
	lda input                   ; check input empty
	cmp #$00
	bne skip_enabling_input
	lda #$01                    ; enable input
	sta input_mode

skip_enabling_input:
	lda input                   ; load the input
	and #BUTTON_START           ; check if start is pressed
	sta scratch                 ; save the result
	lda previous_input          ; Load the previous input
	eor scratch                 ; Compare current and previous (detect change)
	and scratch                 ; Mask to see if Start is newly pressed
	beq not_pressed             ; If 0, Start is not newly pressed

	;if start is pressed
	jsr seed_rng
	lda #$03
	sta next_scene

	; if start is not pressed
not_pressed:
	rts
	.endproc
