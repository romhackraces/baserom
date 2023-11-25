if read1($00FFD5) == $23
    sa1rom
    !bank = $000000
else
    lorom
    !bank = $800000
endif

org $0DC4C9
    autoclean jsl fix1

org $0DC4DE
    autoclean jsl fix2
    nop

freedata

fix1:
    lda $6B : sta $04
    lda $6C : sta $05
    ldy $57
    lda $59
    rtl

fix2:
    phk : pea.w (+)-1
    pea.w $0DA414-1
    pea.w $0DA97D-1
    jml $0DA6BA|!bank
+   ldx $00
    rtl
