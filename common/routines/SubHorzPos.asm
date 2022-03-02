;Routine that spawns a normal or custom sprite with initial speed at the position (+offset)
;of the calling sprite and returns the sprite index in Y

;Input:  None
;
;Output: Y   = 0 => Mario to the right of the sprite,
;              1 => Mario being on the left.
;        $0E = 16 bit difference beween Mario X Pos - Sprite X Pos.
;
;CAUTION!!!
;        Some sprites use a version of this routine where only $0F is being stored to
;        as the low byte of the distance (here it is the high byte)

	LDY #$00
	LDA $94
	SEC
	SBC !E4,x
	STA $0E
	LDA $95
	SBC !14E0,x
	STA $0F
	BPL ?+
	INY
?+
	RTL