;~@sa1

;Usage:
;REP #$20
;LDA <level>
;%teleport()
; Output:
;	8-bit A, X, Y

	PHX
	PHY

	PHA
	STZ $88

	SEP #$30

	if !EXLEVEL
		JSL $03BCDC|!bank
	else
		LDX $95
		PHA
		LDA $5B
		LSR
		PLA
		BCC ?+
		LDX $97
	?+
	endif
	PLA
	STA $19B8|!addr,x
	PLA
	ORA #$04
	STA $19D8|!addr,x

	LDA #$06
	STA $71

	PLY
	PLX
	RTL
