;=====================================
; set_checkpoint routine
;=====================================
set_checkpoint:
    ; If the reset value is not set, set the checkpoint.
    lda !ram_set_checkpoint : cmp #$80 : bne .set

.reset:
    ; Otherwise, reset the checkpoint.
    jsr shared_reset_checkpoint
    stz $13CE|!addr

if !save_on_checkpoint
    jsr shared_save_game
endif

if !amk
    ; Always reload the samples, just to be safe.
    lda #$FF : sta !ram_music_backup
endif

    bra .return

.set:
    ; Save individual dcsave buffers.
    ; Needed because we skip over $00F2DD, where the routine is called.
if !dcsave
    jsr shared_dcsave_midpoint
endif
    
    ; Set midway flag, just to be safe.
    lda #$01 : sta $13CE|!addr
    
    ; Check if it's a normal or custom midway.
    lda !ram_set_checkpoint+1 : cmp #$FF : bne ..custom_destination

..normal_midway:
    ; If it's the intro level, skip.
    lda $0109|!addr : beq ...no_intro
    cmp.b #!intro_level+$24 : bne .return

...no_intro:
    ; Check if this midway sets the midway entrance for the sublevel or the main level.
    jsr shared_get_checkpoint_value
    cmp #$01 : beq ...sub_midway
    cmp #$03 : bcs ...sub_midway

...main_midway:
    jsr calc_entrance
    bra +
...sub_midway:
    jsr calc_entrance_2
+
if !amk
    lda $0DDA|!addr : sta !ram_music_backup
endif
    bra .return2

..custom_destination:
    ; Set the checkpoint destination.
    rep #$20
    lda !ram_set_checkpoint : sta !ram_respawn
    sep #$20

if !amk
    ; Always reload the samples, just to be safe.
    lda #$FF : sta !ram_music_backup
endif
    
.return2:
    ; Save the midway entrance as a checkpoint.
    jsr shared_hard_save

.return:
    ; Reset the set_checkpoint address.
    lda #$FF : sta !ram_set_checkpoint : sta !ram_set_checkpoint+1
    rts

;=====================================
; calc_entrance routine
;=====================================
calc_entrance:
    ; If it's not the intro level, skip.
    %lda_13BF() : tax : bne .no_intro

    ; Set intro sublevel number as respawn point.
    rep #$20
    lda.w #!intro_sublevel : sta !ram_respawn
    sep #$20
    bra .check_midway

.no_intro:
    ; Convert $13BF value to sublevel number.
    cmp #$25 : bcc +
    clc : adc #$DC
+   sta !ram_respawn
    lda #$00 : adc #$00
..store_entrance_high:
    sta !ram_respawn+1

.check_midway:
    ; If the midway flag is not set, return.
    lda $1EA2|!addr,x : and #$40 : bne ..midway
    lda $13CE|!addr : beq .return

..midway:
    ; Set the midway flag in the respawn entrance.
    lda !ram_respawn+1 : ora #$08 : sta !ram_respawn+1

.return:
    rts

.2:
    ; Get $13BF value in X.
    %lda_13BF() : tax

    ; Set current sublevel number as the respawn point.
    lda $010B|!addr : sta !ram_respawn
    lda $010C|!addr : bra .no_intro_store_entrance_high
