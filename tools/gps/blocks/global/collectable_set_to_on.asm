; act as 25

db $42
JMP Collect : JMP Collect : JMP Collect
JMP Return : JMP Return : JMP Return : JMP Return
JMP Collect : JMP Collect : JMP Collect

Collect:
    DEC $14AF|!addr                 ;> set switch to on
    lda #$0B : sta $1DF9|!addr      ;> play switch sound
    %glitter()
    %erase_block()
Return:
    RTL

print "A coin that changes the ON/OFF state to ON."