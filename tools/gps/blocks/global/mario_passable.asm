;insert with act as 130
db $37

JMP Mario : JMP Mario : JMP Mario
JMP Return : JMP Return : JMP Return : JMP Return
JMP Mario : JMP Mario : JMP Mario
JMP Mario : JMP Mario

Mario:
    LDY #$00            ;\ Act as air for Mario
    LDA #$25            ;|
    STA $1693|!addr     ;/
Return:
    RTL

print "A block that is only passable by Mario. To sprites, it will obey the Act as setting."