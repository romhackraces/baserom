;================================================
; Shared routines and macros.
;================================================

;================================================
; Macro to push the current code's DB to the stack
; and set the DBR to label's bank.
; Note: remember to PLB when finished!
;================================================
macro set_dbr(label)
?-  pea.w (<label>>>16)|((?-)>>16<<8)
    plb
endmacro

;================================================
; Macro to JSL to a routine that ends in RTS.
;================================================
macro jsl_to_rts(routine, rtl)
    phk : pea.w (?+)-1
    pea.w <rtl>-1
    jml <routine>|!bank
?+
endmacro

;================================================
; Macro to JSL to a routine that ends in RTS.
; Also sets up the DBR to the routine's bank.
;================================================
macro jsl_to_rts_db(routine, rtl)
    %set_dbr(<routine>)
    %jsl_to_rts(<routine>,<rtl>)
    plb
endmacro

;================================================
; Macro to load the current level number ($13BF).
; Calls the appropriate routine if dynamic OW levels are used.
;================================================
macro lda_13BF()
if !dynamic_ow_levels
    jsr shared_get_new_13BF
else
    lda $13BF|!addr
endif
endmacro

;================================================
; Functions for (H)DMA address conversion
;================================================
function dma(addr,ch)     = ((addr)+((ch)*$10))
function window_dma(addr) = dma(addr,!window_channel)
function prompt_dma(addr) = dma(addr,!prompt_channel)

;================================================
; Utility functions for tilemap and stripe image management.
;================================================
function xb(x)                = (((x)&$FF)<<8)|(((x)>>8)&$FF)
function l3_prop(pal,page)    = ($20|(((pal)&7)<<2)|((page)&1))
function l3_tile(tile,pal)    = ((tile)|((pal)<<8))
function str_header1(x,y)     = xb($5000|((y)<<5)|(x))
function str_header2(len,rle) = xb((((rle)&1)<<14)|(len))

;================================================
; Routine to get the prompt type for the current level.
;================================================
get_prompt_type:
    ; If the override address is set, skip the rest.
    lda !ram_prompt_override : bne .not_default

    ; Otherwise, if the effect for this level is set, skip the default.
    jsr get_effect_value
    cmp #$00 : bne .not_default

    ; Otheriwse, use the default value.
    lda.b #!default_prompt_type+1

.not_default:
    rts

;================================================
; Get translevel number the player is standing on the overworld.
;================================================
get_translevel:
    lda $0109|!addr : beq .no_intro
    lda #$00 : sta $13BF|!addr
    rts
.no_intro:
    ldy $0DD6|!addr
    lda $1F17|!addr,y : lsr #4 : sta $00
    lda $1F19|!addr,y : and #$F0 : ora $00 : sta $00
    lda $1F1A|!addr,y : asl : sta $01
    lda $1F18|!addr,y : and #$01 : ora $01
    ldy $0DB3|!addr
    ldx $1F11|!addr,y : beq +
    clc : adc #$04
+   sta $01
    rep #$10
    ldx $00
    lda !7ED000,x : sta $13BF|!addr
    sep #$10
if !dynamic_ow_levels
    jmp get_new_13BF_no_intro
else
    rts
endif

;================================================
; Get correct $13BF value for current level
; (for patches that change level number dynamically).
;================================================
if !dynamic_ow_levels
get_new_13BF:
    lda $0109|!addr : beq .no_intro
    lda #$00
    rts
.no_intro:
    phb
    lda #$05 : pha : plb
    tya
    jsl $05DCDC|!bank
    plb
    lda $0E
    cpy #$00 : beq +
    clc : adc #$24
+   rts
endif

;================================================
; Routine to save the current level's custom checkpoint value and set the midway flag.
;================================================
hard_save:
    ; Filter title screen, etc.
    lda $0109|!addr : beq .no_intro
    cmp.b #!intro_level+$24 : beq .no_intro
    rts

.no_intro:
    phx

    ; We won't rely on $13CE anymore, so set the midway flag in $1EA2.
    %lda_13BF() : tax
    lda $1EA2|!addr,x : ora #$40 : sta $1EA2|!addr,x

    ; Set the level's custom checkpoint.
    rep #$30
    txa : and #$00FF : asl : tax
    lda !ram_respawn : sta !ram_checkpoint,x
    sep #$30

    plx
if !save_on_checkpoint
    jmp save_game
else
    rts
endif

