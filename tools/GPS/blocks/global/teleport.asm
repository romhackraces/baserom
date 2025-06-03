; act as 25
db $37

JMP Teleport : JMP Teleport : JMP MarioSide
JMP Return : JMP Return : JMP Return : JMP Return
JMP Teleport : JMP Teleport : JMP MarioHead
JMP Teleport : JMP Teleport

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
    BNE TeleportY
    PLY
	RTL

TeleportY:
	PLY
Teleport:
	%teleport_direct()
Return:
	RTL

print "Will teleport Mario to the screen exit configured in Lunar Magic that this block is placed on."