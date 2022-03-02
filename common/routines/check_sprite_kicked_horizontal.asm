;Output: Carry is set if a carryable/kicked sprite hits this block

	LDA !14C8,x      ;>Sprite status
	CMP #$09         ;\If dropped, check speed
	BEQ ?+            ;/
	CMP #$0A         ;\If kicked, check speed
	BEQ ?+            ;/
	CLC              ;>Clear carry (not hit)
	RTL
?+
	LDA !B6,x        ;\If positive, skip to compare
	BPL ?+            ;/
	EOR #$FF         ;\Otherwise make it unsigned.
	INC              ;/
?+
	CMP #$08         ;\If speed of #$08 or faster, set carry
;	BCS ?+            ;/
;	CLC              ;>Clear carry (not hit)
	RTL
;?+
;	SEC              ;>Set carry (hit)
	RTL
