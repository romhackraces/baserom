;This patch fixes bugs with some sprites that fail to respawn when (re)entering from the top or
;bottom of the screen. This is caused by them spawning, and then despawning when
;(re)entering from the top/bottom of the screen, when Nintendo expected them to only enter
;from the side of the screen.

;If you find any other sprites that suffered this bug, and it wasn't fix for those, feel
;free to update this patch to include those too. Thanks.

;Note to self: smw's suboffscreen routine around $01AC31 DOES NOT erase sprites if above the
;horizontal level.


;;SA-1 stuff
    !dp = $0000
    !addr = $0000
    !sa1 = 0
    !gsu = 0

if read1($00FFD6) == $15
    sfxrom
    !dp = $6000
    !addr = !dp
    !gsu = 1
elseif read1($00FFD5) == $23
    sa1rom
    !dp = $3000
    !addr = $6000
    !sa1 = 1
endif

!EXLEVEL = 0
if (((read1($0FF0B4)-'0')*100)+((read1($0FF0B4+2)-'0')*10)+(read1($0FF0B4+3)-'0')) > 253
    !EXLEVEL = 1
endif

macro define_sprite_table(name, name2, addr, addr_sa1)
if !sa1 == 0
    !<name> = <addr>
else
    !<name> = <addr_sa1>
endif
    !<name2> = !<name>
endmacro

%define_sprite_table(sprite_num, "9E", $9E, $3200)
%define_sprite_table(sprite_y_low, "D8", $D8, $3216)
%define_sprite_table(sprite_status, "14C8", $14C8, $3242)
%define_sprite_table(sprite_y_high, "14D4", $14D4, $3258)

;;hijacks
org $01BCD3             ;>Code that deletes the magikoopa's magic when below the screen.
    autoclean JSL DeleteIfBelowLvl  ;>Set it to below the level instead.
    RTS

org $019017             ;>Bullet bill
    autoclean JSL DeleteIfBelowLvl
    BRA $06

org $02BDA7             ;>Most wall-following sprites (stick to fllors, walls and ceilings).
    autoclean JSL DeleteIfBelowLvl
    BRA $06

freedata

DeleteIfBelowLvl:       ;> $01BCD3
    LDA $5B
    LSR
    BCC .HorizontalLevel
.VerticalLevel
    LDA #$E0            ;\ $00 (16 bit) = bottom of vertical level
    STA $00             ;|
    LDA $5F             ;|
    DEC                 ;|
    STA $01             ;/
    BRA .CheckPosition
.HorizontalLevel
if !EXLEVEL == 0
; LM <= 2.53
    LDA #$E0            ;\ $00 (16 bit) = bottom of horizontal level
    STA $00             ;|
    LDA #$01            ;|
    STA $01             ;/
else
; LM >= 3.00
    REP #$20            ;\ $00 (16 bit) = bottom of horizontal level
    LDA $13D7|!addr     ;|
    SEC                 ;|
    SBC #$0010          ;|
    STA $00             ;/
    SEP #$20
endif

.CheckPosition
    LDA !14D4,x         ;\ Sprite Y position
    XBA                 ;|
    LDA !D8,x           ;/
    REP #$20
    STA $02             ;> $02 (16 bit) = Sprite's Y pos
    CMP $00             ;> Bottom of vertical level
    BPL .Delete         ;> Delete if below the bottom of vertical level (or past the top).
    SEP #$20

.CheckSprite
    LDA !9E,x
    CMP #$20            ;\ Magikoopa magic
    BEQ ..Magic         ;/
    CMP #$1C            ;\ Bullet Bill (if upwards one goes above vertical level)
    BEQ ..BulletBill    ;/
;   CMP #$xx            ;\ If any more smw sprites are to be found that were bugged.
;   BEQ ..Sprite1       ;|
;   CMP #$xx            ;|
;   BEQ ..Sprite2       ;/
    RTL

..Magic
..BulletBill
    REP #$20
    LDA $02             ;\ Y pos onscreen
    SEC                 ;|
    SBC $1C             ;/
    CMP #$FF80
    BMI .Delete
    SEP #$20
    RTL

.Delete
    SEP #$20
    STZ !14C8,x         ;> Delete if below level.

.NoDelete
    RTL