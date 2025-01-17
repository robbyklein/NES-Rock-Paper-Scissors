.proc init    
    ; Enable rendering on screen
    jsr enable_rendering

    ; Set initial scene
    lda #$01
    sta active_scene

    ; Move to our main game loop
    jmp main
.endproc