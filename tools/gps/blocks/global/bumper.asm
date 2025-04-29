; Throwblock bumper by AmperSam

; insert act as 130
db $42
JMP Return : JMP Return : JMP MarioSide : JMP Return : JMP SpriteH : JMP Return
JMP Return : JMP Return : JMP Return : JMP Return

!NudgeMario = 0                 ; set to 1 to nudge Mario slightly

!PlaySoundEffect = 1            ; set to 1 to play a sound effect on bounce
!SFXNum  = $13                  ; sound effect number
!SFXBank = $1DF9|!addr          ; sound effect bank ($1DF9, $1DFC)


Speed:
    db $E0,$20

MarioSide:
if !NudgeMario
    LDX $93
    LDA Speed,x
    STA $7B
endif
    RTL

SpriteH:
    ; Check if throw block
    LDA !9E,x
    CMP #$53
    BNE Return

    ; check if moving
    LDA !B6,x
    BEQ Return

    ; check sprite state
    LDA !14C8,x
    CMP #$0A
    BEQ SpriteBump
    CMP #$09
    BEQ SpriteBump
    RTL

SpriteBump:
    LDA !B6,x
    BMI .going_left

.going_right
    LDA #$D0 : STA !B6,x
    BRA +

.going_left
    LDA #$30 : STA !B6,x
+
    ; put in kicked state
    LDA #$0A : STA !14C8,x

    ; make block pass through
	LDY #$00
	LDA #$25
	STA $1693|!addr

	; Play sound effect
if !PlaySoundEffect
    LDA #!SFXNum : STA !SFXBank
endif

Return:
    RTL

print "Bounces throw blocks from the side."