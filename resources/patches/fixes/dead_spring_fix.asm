if read1($00FFD5) == $23
    sa1rom
    !sa1  = 1
    !dp   = $3000
    !addr = $6000
    !bank = $000000
    !14C8 = $3242
else
    lorom
    !sa1  = 0
    !dp   = $0000
    !addr = $0000
    !bank = $800000
    !14C8 = $14C8
endif

org $01E655
    autoclean jml check_4

freecode

check_4:
    ldy !14C8,x : cpy #$04 : beq +
    lsr
    tay
    lda $187A|!addr
    jml $01E65A|!bank
+   jml $01E6B0|!bank
