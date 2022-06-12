if read1($00FFD5) == $23
    sa1rom

    !bank = $000000
    !14C8 = $3242
    !E4 = $322C
    !14E0 = $326E
else
    lorom

    !bank = $800000
    !14C8 = $14C8
    !E4 = $E4
    !14E0 = $14E0
endif

org $038F02
    autoclean JSL Fix

freedata

Fix:
    LDA $5B
    LSR A
    BCC .return
    LDA !14E0,x
    BPL .wait
    LDA !E4,x
    CMP #$F0
    BCC .die
.return
    JML $018022|!bank

.wait
    CMP #$02
    BCC .return
.die
    STZ !14C8,x
    RTL
