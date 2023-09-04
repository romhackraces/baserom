;If anything tries to go through the block going up, it will block it,
;otherwise it will let them pass.
;behaves $25

db $37
JMP MarioBelow : JMP return : JMP return : JMP SpriteV : JMP return : JMP return
JMP MarioFireBall : JMP return : JMP return : JMP return : JMP return : JMP solid

MarioBelow:
	LDA $7D			;\so if you stack this one-way down block,
	BMI solid		;/wouldn't make mario zip downwards very fast.
	RTL
SpriteV:
	LDA !sprite_speed_y,x
	BMI solid
	RTL
MarioFireBall:
	LDA $173D|!addr,x
	BPL return
solid:
	LDY #$01		;\become solid
	LDA #$30		;|
	STA $1693|!addr	;/
return:
	RTL

print "Solid if anything goes up"