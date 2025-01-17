.macro set16 value, addr
    .scope
        lda #<value
        sta addr
        lda #>value
        sta addr+1
    .endscope
.endmacro
