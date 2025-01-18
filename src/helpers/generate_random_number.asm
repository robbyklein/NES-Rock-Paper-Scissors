	.proc generate_random_number
	lda   random_number+1
	tay                         ; store copy of high byte
	;     compute random_number+1 ($39>>1 = %11100)
	lsr                         ; shift to consume zeroes on left...
	lsr
	lsr
	sta   random_number+1       ; now recreate the remaining bits in reverse order... %111
	lsr
	eor   random_number+1
	lsr
	eor   random_number+1
	eor   random_number+0       ; recombine with original low byte
	sta   random_number+1
	;     compute random_number+0 ($39 = %111001)
	tya                         ; original high byte
	sta   random_number+0
	asl
	eor   random_number+0
	asl
	eor   random_number+0
	asl
	asl
	asl
	eor   random_number+0
	sta   random_number+0
	rts
	.endproc

	.proc seed_rng
	lda   nmi_counter           ; Load a frame counter variable
	sta   random_number         ; Store in seed low byte
	lda   nmi_counter           ; Load again (it might still be the same)
	eor   #$55                  ; Add some variation with a constant
	sta   random_number+1       ; Store in seed high byte
	rts
	.endproc
