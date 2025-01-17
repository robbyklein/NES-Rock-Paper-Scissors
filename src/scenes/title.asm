.proc title_start
  ; Load the title text
  lda #$13
  sta scratch
  lda #$21
  sta scratch+1
  lda #$a6
  sta scratch+2
  lda #<TitleString
  sta scratch+3
  lda #>TitleString
  sta scratch+4
  jsr load_vram_segment

  ; toggle scene loaded
  lda #$01
  sta scene_loaded

  rts
.endproc

.proc title_update
  ; Set up VRAM segment parameters for "Press Start" blink
  lda #$0C          ; Length
  sta scratch
  lda #$22          ; High byte
  sta scratch+1
  lda #$0A          ; Low byte
  sta scratch+2
  lda #<PressStartString ; Pointer
  sta scratch+3
  lda #>PressStartString ; Pointer
  sta scratch+4

  ; Determine blink state
  lda nmi_counter
  and #$3F          ; Mask lower 6 bits (60-frame cycle)
  cmp #$1E          ; Compare to 30
  bcc set_blink_off ; If less than 30, show tiles
  jmp set_blink_on

set_blink_off:
  lda #$00          ; Blink state: off
  sta scratch+5
  jmp blink_tiles

set_blink_on:
  lda #$01          ; Blink state: on
  sta scratch+5

blink_tiles:
  jsr load_vram_segment
  rts
.endproc