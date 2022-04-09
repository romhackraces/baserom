pushpc

if !initial_facing_fix

org $05DA1C
    jml initial_facing_fix

else

if read1($05DA1C) == $5C

org $05DA1C
    cmp #$52
    bcc $04

endif
endif

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
    cmp #$52 : bcc +
    jml $05DA20|!bank
+   jml $05DA24|!bank

endif
