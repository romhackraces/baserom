incsrc "../Defines/SSP.asm"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Carry: Clear if outside pipe (should be visible), Set if inside pipe (should be invisible). This will determine
;;should the sprite being carried turn invisible with the player traveling through SSP.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	PlayerPipeStatus:
		LDA !Freeram_SSP_PipeDir	;\If player is outside...
		AND.b #%00001111		;|
		BEQ Visible			;/
		LDA !Freeram_SSP_EntrExtFlg	;\...or is in a pipe, but not in his stem phase
		CMP #$01			;|
		BNE Visible			;/
		LDA !Freeram_SSP_PipeTmr	;\...or in a pipe, entering, but before Mario turns invisible.
		BNE Visible			;/
	SpriteCarried:
		LDA !14C8,x			;\...or if sprite not carried
		CMP #$0B			;|then make sprite visible.
		BNE Visible			;/
	Invisible:
		SEC
		RTL
	Visible:
		CLC
		RTL