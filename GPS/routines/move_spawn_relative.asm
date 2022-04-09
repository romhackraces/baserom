;~@sa1
; Moves sprite to the block position plus some x/y offset
;	$00 = x offset  \ sign extended
;	$01 = y offset  /

	PHX
	TAX
	LDA $98
	AND #$F0
 	CLC : ADC $01
	STA !D8,x
	LDA #$00
	BIT $01
	BPL ?+
	DEC
?+	ADC $99
	STA !14D4,x
	LDA $9A
	AND #$F0
	CLC : ADC $00
	STA !E4,x
	LDA #$00
	BIT $00
	BPL ?+
	DEC
?+	ADC $9B
	STA !14E0,x
	PLX
	RTL
