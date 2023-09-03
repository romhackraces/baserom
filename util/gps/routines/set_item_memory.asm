	PHP
	REP #$30
		LDA $9A
		AND #$FF00
		LSR #6
		STA $04
		LDA $9A
		AND #$0080
		LSR #7
		ORA $04
		STA $04
		LDA $98
		AND #$0100
		BEQ ?CODE_00C03A
		LDA $04
		ORA #$0002
		STA $04
?CODE_00C03A:
		LDA $13BE|!addr
		AND #$000F
		ASL
		TAX
		LDA.L $00BFFF|!bank,X
		CLC
		ADC $04
		STA $04
		TAY
		LDA $9A
		AND #$0070
		LSR #4
		TAX
	SEP #$20                  ; Accum (8 bit)
	LDA $19F8|!addr,Y
	ORA.L $00C005|!bank,X
	STA $19F8|!addr,Y
	PLP
	RTL
