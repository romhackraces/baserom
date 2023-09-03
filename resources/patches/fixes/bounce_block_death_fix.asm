if read1($00FFD5) == $23
    sa1rom
    !bank = $000000
else
    lorom
    !bank = $800000
endif

org $00F182
    autoclean jml CheckDeath

freecode

CheckDeath:
    lda $71
    cmp #$09
    bne .normal
    plx
    jml $00F1F6|!bank
.normal
    lda.l $00F0EC|!bank,x
    jml $00F186|!bank
