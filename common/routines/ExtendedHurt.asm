;; extended sprite -> mario interaction.
	LDA $171F|!Base2,x
	CLC
	ADC #$03
	STA $04
	LDA $1733|!Base2,x
	ADC #$00
	STA $0A
	LDA #$0A
	STA $06
	STA $07
	LDA $1715|!Base2,x
	CLC
	ADC #$03
	STA $05
	LDA $1729|!Base2,x
	ADC #$00
	STA $0B
	JSL $03B664|!BankB
	JSL $03B72B|!BankB
	BCC .skip
	PHB
	LDA.b #($02|!BankB>>16)
	PHA
	PLB
	PHK
	PEA.w .return-1
	PEA.w $B889-1
	JML $02A469|!BankB
.return
	PLB 
.skip
	RTL
