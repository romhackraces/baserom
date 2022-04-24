ORG $00C4F8
	autoclean JML hack
	NOP

freecode

hack:
	LDA $71
	BEQ +
		STZ.w $13FB
	+       
	LDA.w $13FB
	BEQ +
		JML $00C58F
	+
	JML $00C500