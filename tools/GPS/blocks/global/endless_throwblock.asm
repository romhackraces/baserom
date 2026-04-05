; insert with act as 130
db $37

!MeltOtherBlocks = 0    ; set to 1 melt other blocks (one block only)

!Sprite = $53           ; throw block sprite number

JMP Mario : JMP Mario : JMP Mario : JMP Return
JMP Return : JMP Return : JMP Return : JMP Mario
JMP Mario : JMP Mario : JMP Return : JMP Return

Mario:
    LDA $1470|!addr		; \ check if player is holding an object
    ORA $148F|!addr		; /
    ORA $187A|!addr		; ...or is on Yoshi
    ORA $74				; ...or is climbing
    BNE Return

.checkInput
    LDA $16             ; use LDA $15 to not require pressing a button
    BIT #$40
    BEQ Return

if !MeltOtherBlocks
.meltOtherBlocks
    LDX #!sprite_slots-1
-
    LDA !14C8,x : CMP #$08 : BCC +
    LDA !9E,x : CMP #!Sprite : BNE +
    LDA #$04
    STA !14C8,x
    LDA #$0F
    STA !1540,x
+
    DEX
    BPL -
endif

.spawnSprite
    LDA #!Sprite
    CLC
    %spawn_sprite()
    BCS Return
    %move_spawn_into_block()
    LDA #$0B
    STA !14C8,x
    LDA #$FF
    STA !1540,x
Return:
    RTL

if !MeltOtherBlocks
    print "A throw block with an endless supply. (Limited-spawning)"
else
    print "A throw block with an endless supply."
endif
