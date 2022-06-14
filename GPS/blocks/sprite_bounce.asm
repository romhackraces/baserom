;A block that makes sprites and mario bounce with customizable height. this interacts with Mario when on/off is on.
;act as 25 plz
;coded by dogemaster 

db $42
!SpriteBounce = #$A8

JMP Mario : JMP Mario : JMP Mario
JMP Sprite : JMP Sprite : JMP Return : JMP Return
JMP Mario : JMP Mario : JMP Mario

Sprite:
	LDA !D8,x			; sprites reset their y speed when on ground so this snippet make the sprite rise by 2 pixels so y speed is changeable 
	SEC
	SBC #$02
	STA !D8,x
	
	LDA !14D4,x
	SBC #$00
	STA !14D4,x

	LDA !14C8,x			; \ The address thingy that has the value if something is alive and other shit
	CMP #$08			; | comparing to see if alive
	BCC Return			; /  
	LDA !SpriteBounce
	STA !AA,x
RTL
Mario:
Return:
RTL

print "A block that bounces sprites! But is passable by Mario."