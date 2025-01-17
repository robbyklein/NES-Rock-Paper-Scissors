.macro add16 addr, value
    .scope
        clc
        lda addr
        adc value
        sta addr
        bcc Done
        inc addr+1
        
        Done:
    .endscope
.endmacro