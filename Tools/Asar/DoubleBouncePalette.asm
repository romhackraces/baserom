!DoubleBouncePalette = $09     ; palette for double bounce shell 08-0F

if read1($00FFD5) == $23
    sa1rom
    !sprite_num = $3200
else
    lorom
    !sprite_num = $9E
endif

org $019F44
    autoclean jsl DoubleBounceShell

freecode

DoubleBounceShell:
    pha
    lda !sprite_num,x
    cmp #$09
    bne .NoMatch
    pla
    and #$F1
    ora.b #(!DoubleBouncePalette-$08)<<1
    bra .Return

.NoMatch:
    pla

.Return:
    ora $04       ; restore clobbered code
    ora $64
    rtl