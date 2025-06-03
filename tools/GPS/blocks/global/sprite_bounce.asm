;makes sprites and mario bounce with customizable height. this interacts with Mario when on/off is on.
;act as 25 plz
;coded by dogemaster

db $42


JMP Return : JMP Return : JMP Return
JMP Sprite : JMP Sprite : JMP Return : JMP Return
JMP Return : JMP Return : JMP Return

!BounceSpeed = $A8

; Sound effect options
!PlaySoundEffect = 1            ; set to 1 to play a sound effect on bounce
!SFXNum  = $03                  ; sound effect number
!SFXBank = $1DF9|!addr          ; sound effect bank ($1DF9, $1DFC)

Sprite:

	; Play sound effect
if !PlaySoundEffect
    LDA #!SFXNum : STA !SFXBank
endif

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
	LDA #!BounceSpeed
	STA !AA,x
Return:
	RTL

print "Bounces sprites! But is passable by Mario."