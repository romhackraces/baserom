;~@sa1
	LDA $0DB3|!addr		; disassembled from original smb3.bin
	ASL
	ADC $0DB3|!addr
	TAX 
	LDA $0F34|!addr,x
	CLC 
	ADC #$01
	STA $0F34|!addr,x
	LDA $0F35|!addr,x
	ADC #$00
	STA $0F35|!addr,x
	LDA $0F36|!addr,x
	ADC #$00
	STA $0F36|!addr,x
	RTL
