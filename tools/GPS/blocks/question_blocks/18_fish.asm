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
!Sprite = $18               ; sprite number
!IsCustom = 0               ; 0 for normal, 1 for custom sprite
!ExtraBit = 0               ; Set extra bit of sprite
!State = $08                ; $08 for normal, $09 for carryable sprites
!1540_val = $FF             ; If you use powerups, this should be $3E
                            ; Carryable sprites use it as the stun timer

!ExtraByte1 = $00           ; First extra byte
!ExtraByte2 = $00           ; Second extra byte
!ExtraByte3 = $00           ; Third extra byte
!ExtraByte4 = $00           ; Fourth extra byte

!XPlacement = $00           ; Remember: $01-$7F moves the enemy to the right and $80-$FF to the left.
!YPlacement = $00           ; Remember: $01-$7F moves the enemy to the bottom and $80-$FF to the top.


; Code stuff
SpawnThing:
    JSL $02A9E4|!bank
    BMI .Return
    TYX
    STX $185E|!addr
    LDA #!Sprite
    STA !9E,x
    JSL $07F7D2|!bank
    !ExtraBit #= !ExtraBit&1
if !IsCustom
    LDA !9E,x
    STA !7FAB9E,x
    JSL $0187A7|!bank
    LDA.b #8|(!ExtraBit<<2)
else
    LDA.b #!ExtraBit<<2
endif
    STA !7FAB10,x
    LDA #!State
    STA !14C8,x

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

    LDA #!State
    STA !14C8,x
    LDA #!1540_val
    STA !1540,x
    LDA #$D0
    STA !AA,x
    LDA #$2C
    STA !154C,x

    LDA #!ExtraByte1
    STA !extra_byte_1,x
    LDA #!ExtraByte2
    STA !extra_byte_2,x
    LDA #!ExtraByte3
    STA !extra_byte_3,x
    LDA #!ExtraByte4
    STA !extra_byte_4,x

    LDA !190F,x
    BPL .Return
    LDA #$10
    STA !15AC,x

.Return:
RTS

print "A question mark block which contains a Fish."