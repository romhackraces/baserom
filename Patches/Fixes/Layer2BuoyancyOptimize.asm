; This patch reduces the unnecessary cost of sprite interaction with layer 2,
; when the 2nd buoyancy option(disables all other sprite interaction with layer 2) is checked in a layer 2 level.


assert read1($00FFD5) != $23,      "This patch won't work in a SA-1 enabled ROM!"

	org $01808F
	autoclean JML SpriteLoopStart

	org $0180BE
	autoclean JML SpriteLoopEnd


	freecode
	SpriteLoopStart:
		LDA $1403
		BNE .ret
		LDA $190E
		AND #$40
		BEQ .ret

		LDA $5B
		PHA
		AND #$7F
		STA $5B
	.ret
		; original code
		LDA $148F
		STA $1470
		JML $818095

	SpriteLoopEnd:
		LDA $1403
		BNE .ret
		LDA $190E
		AND #$40
		BEQ .ret

		PLA
		STA $5B
	.ret
		; original code
		LDA $18DF
		BNE +
		JML $8180C3
	+
		JML $8180C9

