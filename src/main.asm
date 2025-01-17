;   Defines
.include "base/constants.asm"
.include "base/charmap.asm"
.include "macros/all.asm"

;   Segments
.segment "INESHDR"
    .include "base/header.asm"

.segment "ZEROPAGE"
    debug: .res 1
    debug2: .res 1
    nmi_counter: .res 1
    frame_ready: .res 1
    ppu_mask_value: .res 1
    ppu_mask_next_value: .res 1
    ppu_control_next_value: .res 1
    ppu_control_value: .res 1
    input: .res 1
    input_mode: .res 1
    scene_loaded: .res 1
    active_scene: .res 1
    scratch: .res 16
    vram_buffer_position: .res 1
    vram_buffer: .res 128

.segment "BSS"

.segment "DMC"

.segment "CODE"
    .include "base/init.asm"
    .include "handlers/all.asm"
    .include "helpers/all.asm"
    .include "managers/all.asm"
    .include "scenes/all.asm"

.segment "RODATA"
    PaletteData: .incbin "assets/palettes.pal"
    TitleString:
        .byte "rock paper scissors"
    PressStartString:
        .byte "press start"

.segment "VECTORS"
    .addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
    .incbin "assets/tiles.chr"