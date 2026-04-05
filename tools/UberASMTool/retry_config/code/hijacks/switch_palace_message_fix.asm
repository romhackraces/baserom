; This fixes the switch palace message sprite tiles having the wrong size
; when drawing sprites using UberASM Tool's gamemode 14 end label.
; This happens because vanilla only sets $0400 but not $0420.

pushpc

; This is the vanilla routine
org $05B30E
    jsl switch_palace_message_fix

; This is the Lunar Magic routine that's mostly a copy of the vanilla routine
org $03BC72
    jsl switch_palace_message_fix

pullpc

switch_palace_message_fix:
    phy
    sep #$20
    tya : lsr #2 : tay
    lda #$00 : sta $0420|!addr,y
    rep #$20
    ply
    dey #4
    rtl
