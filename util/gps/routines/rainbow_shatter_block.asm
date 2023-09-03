	PHY
	PEI ($98)
	PEI ($9A)
	LDA #$02
	STA $9C
	JSL $00BEB0|!bank
	LDA $1933|!addr
	LSR
	REP #$20
	PLA
	BCS ?layer2
	STA $9A
	PLA
	BRA ?common
?layer2:
	SEC
	SBC $26
	STA $9A
	PLA
	SEC
	SBC $28
?common
	STA $98
	SEP #$20
	PHB
	LDA #$02
	PHA
	PLB
	JSL $028663|!bank
	PLB
	PLY
	RTL

