; insert act as 25
db $42
JMP Mario : JMP Mario : JMP Mario : JMP Return : JMP Return : JMP Return : JMP Return
JMP Mario : JMP Mario : JMP Mario

Mario:
    STZ $19                     ;> remove player's powerup
    STZ $0DC2|!addr             ;> clear player's itembox
    STZ $1407|!addr             ;> remove cape flight

    LDA $13ED|!addr             ;\
    AND #%01111111              ;| remove slide state
    STA $13ED|!addr             ;/

    LDA $13F3|!addr             ;\ check if in balloon
    BEQ +                  ;/ otherwise skip
    LDA #$01 : STA $1891|!addr  ;> set p-balloon timer to 1 frame (can't do zero here)
    STZ $13F3|!addr             ;> make sure not in balloon
    +
Return:
    RTL

print "Block that makes Mario small, clears item box and removes balloon, flight, and slide state"