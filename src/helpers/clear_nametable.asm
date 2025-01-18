.proc clear_nametable
		start_highbyte := scratch
		end_highbyte := scratch+1

		ldx start_highbyte ; current highbyte
		ldy #$00 ; current lowbbyte
	clear_page:
		lda PPU_STATUS 
		lda #$00      
		stx PPU_ADDR                             
		sty PPU_ADDR
		nop                       
	fill_loop:
		sta PPU_DATA              
		iny                     
		cpy #$00      
		bne fill_loop
		inx
		cpx end_highbyte
		bne clear_page
	fill_loop2:
		sta PPU_DATA                
		iny                     
		cpy #$c0      
		bne fill_loop2

		rts
.endproc