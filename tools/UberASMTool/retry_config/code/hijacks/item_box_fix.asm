pushpc

if !item_box_fix

org $00C572
    jml item_box_fix

else ; if not(!item_box_fix)

if read1($00C572) == $5C

org $00C572
    lda $15
    and #$08

endif ; if read1($00C572) == $5C

endif ; !item_box_fix

pullpc

if !item_box_fix

item_box_fix:
    ; Don't drop the item if Mario is dead.
    lda $71 : cmp #$09 : bne +
    jml $00C58F|!bank
+
    ; Restore original code.
    lda $15 : and #$08
    jml $00C576|!bank    

endif ; !item_box_fix
