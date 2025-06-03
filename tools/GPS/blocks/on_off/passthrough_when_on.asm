; act as 130

db $37
JMP Switch : JMP Switch : JMP Switch : JMP Switch : JMP Switch : JMP Switch : JMP Switch
JMP Switch : JMP Switch : JMP Switch : JMP Switch : JMP Switch

Switch:
    LDA $14AF|!addr     ;\ check ON/OFF state
    BEQ Return          ;/ ...skip if ON
    LDY #$00            ;\ Act as air
    LDA #$25            ;|
    STA $1693|!addr     ;/
Return:
    RTL

print "Passthrough when switch state is OFF and the Map16 act-as when ON."