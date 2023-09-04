;insert with act as 130
db $37

JMP Return : JMP Return : JMP Return
JMP Sprite : JMP Sprite : JMP Sprite : JMP Sprite
JMP Return : JMP Return : JMP Return
JMP Return : JMP Return

Sprite:
    LDY #$00            ;\ Act as air for Sprites
    LDA #$25            ;|
    STA $1693|!addr     ;/
Return:
    RTL

print "A block that is passable by sprites. To Mario, it will obey the Act as setting."