.proc render_vram_buffer
  ldx #$00 ; Buffer index
  data_length := scratch
  
  load_segment:
    ; Load first byte
    lda vram_buffer, x
    sta data_length ; now set to 05

    ; Check if it's empty
    cmp #$00
    beq done
    inx

    ; Its not so load start address
    lda PPU_STATUS
    lda vram_buffer, x ; get highbyte
    sta PPU_ADDR ; load highbyte
    inx
    lda vram_buffer, x ; get lowbyte
    sta PPU_ADDR ; load lowbyte
    inx

    ; render data
    ldy #$00 ; spot in data
    load_data:
      ; Load first tile
      lda vram_buffer, x 
      sta PPU_DATA
      inx
      iny
      cpy data_length
      bne load_data
      jmp load_segment


  done:
    ldx #$00
    sta vram_buffer_position
    rts
.endproc