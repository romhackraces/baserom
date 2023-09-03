if read1($00FFD5) == $23
    sa1rom
    !154C = $32DC
    !1564 = $3308
else
    lorom
    !154C = $154C
    !1564 = $1564
endif

org $028A1A
    autoclean jsl question_block_shell_fix
    nop

freecode

question_block_shell_fix:
    lda #$2C : sta !154C,x : sta !1564,x
    rtl
