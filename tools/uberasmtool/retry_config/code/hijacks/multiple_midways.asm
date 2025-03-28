pushpc
    
; Hijack level loading routine to load correct sublevel.
org $05D842
    jml mmp_main

; Make midway entrances work correctly.
org $05D9DA
    jml midway_entrance

; Make vanilla midway entrances work correctly
org $05D9EC
    jml vanilla_midway_destination_fix

; Make secondary exits compatible with "No Yoshi" intros.
org $05DAA3
    jsl no_yoshi

pullpc

; Write a small identifier string in ROM.
db "Retry patch v!version by KevinM"

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

    ; If we should load the Yoshi Wings level, do it.
    bit #$80 : beq +
    bit #$0A : bne +
    lda #$02 : sta $1B95|!addr
    dec : sta $0DC1|!addr
+
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
    ; Check if the checkpoint destination is a midway entrance.
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

vanilla_midway_destination_fix:
    ; Skip if entering from the Overworld.
    lda $141A|!addr : beq .orig2

    ; Skip if not respawning in the level from Retry.
    lda !ram_is_respawning : beq .orig2

    ; Skip if the respawn entrance is not a midway entrance.
    lda !ram_respawn+1 : and #$0A : cmp #$08 : beq .midway

.orig2:
    jmp .orig

.midway:
    ; Get the destination level number in Y.
    rep #$30
    lda !ram_respawn : and #$01FF : tay
    sep #$20

    ; Check if the LM midway entrance patch is enabled.
    lda.l !rom_lm_midway_entrance_hack_byte : cmp #$22 : beq ..lm_midway_hack

..vanilla:
    ; If no separate entrances used, we just need to store the correct screen number.
    lda $F400,y : lsr #4 : sta $01
    jmp .orig

..lm_midway_hack:
    ; Backup $03 and $05
    pei ($03)
    pei ($05)

    ; Get the midway data pointer in $03
    lda.l $05D9E6|!bank : sta $05
    rep #$20
    lda.l $05D9E4|!bank : clc : adc #$000A : sta $03
    lda [$03] : pha
    inc $03
    lda [$03] : sta $04
    pla : sta $03
    sep #$20

    ; Set the screen number of midway entrance
    lda [$03],y : and #$10 : sta $01
    lda $F400,y : lsr #4 : ora $01 : sta $01

    ; Separate midway -> already set correctly
    lda [$03],y : bit #$20 : bne ..return

    ; Correct slippery/water flag for vanilla midway
    lda #$C0 : trb $192A|!addr
    lda $DE00,y : and #$C0 : ora $192A|!addr : sta $192A|!addr

    ; Correct the camera position for vanilla midway
    lda #$00 : xba
    lda $F400,y : sta $02
    and #$03 : tax
    lda $D70C,x : sta $20
    lda $02 : and #$0C : lsr #2 : tax
    lda $D708,x : sta $1C

    ; Correct the position if X/Y pos method 2 is used
    lda $D97D : cmp #$22 : bne ..return

    ; (now compatible with LM 3.00's routine at $05DD30)
    lda $D980 : sta $05
    rep #$20
    lda $D97E : clc : adc #$0004 : sta $03
    sep #$20
    jsl .jml

..return:
    ; Restore $03 and $05
    rep #$20
    pla : sta $05
    pla : sta $03
    sep #$20

.orig:
    rep #$10
    lda $01
    jml $05D9F0|!bank

.jml:
    jml [$0003|!dp]

no_yoshi:
    ; Reset secondary exits flag.
    stz $1B93|!addr

    ; Restore original code.
    lda.l $05D78A|!bank,x
    rtl
