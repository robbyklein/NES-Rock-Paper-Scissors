.proc scene_manager
    ; Grab scene / loaded
    lda scene_loaded
    ldx active_scene

    ; Send to correct section
    cpx #$01
    beq Title

    ; Return if scene not found
    rts

    Title:
      ; Check if loaded
      cmp #$00
      bne TitleLoaded
      
      ; If its not
      jsr title_start
      rts

      ; If it is
      TitleLoaded:
          jsr title_update
          rts

.endproc