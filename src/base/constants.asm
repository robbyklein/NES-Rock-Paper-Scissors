; NES CPU Registers
PPU_CTRL        = $2000    ; PPU Control Register
PPU_MASK        = $2001    ; PPU Mask Register
PPU_STATUS      = $2002    ; PPU Status Register
OAM_ADDR        = $2003    ; OAM Address Port
OAM_DATA        = $2004    ; OAM Data Port
PPU_SCROLL      = $2005    ; PPU Scrolling Position Register
PPU_ADDR        = $2006    ; PPU Address Port
PPU_DATA        = $2007    ; PPU Data Port
OAM_DMA         = $4014    ; OAM DMA Control

; APU and IO Registers
SQUARE1_VOL     = $4000    ; Square Wave 1 Volume/Envelope
SQUARE1_SWEEP   = $4001    ; Square Wave 1 Sweep
SQUARE1_LO      = $4002    ; Square Wave 1 Low Byte of Timer
SQUARE1_HI      = $4003    ; Square Wave 1 High Byte of Timer
SQUARE2_VOL     = $4004    ; Square Wave 2 Volume/Envelope
SQUARE2_SWEEP   = $4005    ; Square Wave 2 Sweep
SQUARE2_LO      = $4006    ; Square Wave 2 Low Byte of Timer
SQUARE2_HI      = $4007    ; Square Wave 2 High Byte of Timer
TRIANGLE_LINEAR = $4008    ; Triangle Wave Linear Counter
TRIANGLE_LO     = $400A    ; Triangle Wave Low Byte of Timer
TRIANGLE_HI     = $400B    ; Triangle Wave High Byte of Timer
NOISE_VOL       = $400C    ; Noise Generator Volume/Envelope
NOISE_LO        = $400E    ; Noise Generator Low Byte of Timer
NOISE_HI        = $400F    ; Noise Generator High Byte of Timer
DMC_FREQ        = $4010    ; DMC Playback Frequency
DMC_RAW         = $4011    ; DMC Direct Load
DMC_START       = $4012    ; DMC Sample Address
DMC_LEN         = $4013    ; DMC Sample Length
APU_STATUS      = $4015    ; APU Channel Enable/Status
JOY1            = $4016    ; Joystick 1 Data
JOY2            = $4017    ; Joystick 2 Data

; Mirrors of $2000-$2007 repeat every 8 bytes from $2008-$3FFF

; PPU Mirroring Registers
VRAM_ADDR1      = $2000    ; VRAM Address Register 1
VRAM_ADDR2      = $2001    ; VRAM Address Register 2
VRAM_IO         = $2007    ; VRAM I/O Register

; Button masks
BUTTON_A      = %10000000  ; A button mask
BUTTON_B      = %01000000  ; B button mask
BUTTON_SELECT = %00100000  ; Select button mask
BUTTON_START  = %00010000  ; Start button mask
BUTTON_UP     = %00001000  ; Up button mask
BUTTON_DOWN   = %00000100  ; Down button mask
BUTTON_LEFT   = %00000010  ; Left button mask
BUTTON_RIGHT  = %00000001  ; Right button mask