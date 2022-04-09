;Routine that star-kills the sprite and gives Mario points.
;Doesn't check whether Mario actually has a star.
		PHB
		PHK
		PLB
		JSL $01AB6F|!BankB
		LDA #$02                ; \ sprite status = 2 (being killed by star)
		STA !14C8,x             ; /
		LDA #$D0                ; \ set y speed
		STA !AA,x               ; /
		JSR .SubHorzPos
		LDA .speed,y            ; \ set x speed based on sprite direction
		STA !B6,x               ; /
		INC $18D2|!Base2        ; increment number consecutive enemies killed
		LDA $18D2|!Base2        ; \
		CMP #$08                ; | if consecutive enemies stomped >= 8, reset to 8
		BCC ?+                   ; |
		LDA #$08                ; |
		STA $18D2|!Base2        ; /
?+		JSL $02ACE5|!BankB      ; give mario points
		LDY $18D2|!Base2        ; \ 
		CPY #$08                ; | if consecutive enemies stomped < 8 ...
		BCC ?+                   ; |
		LDY #$08
?+		LDA .sound,y            ; |    ... play sound effect
		STA $1DF9|!Base2        ; /
		PLB						;
		RTL                     ; final return

.speed	db $F0,$10
.sound	db $00,$13,$14,$15,$16,$17,$18,$19,$03

.SubHorzPos
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
?+		RTS 