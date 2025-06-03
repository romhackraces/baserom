;============================================
; This hijacks runs the level_init_3 code during the
; vanilla mode 7 bosses level loading.
; This is needed because gamemode 13 UberASM code
; isn't run when loading these levels.
;============================================

pushpc

org $009856
    jsl vanilla_boss_gm13

pullpc

vanilla_boss_gm13:
    ; Restore original code
    lda #$20 : sta $44

    ; Run gamemode 13 code
    jmp level_init_3_init
