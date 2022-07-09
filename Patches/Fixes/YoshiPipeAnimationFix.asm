if read1($00FFD5) == $23
    sa1rom
    !addr = $6000
    !bank = $000000
else
    lorom
    !addr = $0000
    !bank = $800000
endif

org $01EE7D
    autoclean jml check_mounted

freedata

check_mounted:
    lda $187A|!addr : beq .no
    lda $1419|!addr : bmi .no
.yes:
    jml $01EE82|!bank
.no:
    jml $01EE8A|!bank
