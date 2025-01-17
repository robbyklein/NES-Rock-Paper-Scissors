.proc reset_handler
    ; ignore IRQs
    sei

    ; disable decimal mode     
    cld

    ; disable APU frame IRQ
    ldx #$40
    stx JOY2  

    ; Set up stack
    ldx #$ff
    txs
    inx

    ; disable NMI
    stx PPU_CTRL

    ; disable rendering 
    stx PPU_MASK

    ; disable DMC IRQs
    stx DMC_FREQ

    ; Clear vblank flag 
    bit PPU_STATUS

    ; Wait a vblack
    :  
        bit PPU_STATUS
        bpl :-

    ; Clear memory
    txa
    ClearMemory:
        sta $000,x
        sta $100,x
        sta $200,x
        sta $300,x
        sta $400,x
        sta $500,x
        sta $600,x
        sta $700,x
        inx
        bne ClearMemory

    ; Wait a vblack
    :
        bit PPU_STATUS
        bpl :-

    ; Transfer sprite memory
    lda #$02
    sta OAM_DMA
    NOP

    ; Load palletts
    lda #$3F
    sta PPU_ADDR
    lda #$00
    sta PPU_ADDR
    ldx #$00

    LoadPalettes:
        lda PaletteData, X
        sta PPU_DATA
        INX
        CPX #$20
        BNE LoadPalettes

    ; Clear nametable
    ldx #$00
    ldy #$00
    lda PPU_STATUS
    lda #$20
    sta PPU_ADDR
    lda #$00
    sta PPU_ADDR

    ClearNametable:
        sta PPU_DATA
        inx
        bne ClearNametable
        iny
        cpy #$08
        bne ClearNametable

    ; Wait a vblank
    :
        bit PPU_STATUS
        bpl :-


    ; Enable interupts
    CLI
    lda #%10000000 
    sta ppu_control_next_value
    sta ppu_control_value
    sta PPU_CTRL

    jmp init
.endproc