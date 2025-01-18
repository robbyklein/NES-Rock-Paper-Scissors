.proc update_sprites
lda   #$00
sta   OAM_ADDR
lda   #$02
sta   OAM_DMA
rts
.endproc
