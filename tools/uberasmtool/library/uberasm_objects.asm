; run in gamemode 13
incsrc "../../../shared/freeram.asm"

; run code macro
macro RunCode(code_id, code)
    REP #$20
    LDA !objectool_level_flags_freeram+(<code_id>/16)
    AND.w #1<<(<code_id>%16)
    SEP #$20
    BEQ ?+
    JSR <code>
?+
endmacro

init:
    LDA $71
    CMP #$0A
    BNE +
    JMP .return
+
    %RunCode(2, set_state_to_off)
    %RunCode(3, block_duplication)
    %RunCode(4, toggle_status_bar)
    %RunCode(7, vanilla_turnaround)
.return
    rtl

main:
    LDA $71
    CMP #$0A
    BNE +
    JMP .return
+
    %RunCode(0, free_vertical_scroll)
    %RunCode(1, no_horizontal_scroll)
    %RunCode(5, toggle_lr_scroll)
    %RunCode(6, eight_frame_float)
    %RunCode(8, enable_sfx_echo)
    %RunCode(24, retry_instant)
    %RunCode(25, retry_prompt)
    %RunCode(26, retry_bottom_left)
    %RunCode(27, retry_no_midway_powerup)
.return
    rtl

;---------------------------------------------------------------------
; Code to run for each object
; Object IDs correspond to patches/objectool/custom_object_code.asm
;---------------------------------------------------------------------

; Object 98
; Free vertical scrolling
free_vertical_scroll:
    lda #$01 : sta $1404|!addr
    rts

; Object 99
; lock horizontal scroll
no_horizontal_scroll:
    stz $1411|!addr
    rts

; Object 9A
; Set ON/OFF state to OFF
set_state_to_off:
    lda #$01 : sta $14AF|!addr
    rts

; Object 9B
; Toggle block duplication
block_duplication:
    lda #$01 : sta !toggle_block_duplication
    rts

; Object 9C
; Toggle status bar
toggle_status_bar:
    lda #$01 : sta !toggle_statusbar_freeram
    rts

; Object 9D
; Toggle l/r scroll
toggle_lr_scroll:
    lda #$01 : sta !toggle_lr_scroll_freeram
    rts

; Object 9E
; Enable eight frame float with cape
eight_frame_float:
    lda $15 : and #$80 : beq +
    lda #$08 : sta $14A5|!addr
    +
    rts

; Object 9F
; Toggle vanilla cape spin in air
vanilla_turnaround:
    lda #$01 : sta !toggle_vanilla_turnaround
    rts

; Object A0
; Enable Echo channel in inserted music
enable_sfx_echo:
    lda $1DFA|!addr : bne +
    lda #$06 : sta $1DFA|!addr
    +
    rts

; Object A1 (is skipped because of door)


; Object B0
; Use instant retry
retry_instant:
    lda #$03 : sta !retry_freeram+$11
    rts

; Object B1
; Use prompt retry
retry_prompt:
    lda #$02 : sta !retry_freeram+$11
    rts

; Object B2
; Display retry prompt in bottom left
retry_bottom_left:
    lda #$09 : sta !retry_freeram+$15
    lda #$d0 : sta !retry_freeram+$16
    rts

; Object B3
; No powerup from midways
retry_no_midway_powerup:
    lda #$00 : sta !retry_freeram+$10
    rts