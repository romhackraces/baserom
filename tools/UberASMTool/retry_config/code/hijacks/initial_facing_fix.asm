pushpc

if !initial_facing_fix

org $05DA1C
    jml initial_facing_fix

else ; if not(!initial_facing_fix)

; Restore the original code.
; Don't force "No Yoshi Sign 2" intro if the fix is enabled.
org $05DA1C
if not(!no_yoshi_intro_fix)
    cmp #$52
    bcc $04
else ; if !no_yoshi_intro_fix
    bra $06
    nop #2
endif ; not(!no_yoshi_intro_fix)

endif ; !initial_facing_fix

pullpc

if !initial_facing_fix

initial_facing_fix:
    ; Copy the next frame position to the current frame's.
    ; This fixes the direction for sprites using the SubHorzPosBnk1 routine.
    rep #$10
    ldx $94 : stx $D1
    ldx $96 : stx $D3
    sep #$10

    ; Restore the original code.
    ; Don't force "No Yoshi Sign 2" intro if the fix is enabled.
if not(!no_yoshi_intro_fix)
    cmp #$52 : bcc +
    jml $05DA20|!bank
+   
endif ; not(!no_yoshi_intro_fix)
    jml $05DA24|!bank

endif ; !initial_facing_fix
