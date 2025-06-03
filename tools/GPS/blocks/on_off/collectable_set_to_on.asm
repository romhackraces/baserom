; act as 25

db $37
JMP Collect : JMP Collect : JMP Collect
JMP Return : JMP Return : JMP Return : JMP Return
JMP Collect : JMP Collect : JMP Collect
JMP Collect : JMP Collect

Collect:
    LDA $14AF|!addr                 ;\ check ON/OFF state
    BEQ +                           ;/ ...skip if ON
    STZ $14AF|!addr                 ;> set switch to on
    LDA #$0B : STA $1DF9|!addr      ;> play switch sound
    +
    LDA #$01 : STA $1DFC|!addr      ;> play coin sound
    %glitter()
    %erase_block()
Return:
    RTL

print "A coin that changes the switch state to ON when collected."