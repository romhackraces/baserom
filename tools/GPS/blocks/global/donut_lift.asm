; act like $130 or $100
; This block will spawn a donut lift sprite based on mikeyk's code, adapted by Davros.
; Cleaned up by AmperSam.

!Sprite = $A0

db $42

JMP Return : JMP MarioAbove : JMP Return : JMP Return : JMP Return : JMP Return : JMP Return
JMP MarioCorner : JMP Return : JMP Return

MarioAbove:
MarioCorner:
	LDA $7D                 ;\if Mario speed isn't downward...
	BMI Return              ;/return

	REP #$20                ;\Detect if mario is standing on top of the block
	LDA $98                 ;|(better than using $7E:0072). Note: when mario descends onto
	AND #$FFF0              ;|the top of the block, he goes slightly into the block than he
	SEC : SBC #$001C        ;|should be by a maximum of 4 pixels before being "snapped" to
	CMP $96                 ;|the top of the block, thats why I choose $001C instead of $0020.
	SEP #$20                ;|
	BCC Return              ;/

	; spawn custom donut sprite
	LDA #!Sprite
	SEC
	%spawn_sprite()
	BCS Return
	%move_spawn_into_block()
	LDA #$08
	STA !14C8,x
	%erase_block()
Return:
	RTL

print "A Donut Lift, which will fall shortly after being stepped on."