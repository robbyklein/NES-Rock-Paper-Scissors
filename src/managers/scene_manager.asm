.proc scene_manager
		;Grab scene / loaded
		lda scene_loaded
		ldx active_scene
		cpx next_scene
		beq switch
		jsr change_scene

	switch:
		;Send to correct section
		cpx #$01
		beq Intro
		cpx #$02
		beq Title
		cpx #$03
		beq Play
		rts

	Intro:
		cmp #$00 ;Check if loaded
		bne IntroLoaded
		jsr intro_start ; if not loaded
		rts
	IntroLoaded:
		jsr intro_update
		rts

	Title:
		cmp #$00
		bne TitleLoaded
		jsr title_start
		rts
	TitleLoaded:
		jsr title_update
		rts

	Play:
		cmp #$00 ;Check if loaded
		bne PlayLoaded
		jsr play_start ; if not loaded
		rts
	PlayLoaded:
		jsr play_update
		rts
.endproc
