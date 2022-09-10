pushpc
    
; Hijack level loading routine to load correct sublevel.
org $05D842
    jml mmp_main

; Make midway entrances work correctly.
org $05D9DA
    jml midway_entrance

; Make secondary exits compatible with "No Yoshi" intros.
org $05DAA3
    jsl no_yoshi

pullpc

mmp_main:
    ; If not entering from the overworld, return.
    lda $141A|!addr : bne .return

    ; If it's a secondary exit, return.
    lda $1B93|!addr : bne .return

    ; If it's not the intro level, skip.
    lda $0109|!addr : beq .no_intro

.intro:
    ; Filter title screen.
    cmp.b #!intro_level+$24 : bne ..return

    ; If the midway is set, load the level (use the backup since $1EA2 is reset earlier).
    lda $1EA2|!addr : and #$40 : bne ..midway

    ; Load the intro level.
    lda.b #!intro_level+$24 : bra ..return

..midway:
    ; Set to load level 0.
    ldx #$00
    ldy #$00
    bra .midway

..return:
    ; Return to level loading routine, after sta $13BF.
    jml $05D8A2|!bank

.no_intro:
    ; Reset layer 1 and 2 X positions.
    rep #$20
    stz $1A
    stz $1E
    sep #$20

    ; Get current translevel number.
    jsr shared_get_translevel
    tay
    asl : tax

    ; If no midway was gotten, return.
    lda $1EA2|!addr,y : and #$40 : beq .return

.midway:
    ; If we should load a secondary exit, branch.
    lda !ram_checkpoint+1,x : bit #$02 : bne .secondary_exit

    ; Store level number to load.
    rep #$20
    lda !ram_checkpoint,x : and #$01FF : sta $0E

    ; Return to level loading routine, after sta $0E/$0F.
    jml $05D8B7|!bank

.return:
    ; Return to the beginning of level loading routine.
    jml $05D847|!bank

.secondary_exit:
    ; Set entrance number.
    ora #$04 : sta $19D8|!addr
    lda !ram_checkpoint,x : sta $19B8|!addr
    stz $95
    stz $97

    ; Return to sublevel loading routine.
    jml $05D7B3|!bank

midway_entrance:
if !dynamic_ow_levels
    %lda_13BF() : tax
    lda $1EA2|!addr,x
endif

    ; Restore original code.
    and #$40 : sta $13CF|!addr

    ; If no checkpoint was gotten, continue as normal.
    beq .normal

.checkpoint:
    phx
    txa : asl : tax
    lda.l !ram_checkpoint+1,x
    plx
    and #$0A : cmp #$08 : beq .midway

.normal:
    jml $05D9EC|!bank

.midway:
    lda $1EA2|!addr,x : and #$40
    ldx $1B93|!addr : bne .normal
    jml $05D9DE|!bank

no_yoshi:
    ; Reset secondary exits flag.
    stz $1B93|!addr

    ; Restore original code.
    lda.l $05D78A|!bank,x
    rtl
