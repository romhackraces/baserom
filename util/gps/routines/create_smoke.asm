;~@sa1
	PHP
	SEP #$30
	PHX
	LDX #$03
?loop:
	LDA $17C0|!addr,x
	BNE ?next
	
	INC $17C0|!addr,x
	LDA #$1B
	STA $17CC|!addr,x

	LDA $98
	AND #$F0
	STA $17C4|!addr,x
	LDA $9A
	AND #$F0
	STA $17C8|!addr,x
	BRA ?+

?next:
	DEX
	BPL ?loop

?+	PLX
	PLP
	RTL
