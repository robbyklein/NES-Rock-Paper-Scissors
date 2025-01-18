.proc reset_scroll
lda scroll_x
sta PPU_SCROLL               ; x
lda scroll_y
sta PPU_SCROLL               ; y
rts
.endproc
