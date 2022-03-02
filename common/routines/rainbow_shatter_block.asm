;~@sa1
	PHY
	LDA #$02
	STA $9C
	JSL $00BEB0|!bank
	PHB
	LDA #$02|!bank8
	PHA
	PLB
	LDA #$01
	JSL $028663|!bank
	PLB
	PLY
	RTL