;================================================
; Routine to remove the current level's checkpoint.
; Note: $13CE isn't cleared because it's also used in the OW loading routine.
;================================================
reset_checkpoint:
    phx
    phy
    %lda_13BF() : tay
    rep #$30
    and #$00FF : asl : tax
    lsr : cmp #$0025 : bcc +
    clc : adc #$00DC
+   sta !ram_checkpoint,x
    sta !ram_respawn
    sep #$30
    lda $1EA2|!addr,y : and #~$40 : sta $1EA2|!addr,y
    ply
    plx
    rts

;================================================
; Routine to save the game.
;================================================
save_game:
    phx
    phy

    ; Set up vanilla SRAM buffer.
    phb
    rep #$30
    ldx.w #$1EA2|!addr
    ldy.w #$1F49|!addr
    lda.w #$008C
    mvn $00,$00
    sep #$30
    plb

    ; Save to SRAM/BW-RAM.
    jsl $009BC9|!bank

    ply
    plx
    rts

;================================================
; Routines to reset and save the dcsave buffers.
;================================================
dcsave:
.init:
    ; Return if dcsave isn't installed.
    lda.l !rom_dcsave_byte : cmp #$5C : bne .return

    ; Load the address to the dcsave init wrapper routine.
    rep #$20
    lda.l !rom_dcsave_init_address : clc : adc #$0011 : sta $0D
    sep #$20
    lda.l !rom_dcsave_init_address+2 : sta $0F

    ; Call the dcsave routine.
if !sa1
    %invoke_sa1(.jml)
else
    jsl .jml
endif
    rts

.midpoint:
    ; Return if dcsave isn't installed.
    lda.l !rom_dcsave_byte : cmp #$5C : bne .return

    ; Only save if !Midpoint = 1.
    lda.l !rom_dcsave_midpoint_byte : cmp #$22 : bne .return

    ; Load the address to the dcsave save buffer routine.
    rep #$20
    lda.l !rom_dcsave_midpoint_address : sta $0D
    sep #$20
    lda.l !rom_dcsave_midpoint_address+2 : sta $0F

    ; Call the dcsave routine.
    jsl .jml

.return:
    rts

.jml:
    jml [$000D|!dp]

;================================================
; Routine to get the checkpoint value for the current sublevel.
; Returns the value in A (8 bit).
; You should use cmp #$00 to check for 0 after calling this.
; X,Y and P are preserved.
;================================================
get_checkpoint_value:
    phx
    php
    rep #$10
    ldx $010B|!addr
    lda.l tables_checkpoint_effect,x
    and #$0F
    plp
    plx
    rts

;================================================
; Routine to get the effect value for the current sublevel.
; Returns the value in A (8 bit).
; You should use cmp #$00 to check for 0 after calling this.
; X,Y and P are preserved.
;================================================
get_effect_value:
    phx
    php
    rep #$10
    ldx $010B|!addr
    lda.l tables_checkpoint_effect,x
    lsr #4
    and #$0F
    plp
    plx
    rts

;================================================
; Routine to get the index and mask to a bitwise sublevel table.
; Returns the index to the table in X, and the mask in A (8 bit).
; A/X/Y should be in 8-bit mode when calling this. Y is preserved.
;================================================
get_bitwise_mask:
    lda $010B|!addr : and #$07 : tax
    lda.l .mask_table,x : pha
    rep #$20
    lda $010B|!addr : lsr #3 : tax
    sep #$20
    pla
    rts

.mask_table:
    db $80,$40,$20,$10,$08,$04,$02,$01

;================================================
; Routine to get current screen number in X.
; If Lunar Magic 3.0+ is used, it may overwrite Y.
;================================================
get_screen_number:
    lda.l !rom_lm_version : cmp #$33 : bcc .no_lm3
    lda.l !rom_lm_get_screen_routine : cmp #$FF : beq .no_lm3
.lm3:
    jsl !rom_lm_get_screen_routine
    rts
.no_lm3:
    ldx $95
    lda $5B : lsr : bcc .return
    ldx $97
.return:
    rts

;================================================
; Routine that returns the intro sublevel in A.
; Output: A 16 bit, intro sublevel in A.
;================================================
get_intro_sublevel:
    rep #$20
    lda.l !rom_initial_submap : and #$00FF : beq .normal
    lda.l !rom_sprite_19_fix_byte : cmp #$EAEA : bne .normal
.modified:
    lda.w #!intro_level|$0100
    rts
.normal:
    lda.w #!intro_level
    rts

;================================================
; Routine that updates the OAM table at $0400 using
; the decompressed mirror at $0420.
; Useful if you need to draw sprites during fadein.
;================================================
update_0400:
    %jsl_to_rts_db($008494,$0084CF)
    rts
