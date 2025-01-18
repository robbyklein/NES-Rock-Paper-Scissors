	.proc main
	;     Wait for nmi to finish

:
	lda frame_ready
	beq :-

	;   Poll input
	jsr poll_input

	;   move to correct scene
	jsr scene_manager

	;   Complete this frame and have nmi do work
	lda #$00
	sta frame_ready

	;   Infinite
	jmp main
.endproc
