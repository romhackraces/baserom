; act as 25
db $37

JMP Switch : JMP Switch : JMP MarioSide
JMP Switch : JMP Switch : JMP Return : JMP Return
JMP Switch : JMP Switch : JMP MarioHead
JMP Switch : JMP Switch

SidePixelTable:
    db $02,$0D

; use a muncher hitbox so the block doesn't stick out
MarioHead:
MarioSide:
    PHY
    LDY $93
    LDA $94
    AND.B #$0F
    CMP.W SidePixelTable,y
    BNE SwitchY
    PLY
    RTL

SwitchY:
    PLY
Switch:
    LDA $14AF|!addr                 ;\ check ON/OFF state
    BNE Return                      ;/ ...skip if OFF
    LDA #$01 : STA $14AF|!addr      ;> set switch to off
    LDA #$0B : STA $1DF9|!addr      ;> play switch sound
Return:
    RTL

print "Sets the switch state to OFF when anything (incl. dead sprites) touches it."