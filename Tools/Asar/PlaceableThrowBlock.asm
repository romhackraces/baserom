;===============================================================================;
; Placeable (Kicked) Throw Block patch by KevinM                                ;
;                                                                               ;
; This patch will make so placing sprite 53 with extra bit set to 0 will spawn  ;
; a stationary Throw Block sprite. Instead, setting the extra bit to 1 will     ;
; spawn a kicked Throw Block in the direction of the player.                    ;
;===============================================================================;

; "Time to disappear" set when placing a stationary block (vanilla value = $FF)
; Setting it to $00 will make blocks placed directly in LM never disappear.
!DisappearTime = $FF

; Throw Block speed when in the kicked state ($00-$7F).
!KickedSpeed   = $30

if read1($00FFD5) == $23
    sa1rom
    !sa1 = 1
    !addr = $6000
    !bank = $000000
else
    lorom
    !sa1 = 0
    !addr = $0000
    !bank = $800000
endif

macro define_sprite_table(name, addr, addr_sa1)
    if !sa1 == 0
        !<name> = <addr>
    else
        !<name> = <addr_sa1>
    endif
endmacro

%define_sprite_table("9E", $9E, $3200)
%define_sprite_table("B6", $B6, $B6)
%define_sprite_table("E4", $E4, $322C)
%define_sprite_table("14C8", $14C8, $3242)
%define_sprite_table("14D4", $14D4, $3258)
%define_sprite_table("14E0", $14E0, $326E)
%define_sprite_table("1540", $1540, $32C6)
%define_sprite_table("157C", $157C, $3334)
%define_sprite_table("extra_bits",$7FAB10,$400040)

; Make Throw Block init pointer point to Key/Baby Yoshi init
org $018223 : dw $8435

; Hijack Key/Baby Yoshi init to handle Throw Blocks
org $018435 : autoclean jml InitThrowBlock

freedata

InitThrowBlock:
    lda !9E,x               ;\ If Key/Baby Yoshi, just set state as "carryable".
    cmp #$53                ;|
    bne .SetCarryable       ;/
.ThrowBlock
    lda !extra_bits,x       ;\ Set stationary state if extra bit is not set.
    and #$04                ;|
    beq .Stationary         ;/
.Kicked
    lda #$0A                ;\ Set state as "kicked".
    sta !14C8,x             ;/
    lda #$03                ;\ Play "kicked sfx".
    sta $1DF9|!addr         ;/
    phy                     ;\ Set direction based on relative position with Mario.
    ldy #$00                ;|
    lda $94                 ;|
    sec                     ;|
    sbc !E4,x               ;|
    lda $95                 ;|
    sbc !14E0,x             ;|
    bpl +                   ;|
    iny                     ;|
+   tya                     ;|
    sta !157C,x             ;/
    phx                     ;\ Set X speed based on direction.
    tyx                     ;|
    lda.l .KickedSpeeds,x   ;|
    plx                     ;|
    ply                     ;|
    sta !B6,x               ;/
    bra .Return
.Stationary
    lda #!DisappearTime     ;\ Set stun timer.
    sta !1540,x             ;/
.SetCarryable
    lda #$09                ;\ Set state as "carryable".
    sta !14C8,x             ;/
.Return
    jml $01843A|!bank

.KickedSpeeds:
    db !KickedSpeed, -!KickedSpeed
