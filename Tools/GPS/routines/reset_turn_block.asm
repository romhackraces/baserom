;~@sa1
	PEI ($9A)			; from Custom Bounce Block patch's SMB3Brick.asm (shortened slightly by imamelia)
	PEI ($98)
	LDA $16A5|!addr,Y
	STA $9A
	LDA $16AD|!addr,Y
	STA $9B
	LDA $16A1|!addr,Y
	CLC
	ADC #$0C
	AND #$F0
	STA $98
	LDA $16A9|!addr,Y
	ADC #$00
	STA $99
	LDA $16C1|!addr,Y
	STA $9C
	PEI ($04)
	PEI ($06)
	JSL $00BEB0|!bank
	REP #$20
	PLA 
	STA $06
	PLA 
	STA $04
	PLA 
	STA $98
	PLA 
	STA $9A
	SEP #$20
	RTL
