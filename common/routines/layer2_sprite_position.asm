; Gets the actual sprite position even when placed on layer 2 into $00-$03
;  Sprites x position will be in 16-bit $00
;  Sprites y position will be in 16-bit $02
; Only use this in SpriteV or SpriteH
; Starts with X = current sprite's slot
; P is preserved

	PHP
	REP #$20
		STZ $00
		STZ $02
		LDA $185E|!addr
		LSR
		BCC ?+
		LDA $26
		STA $00
		LDA $28
		STA $02
?+	SEP #$20
	LDA !E4,x
	SEC : SBC $00
	STA $00
	LDA !14E0,x
	SBC $01
	STA $01
	LDA !D8,x
	SEC : SBC $02
	STA $02
	LDA !14D4,x
	SBC $03
	STA $03
	PLP
	RTL
