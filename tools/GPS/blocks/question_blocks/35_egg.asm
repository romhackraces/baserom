; Block specific defines
!SoundEffect = $02          ; Set to zero to play no sound effect
!APUPort = $1DFC|!addr      ; Refer to the RAM Map or AMK for more information

!bounce_num         = $03   ; See RAM $1699 for more details. If set to 0, the block changes into the Map16 tile directly
!bounce_direction   = $00   ; Should be generally $00
!bounce_block       = $0D   ; See RAM $9C for more details. Can be set to $FF to change the tile manually
!bounce_properties  = $00   ; YXPPCCCT properties

; If !bounce_block is $FF.
!bounce_Map16 = $0132       ; Changes into the Map16 tile directly (also used if !bounce_num is 0x00)
!bounce_tile = $2A          ; The tile number (low byte) if BBU is enabled

!item_memory_dependent = 0  ; Makes the block stay collected

; Placed there for technical reasons
incsrc question_block_base.asm

; Spawn specific defines
!egg_color      = $0B   ; $01 for palette 8
                        ; $03 for palette 9
                        ; $05 for yellow
                        ; $07 for blue
                        ; $09 for red
                        ; $0B for green
                        ; $0D for palette E
                        ; $0F for palette F
                        ; Note: This value also affects the yoshi color!

!egg_sprite     = $35   ; Sprite that will come from the egg

!egg_1up        = $78   ; Sprite that will spawn if there is a yoshi. By default, 1up.
                        ; Note: This value WON'T be used if you aren't spawning Yoshi from an egg.

!XPlacement = $00       ; Remember: $01-$7F moves the egg to the right and $80-$FF to the left.
!YPlacement = $00       ; Remember: $01-$7F moves the egg to the bottom and $80-$FF to the top.

; Code stuff
SpawnThing:
    JSL $02A9E4|!bank
    BMI .Return
    TYX
    STX $185E|!addr
    LDA #$2C
    STA !9E,x
    JSL $07F7D2|!bank

    if !XPlacement
        LDA #!XPlacement
        STA $00
    else
        STZ $00
    endif
    if !YPlacement
        LDA #!YPlacement
        STA $01
    else
        STZ $01
    endif
    TXA
    %move_spawn_relative()

    LDA #$09
    STA !14C8,x
    LDA #$D0
    STA !AA,x
    LDA #$2C
    STA !154C,x

    LDA !190F,x
    BPL +
    LDA #$10
    STA !15AC,x
+
; Copied and modified from LX5's egg blocks
if !egg_sprite == $2D || !egg_sprite == $35
    LDY #$0B
.loop
    LDA !14C8,y
    CMP #$08
    BCC .next_slot
    LDA.w !9E,y
    CMP #$2D
    BNE .next_slot
    LDA #!egg_1up
    BRA .found_and_store
.next_slot
    DEY
    BPL .loop
    LDA #!egg_sprite
    LDY $18E2|!addr
    BEQ .found_and_store
    LDA #!egg_1up
.found_and_store
else
    LDA #!egg_sprite
endif
    STA !151C,x
    LDA !15F6,x
    AND #$F1
    ORA #!egg_color
    STA !15F6,x
.Return:
RTS


if !egg_sprite == $2D || !egg_sprite == $35
print "A question mark block which contains sprite 1-Up if Yoshi exists, else Yoshi in an egg."
else
print "A question mark block which contains sprite Yoshi in an egg."
endif
