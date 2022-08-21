if read1($00FFD6) == $15
	sa1rom
	!addr = $6000
elseif read1($00FFD5) == $23
	sa1rom
	!addr = $6000
else
    lorom
	!addr = $0000
endif

org $00A4D1
JSR $AE41

org $00AE41
REP #$20
LDA $0701|!addr
ASL #3
SEP #$21
ROR #3
XBA
ORA #$40
STA $2132
LDA $0702|!addr
LSR A
SEC : ROR
STA $2132
XBA
STA $2132
RTS
NOP #3