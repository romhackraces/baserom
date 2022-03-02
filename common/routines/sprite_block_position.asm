;~@sa1
	LDA $0A 		;\ 
	AND #$F0 	;| Update the position
	STA $9A 		;| of the block
	LDA $0B 		;| so it doesn't react to
	STA $9B 		;| where the players at
	LDA $0C 		;|
	AND #$F0 	;|
	STA $98 		;|
	LDA $0D 		;|
	STA $99 		;/
	RTL
