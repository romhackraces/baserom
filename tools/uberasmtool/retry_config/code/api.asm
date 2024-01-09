;================================================
; Routines that can be called by external UberASM files
;================================================

;================================================
; Routine to remove the current level's checkpoint, meaning
; entering it again will load the main sublevel's entrance.
; Only makes sense to be called during a level gamemode.
;
; Inputs: N/A
; Outputs: N/A
; Pre: A/X/Y 8 bits
; Post: A/X/Y 8 bits, DB/X/Y preserved
; Example: JSL retry_api_reset_level_checkpoint
;================================================
reset_level_checkpoint:
    jsr shared_reset_checkpoint
    rtl

;================================================
; Routine to remove all levels checkpoints, effectively resetting
; their state as if it were a new game. If you're saving the CPs
; to SRAM, you'll need to call the save game routine afterwards to
; also reset the CPs state in SRAM.
;
; Inputs: N/A
; Outputs: N/A
; Pre: N/A
; Post: A/X/Y size preserved, DB/X/Y preserved
; Example: JSL retry_api_reset_all_checkpoints
;================================================
reset_all_checkpoints:
    ; A/X/Y 8 bits
    phx : phy : php
    sep #$30

    ; Initialize the checkpoint ram table.
    ldx #$BE
    ldy #$5F
-   tya : cmp #$25 : bcc +
    clc : adc #$DC
+   sta !ram_checkpoint,x
    lda #$00 : adc #$00 : sta !ram_checkpoint+1,x
    lda $1EA2|!addr,y : and #~$40 : sta $1EA2|!addr,y
    dex #2
    dey : bpl -

    ; Initialize respawn RAM in case it's called inside a level.
    %lda_13BF() : asl : tax
    rep #$20
    lda !ram_checkpoint,x : sta !ram_respawn

    ; Initialize "set checkpoint" handle to $FFFF.
    lda #$FFFF : sta !ram_set_checkpoint

    ; Restore X/Y/P
    plp : ply : plx
    rtl
