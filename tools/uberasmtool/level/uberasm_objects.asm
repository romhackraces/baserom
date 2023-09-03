incsrc "../../../shared/freeram.asm"

macro RunCode(code_id, code)
    REP #$20
    LDA !objectool_level_flags_freeram
    AND.w #1<<<code_id>
    SEP #$20
    BEQ +
    JSL <code>
+
endmacro

init:
    %RunCode(3, vanilla_turnaround)
    %RunCode(4, block_duplication)
.Return
    RTL

main:
    %RunCode(0, free_vertical_scroll)
    %RunCode(1, enable_sfx_echo)
    %RunCode(2, eight_frame_float)
.Return
    RTL

free_vertical_scroll:
    lda #$01 : sta $1404|!addr
    RTL

enable_sfx_echo:
    lda $1DFA|!addr : bne +
    LDA #$06 : STA $1DFA|!addr
    +
    RTL

eight_frame_float:
    LDA $15 : AND #$80 : BEQ +
    LDA #$08 : STA $14A5|!addr
    +
    RTL

vanilla_turnaround:
    lda #$01 : sta !toggle_vanilla_turnaround
    RTL

block_duplication:
    lda #$01 : sta !toggle_block_duplication
    RTL