.proc disable_rendering
  lda #%00000110 
  sta ppu_mask_next_value

  ; Return
  rts
.endproc