; insert act as 130
db $42

JMP Return : JMP Mario : JMP Return : JMP Return : JMP Return : JMP Return : JMP Return
JMP Mario : JMP Return : JMP Return

!NoteBlock = $A0        ; $A0 is noteblock height,
!SpringBoard = $80      ; $80 is springboard max (this is very high)

!Height = !NoteBlock
!NegateSpin = 0

Mario:
    LDA #!Height : STA $7D          ;> bounce Mario

    if !NegateSpin                  ;\
        STZ $140D|!addr             ;| negate spin jump
    endif                           ;/

    LDA #$08 : STA $1DFC|!addr      ;> play bounce noise

    %erase_block()
    %create_smoke()

Return:
    RTL

print "A single-use bounce block. Noteblock bounce height, doesn't negate spin"