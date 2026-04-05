;===============================================================================
; Various fixes for Retry stuff in vanilla mode 7 bosses rooms
;===============================================================================

pushpc

; This hijack runs the level_init_3 code during the vanilla mode 7 bosses level
; loading. This is needed because gamemode 13 UberASM code isn't run when
; loading these levels.
org $009856
    jsl gm13

; This hijack prevents the game from changing the sprite sizes while Mario is
; dead, to avoid sprite status bar graphical glitches while respawning or going
; to the Overworld.
org $0086C7
    jml bg_init

; This hijack prepares a flag that will be used in the bg drawing loop to avoid
; putting bg tiles offscreen, since it can cause graphical glitches when the
; Retry prompt is used
org $02827D
    jsl bg_draw_before_loop : nop

; This uses the flag prepared before to skip the offscreen tiles copy
org $02832C
    jsl bg_draw_in_loop : nop

pullpc

gm13:
    ; Restore original code
    lda #$20 : sta $44
    ; Run gamemode 13 code
    jmp level_init_3_init

bg_init:
    lda $71 : cmp #$09 : beq .skip
.return:
    ; Restore original code and resume it
    rep #$30
    ldx #$0062
    jml $0086CC|!bank
.skip:
    jml $0086D8|!bank

bg_draw_before_loop:
    lda #$01 : sta $0F
    jsr shared_is_prompt_deployed : bcc .return
    stz $0F
.return:
    ; Restore original code and resume it
    lda $1A : sta $188D|!addr
    rtl

bg_draw_in_loop:
    ; If the flag is cleared, return (the game will also BEQ)
    lda $0F : beq .return
    ; Otherwise, use the vanilla check
    lda $1884|!addr : cmp #$01
.return:
    rtl
