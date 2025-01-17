.proc reset_scroll
  lda #$00
  sta PPU_SCROLL ; x
  lda #$00
  sta PPU_SCROLL ; y
  rts
.endproc