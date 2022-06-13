;If anything tries to go through the block going down, it will block it,
;otherwise it will let them pass (almost exactly like tile $100 of the
;map16, may be used as a custom ledge (which you can change, just in case)).
;behaves $25

print "Solid if anything goes down"
db $37
JMP return : JMP MarioAbove : JMP return : JMP SpriteV : JMP return : JMP return
JMP MarioFireBall : JMP MarioAbove : JMP return : JMP return : JMP return : JMP return

MarioAbove:
	LDA $7D
	BPL solid
	RTL
SpriteV:
	LDA !AA,x
	BPL solid
	RTL
MarioFireBall:
	LDA $173D|!addr,x
	BMI return
solid:
	LDY #$01		;\become solid
	LDA #$30		;|
	STA $1693|!addr		;/
return:
RTL
