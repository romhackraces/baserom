;~@sa1
	LDA #$02		; Replace block with block # 025
	STA $9C
	PHY
	JSL $00BEB0|!bank	; Make the block disappear.
	PLY
	RTL
