;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; An alternative to %check_sprite_kicked_horizizontal(). Unlike the
; other code, this one is more accurate to how SMW handles block
; interaction.
; In particular, this happens regardless of speed but it also
; handles a special case for Koopas which can only interact with
; blocks when kicked, never dropped unlike, say, Buzzy Beetles.
; Result is the same: Carry clear means not kicked, carry set means
; kicked.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	LDA !B6,x
	BEQ ?No
	LDA !14C8,x
	CMP #$0A
	BEQ ?Okay
	LDA !9E,x
	CMP #$0D
	BCC ?No
	LDA !14C8,x
	CMP #$09
	BEQ ?Okay

?No:
	CLC
RTL

?Okay:
	SEC
RTL
