;===============================================================================;
; Placeable Kicked Shell patch v1.1 by KevinM                                   ;
;                                                                               ;
; This patch will make so placing one of the sprites 4 through 7 (Koopas)       ;
; with the extra bit set to 1 will make a kicked shell of the same color        ;
; spawn instead, going towards Mario. Instead, using sprite 8 or 9 (Parakoopa)  ;
; will make the special green shell spawn (the one that can bounced on twice),  ;
; and placing a Buzzy Beetle will make a kicked Beetle shell spawn.             ;
;                                                                               ;
; Note that you need to run a sprite tool (e.g. Pixi) on your rom at least once ;
; in order for the extra bit to be properly handled.                            ;
;===============================================================================;

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
%define_sprite_table("157C", $157C, $3334)
%define_sprite_table("extra_bits",$7FAB10,$400040)

org $018AFC : autoclean jml NormalShells

org $018C4D : autoclean jml SpecialShell

freedata

SpecialShell:
    lda !extra_bits,x       ;\ Skip if the extra bit is not set.
    and #$04                ;|
    beq .skip               ;/
    bra NormalShells_shell  ;> Turn the koopa into a shell.
.skip
    lda $9D                 ;\ Original code.
    bne +                   ;|
    jml $018C51|!bank       ;|
+   jml $018CB7|!bank       ;/

NormalShells:
    lda !extra_bits,x       ;\ Skip if the extra bit is not set.
    and #$04                ;|
    beq .skip               ;/
    lda !9E,x               ;\ 
    cmp #$11                ;| Turn it into a shell if it's a Beetle.
    beq .shell              ;/
    cmp #$04                ;\ Skip if the sprite number is not between 4 and 7.
    bcc .skip               ;|
    cmp #$08                ;|
    bcs .skip               ;/
.shell                      ;> Turn the Koopa into a shell.
    lda #$0A                ;\ Set sprite state as "kicked".
    sta !14C8,x             ;/
    phy                     ;\ Set direction based on Mario's position.
    ldy #$00                ;|
    lda $94                 ;|
    sec                     ;|
    sbc !E4,x               ;|
    sta $0F                 ;|
    lda $95                 ;|
    sbc !14E0,x             ;|
    bpl +                   ;|
    iny                     ;|
+   tya                     ;|
    sta !157C,x             ;/
    phx                     ;\ Set speed based on direction.
    tyx                     ;|
    lda.l $01A6D7,x         ;|
    plx                     ;|
    ply                     ;|
    sta !B6,x               ;/
    lda #$03                ;\ Play "kicked sfx".
    sta $1DF9|!addr         ;/
    jml $018B09|!bank       ; Return to RTS.
.skip
    lda $9D                 ;\ Original code.
    beq +                   ;|
    jml $018B00|!bank       ;|
+   jml $018B0A|!bank       ;/
