incsrc "../retry_config/ram.asm"

main:
    lda !ram_prompt_override
    cmp #$02 : beq draw
    cmp #$03 : beq draw
    rtl

draw:
    lda #$F6 : sta $0F19|!addr
    rtl
