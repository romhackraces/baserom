;act like $130 or $100.
;This block will spawn a donut lift sprite
;based on mikeyk's code, adapted by Davros.

	!CUSTOM_SPRITE = $A0    ;>custom sprite number to generate

db $42

JMP Return : JMP MarioAbove : JMP Return : JMP Return : JMP Return : JMP Return : JMP Return
JMP MarioCorner : JMP Return : JMP Return
                    
MarioAbove:         
MarioCorner:
	LDA $7D                 ;\if Mario speed isn't downward...
	BMI Return              ;/return
	;LDA $72		;\this was buggy, if you land on top of this block
	;BNE Return		;/and jump the frame mario lands on won't count as "on ground".


	REP #$20		;\Detect if mario is standing on top of the block
	LDA $98			;|(better than using $7E:0072). Note: when mario descends onto
	AND #$FFF0		;|the top of the block, he goes slightly into the block than he
	SEC : SBC #$001C	;|should be by a maximum of 4 pixels before being "snapped" to
	CMP $96			;|the top of the block, thats why I choose $001C instead of $0020.
	SEP #$20		;|
	BCC Return		;/
	; SEC			;>custom sprite mode. CARRY IS ALREADY SET :rage: :angery:
	LDA #!CUSTOM_SPRITE
	%spawn_sprite()
       ; TAX
	LDA #$08
       STA !14C8,x
       TXA
	%move_spawn_into_block()
	%erase_block()
Return:
	RTL                     ;return

print "A Donut Lift, which will fall shortly after being stepped on."