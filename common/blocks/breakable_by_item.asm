; block that can be broken by a kicked or thrown item from YUMP 2 base rom

print "block that can be broken by a kicked or thrown item"

db $42
JMP Return : JMP Return : JMP Return : JMP SpriteVert : JMP SpriteHoriz : JMP Return : JMP Return : JMP Return : JMP Return : JMP Return

SpriteVert:
	
	LDA $1686,x
	AND #$04
	BNE +
	LDA $14C8,x
	CMP #$09
	BCC +
	CMP #$0B
	BCS +
	LDA $0F
	CMP #$02
	BEQ +
	JSl BREAK
+
Return:	RTL

SpriteHoriz:
	lda $9e,x
	cmp #$2d
	beq .yo
	LDA $14C8,x
	CMP #$0A
	BNE +
	JSl BREAK
+
	RTL
.yo
	LDA $14C8,x
	CMP #$09
	BNE +
	JSl BREAK
+
	RTL
BREAK:
	LDA $0F
	PHA	
	LDA #$14		;
	STA $AA,x	;
	LDA $D8,x	;
	CLC		;
	ADC #$02	;
	STA $D8,x	;
	LDA $14D4,x	;
	ADC #$00	;
	STA $14D4,x	;

	LDA $0A		; $0A-D hold the x/y of sprite contact
	AND #$F0	; have to clear the low nybble much like $98-9B
	STA $9A
	LDA $0B
	STA $9B
	LDA $0C
	AND #$F0
	SEC
	SBC #$08
	STA $98		; move y up for this (so sprites thrown below the block don't get hit)
	LDA $0D
	SBC #$00
	STA $99

	LDA $0C
	AND #$F0	; get real y for everything else
	STA $98
	LDA $0D
	STA $99

	JSL SHATTER
	PLA
	STA $0F	
	RTL

SHATTER:
	PHB
	LDA #$02
	PHA
	PLB
	LDA #$00 	;set to 0 for normal explosion, 1 for rainbow (throw blocks)
	JSL $028663 	;breaking effect
	PLB
	LDA #$07
	STA $1DFC
	
	LDA #$0F
	TRB $9A
	TRB $98		; clear low nibble of X and Y position of contact
	PHY
	PHB			;preserve current bank
	LDA #$02		;push 02
	PHA
	PLB			;bank = 02
	
	PHK
	PER $0006	; hit sprites above block
	PEA $94F3
	JML $0286ED

	PLB			;restore bank
	PLY

BLANK:
	LDA #$02 	; Replace block with blank tile
	STA $9C
	JSL $00BEB0
	RTL