;%check_sprite_kicked_vertical()
; Carry set   = Block hit
; Carry clear = Block not hit

	LDA !AA,x         ;\If falling downwards, clear carry
	BPL ?+             ;/
	LDA !14C8,x       ;\If dropped or kicked, set carry
	CMP #$09          ;|
	BEQ ?++            ;|
	CMP #$0A          ;|
	BEQ ?++            ;/
?+	CLC               ;>Clear carry (not hit)
	RTL
?++	SEC               ;>Set carry (hit)
	RTL
