.proc enable_rendering
  lda #%00011110 
  sta ppu_mask_next_value

  ; Return
  rts
.endproc