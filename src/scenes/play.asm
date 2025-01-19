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

    ; direct to correct phase
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
    ; Input handling
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
    beq end_input_check
    ; up pressed
    jmp decrement_selected
  
  increment_selected:
    lda selected_option
    cmp #$02
    beq select_first
    inc selected_option
    rts
  decrement_selected:
    lda selected_option
    cmp #$00
    beq select_last
    dec selected_option
    rts
  select_first:
    lda #$00
    sta selected_option
    rts
  select_last:
    lda #$02
    sta selected_option
    rts
  handle_select:
    ; Go to phase2
    lda #$01
    sta phase
    rts

  end_input_check:
    rts

  ; get cpu selection
  phase2:
    jsr generate_random_number
    lda random_number
    lsr
    lsr
    and #$03
    sta cpu_selection 
    lda #$02
    sta phase
    jmp done
  
  ; Determine the winner
  phase3:
    ; Load player and CPU selections
    lda cpu_selection
    sec
    sbc selected_option
    and #$03
    cmp #$01
    beq cpu_wins
    cmp #$02
    beq player_wins
  draw:
    lda #$00
    sta round_result
    jmp update_scoreboard
  cpu_wins:
    lda #$01
    sta round_result
    inc cpu_score
    lda #$00
    sta phase
    jmp update_scoreboard
  player_wins:
    lda #$02
    sta round_result
    inc player_score
    lda #$00
    sta phase
    jmp update_scoreboard

  update_scoreboard:
    lda cpu_score
    sta scratch+8
    jsr extract_digits
    ldx #$00 ;vram buffer position
    ; cpu
    LDA #$03
    STA vram_buffer, x
    inx
    LDA #$20
    STA vram_buffer, x
    inx
    LDA #$7b
    STA vram_buffer, x
    inx
    LDA scratch+9
    adc #$01
    STA vram_buffer, x
    inx
    LDA scratch+10
    adc #$01
    STA vram_buffer, x
    inx
    LDA scratch+11
    adc #$01
    STA vram_buffer ,x
    inx
    ;player
    lda player_score
    sta scratch+8
    jsr extract_digits
    LDA #$03
    STA vram_buffer, x
    inx
    LDA #$20
    STA vram_buffer, x
    inx
    LDA #$62
    STA vram_buffer, x
    inx
    LDA scratch+9
    adc #$01
    STA vram_buffer, x
    inx
    LDA scratch+10
    adc #$01
    STA vram_buffer, x
    inx
    LDA scratch+11
    adc #$01
    STA vram_buffer, x
    inx

  print_results:
    lda #$0c ; initial length (cpu selects )
    sta vram_buffer, x ; length
    inx
    lda #$23 ; highbyte
    sta vram_buffer, x
    inx
    lda #$07 ; lowbyte
    sta vram_buffer, x
    inx

    ; Render cpu selects
    ldy #$00 ; string index
  load_tile:
    lda CpuSelects, y
    sta vram_buffer, x
    inx
    iny
    cpy #$0c
    bne load_tile

    ; render their selection
    lda #$08 ; length
    sta vram_buffer, x
    inx
    lda #$23 ; high
    sta vram_buffer, x
    inx
    lda #$13 ; low
    sta vram_buffer, x
    inx

    ldy #$00 ; string index
    lda cpu_selection
    cmp #$01
    beq render_paper
    cmp #$02
    beq render_scissors 

  render_rock:

    ldy #$00 ; string index
  load_rock_tile:
    lda Rock, y
    sta vram_buffer, x
    inx
    iny
    cpy #$08
    bne load_rock_tile   
    jmp render_result

  render_paper:
    ldy #$00 ; string index
  load_paper_tile:
    lda Paper, y
    sta vram_buffer, x
    inx
    iny
    cpy #$08
    bne load_paper_tile   
    jmp render_result

  render_scissors:
    ldy #$00 ; string index
  load_scissors_tile:
    lda Scissors, y
    sta vram_buffer, x
    inx
    iny
    cpy #$08
    bne load_scissors_tile   


  render_result:
    lda #$0a ; length
    sta vram_buffer, x
    inx
    lda #$2b ; high
    sta vram_buffer, x
    inx
    lda #$47 ; low
    sta vram_buffer, x
    inx


    lda round_result
    cmp #$00
    beq render_draw
    cmp #$01
    beq render_lose


  render_win:
    ldy #$00 ; string index
  load_win_tile:
    lda Win, y
    sta vram_buffer, x
    inx
    iny
    cpy #$0a
    bne load_win_tile   
    jmp reset_phase

  render_lose:
    ldy #$00 ; string index
  load_lose_tile:
    lda Lose, y
    sta vram_buffer, x
    inx
    iny
    cpy #$0a
    bne load_lose_tile   
    jmp reset_phase

  render_draw:
    ldy #$00 ; string index
  load_draw_tile:
    lda Draw, y
    sta vram_buffer, x
    inx
    iny
    cpy #$0a
    bne load_draw_tile   

  
  reset_phase:
    lda #$00
    sta phase
  
  done:
    rts
.endproc