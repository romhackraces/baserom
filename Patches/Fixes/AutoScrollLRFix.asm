if read1($00FFD5) == $23
	sa1rom
	!addr = $6000
	!bank = $000000
else
	lorom
	!addr = $0000
	!bank = $800000
endif

org $00CDDD
autoclean JML UnlockSprites
NOP

freedata

UnlockSprites:
    LDA $13FD|!addr
    AND $9D
    BEQ .default
    LDA $1411|!addr
    BNE .scroll
    STZ $9D

.default
    LDA $1411|!addr
    BNE .scroll
    JML $00CDDC|!bank
.scroll
    JML $00CDE2|!bank
