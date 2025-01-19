.proc play_start
    ; Disable rendering
    jsr disable_rendering

    ; Render the default screen
    ldx #$20 ; offset
    ldy #$00 ; position
    lda #<PlayBg
    sta scratch
    lda #>PlayBg
    sta scratch+1
  :
    render_background_tiles:
      ; render each position
      lda PPU_STATUS
      stx PPU_ADDR
      sty PPU_ADDR
      lda (scratch),y
      sta PPU_DATA
      iny
      bne render_background_tiles
    ; Go to next page
    inc scratch+1
    inx
    cpx #$24
    bne :-

    ; Re-enable rendering
    jsr enable_rendering

    ; Scene loaded flag
    lda #$01
    sta scene_loaded

    lda #$08
    sta scroll_y

    ; enable input
    lda #$01
    sta input_mode

    ; reset scratch
    jsr reset_scratch

    rts
.endproc

.proc play_update
    ; Variables
    selected_option := scratch
    down_input := scratch+1
    up_input := scratch+2
    start_input := scratch+3
    tile_x := scratch+4
    tile_y := scratch+5
    phase := scratch+6
    cpu_selection := scratch+7

    ; direct to correct pahse
    lda phase
    cmp #$00
    bne check_phase2
    jmp phase1
  check_phase2:
    cmp #$01
    bne check_phase3;
    jmp phase2
  check_phase3:
    cmp #$02
    bne phase1
    jmp phase3

  phase1:
    ; Set cursor position
    lda selected_option
    cmp #$01
    beq render_paper_selector
    cmp #$02
    beq render_scissors_selector
    cmp #$03
    bne render_rock_selector
  render_rock_selector:
    LDA #$5e
    sta tile_y
    LDA #$87
    sta tile_x
    jmp render_cursor
  render_paper_selector:
    LDA #$6e
    sta tile_y
    LDA #$90
    sta tile_x
    jmp render_cursor
  render_scissors_selector:
    LDA #$7e
    sta tile_y
    LDA #$a8
    sta tile_x

  ; Render the cursor
  render_cursor:
    LDA tile_y ; Y-coord of first sprite
    STA $0200 
    LDA #$2b ; tile number of first sprite
    STA $0201 
    LDA #$00 ; attributes of first sprite
    STA $0202 
    LDA tile_x ; X-coord of first sprite
    STA $0203

    ; Input handling
  check_start_input:
    lda input
    and #BUTTON_START
    sta start_input
    lda previous_input
    eor  start_input
    and  start_input
    beq check_down_input
    ; start pressed
    jmp handle_select

  check_down_input:
    lda input
    and #BUTTON_DOWN
    sta down_input
    lda previous_input
    eor  down_input
    and  down_input
    beq check_up_input
    ; down pressed
    jmp increment_selected

  check_up_input:
    lda input
    and #BUTTON_UP
    sta up_input
    lda previous_input
    eor up_input
    and up_input
    beq post_input_handling
    ; up pressed
    jmp decrement_selected

  increment_selected:
    lda selected_option
    cmp #$02
    beq select_first
    inc selected_option
    jmp post_input_handling

  decrement_selected:
    lda selected_option
    cmp #$00
    beq select_last
    dec selected_option
    jmp post_input_handling

  select_first:
    lda #$00
    sta selected_option
    jmp post_input_handling

  select_last:
    lda #$02
    sta selected_option
    jmp post_input_handling

  handle_select:
    ; Clear the cursor
    LDA #$00
    STA $0200 
    STA $0201 
    STA $0202 
    STA $0203
    ; Go to phase2
    lda #$01
    sta phase
    rts


  post_input_handling:
    rts

  ; Phase 2 display winner
  phase2:
    ; get cpu selection
    jsr generate_random_number
    lda random_number
    lsr
    lsr
    and #$03
    sta cpu_selection 
    lda #$02
    sta phase
    jmp done
 
  phase3:
    ; Load player and CPU selections
    lda cpu_selection            ; Load the CPU's selection
    sec                           ; Set carry for subtraction
    sbc selected_option          ; Subtract player's choice from CPU's choice
    and #$03                     ; Constrain the result to 0-3 (wrap around)
    cmp #$01                     ; CPU wins if result is 1
    beq cpu_wins
    cmp #$02                     ; Player wins if result is 2
    beq player_wins

  draw:
    lda #$00
    sta phase
    rts

  cpu_wins:
    inc cpu_score
    lda #$00
    sta phase
    jmp update_scoreboard

  player_wins:
    inc player_score
    lda #$00
    sta phase
    jmp update_scoreboard

  update_scoreboard:
    lda cpu_score
    sta scratch+8
    jsr extract_digits
    ; cpu
    LDA #$03
    STA vram_buffer
    LDA #$20
    STA vram_buffer+1
    LDA #$7b
    STA vram_buffer+2
    LDA scratch+9
    adc #$01
    STA vram_buffer+3
    LDA scratch+10
    adc #$01
    STA vram_buffer+4
    LDA scratch+11
    adc #$01
    STA vram_buffer+5
    ;player
    lda player_score
    sta scratch+8
    jsr extract_digits
    LDA #$03
    STA vram_buffer+6
    LDA #$20
    STA vram_buffer+7
    LDA #$62
    STA vram_buffer+8
    LDA scratch+9
    adc #$01
    STA vram_buffer+9
    LDA scratch+10
    adc #$01
    STA vram_buffer+10
    LDA scratch+11
    adc #$01
    STA vram_buffer+11

  done:
    rts
.endproc