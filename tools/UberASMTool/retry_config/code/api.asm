;================================================
; Routines that can be called by external UberASM files
;================================================

;================================================
; Routine to respawn in the level (at the current checkpoint),
; effectively the same as dying and hitting Retry, or dying with
; instant Retry enabled.
;
; Inputs: N/A
; Outputs: N/A
; Pre: A/X/Y 8 bits
; Post: A/X/Y 8 bits
; Example: JSL retry_api_respawn_in_level
;================================================
respawn_in_level:
    jml in_level_main_dying_respawn

;================================================
; Routine to save the game, which will also save the addresses
; defined in the sram_tables.asm file.
;
; Inputs: N/A
; Outputs: N/A
; Pre: N/A
; Post: A/X/Y 8 bits, DB/X/Y preserved
; Example: JSL retry_api_save_game
;================================================
save_game:
    jsr shared_save_game
    rtl

;================================================
; Routine to remove the current level's checkpoint, meaning
; entering it again will load the main sublevel's entrance.
; Note: this can be also called outside of a level if you want to
; reset a specific level's checkpoint. Just make sure that $13BF
; has the level number you want before calling this.
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

;================================================
; Routine to configure which tiles will be used by the sprite status
; bar. You can configure these elements: item box, timer, coin
; counter, lives counter and bonus stars counter. Each element needs a
; 16x16 sprite tile to be reserved.
; This routine should be called in UberASM level init code, to overwrite
; the default settings from "settings_global.asm", in case you want
; to hide some or all of the elements in some level or if you need to
; change their tile or palette.
; Each element needs a 16 bit value that determines which 16x16 tile
; it will use and what palette to use. The first digit is the palette
; row to use (8-F), while the other 3 digits are the tile number
; (000-1FF). If an element is set to $0000, it won't be displayed.
; For the coin counter, you can add $0200 to the value to only display
; dragon coins, or add $0400 to only display coins.
;
; Inputs: for each item, in order, you write the value after the JSL
;         in the format described above (see example)
; Outputs: N/A
; Pre: N/A
; Post: A/X/Y 8 bit and clobbered, DB preserved
; Example:
;     JSL retry_api_configure_sprite_status_bar
;     dw $B080 ; Item box: palette B, tile 0x80
;     dw $8088 ; Timer: palette 8, tile 0x88
;     dw $80C2 ; Coin counter: palette 8, tile 0xC2
;     dw $0000 ; Lives counter: hidden
;     dw $0000 ; Bonus stars counter: hidden
;     ... <- your code will continue here after the JSL
;================================================
configure_sprite_status_bar:
if !sprite_status_bar
    phb
    ; Set DBR equal to caller routine bank
    sep #$30
    lda $04,s : pha : plb
    ; Use Y to read address after the routine call
    rep #$30
    lda $02,s : tay
    ; Copy the values from after the JSL to sprite status bar ram
    lda $0001,y : and #$7FFF : sta !ram_status_bar_item_box_tile
    lda $0003,y : and #$7FFF : sta !ram_status_bar_timer_tile
    lda $0005,y : and #$7FFF : sta !ram_status_bar_coins_tile
    lda $0007,y : and #$7FFF : sta !ram_status_bar_lives_tile
    lda $0009,y : and #$7FFF : sta !ram_status_bar_bonus_stars_tile
    plb
endif
    ; Make sure the code returns at the right place
    rep #$20
    lda $01,s : clc : adc.w #2*5 : sta $01,s
    sep #$30
    rtl

;================================================
; Routine to get the current Retry type, i.e. if currently the level is
; set to have Retry prompt, instant Retry or no Retry.
; The returned value has this format:
; - $01 = Retry prompt enabled & play the death song when the player dies
; - $02 = Retry prompt enabled & play only the death sfx when the player dies
; - $03 = instant Retry enabled & play only the death sfx when the player dies
; - $04 = instant Retry enabled & play the death song when the player dies
; - $05 = Retry disabled (vanilla death)
;
; Inputs: N/A
; Outputs: A = Retry type
; Pre: A 8 bits
; Post: A/X/Y size preserved, DB/X/Y preserved
; Example: JSL retry_api_get_retry_type
;================================================
get_retry_type:
    jsr shared_get_prompt_type
    rtl

;================================================
; Routine to get the address in SRAM for a specific variable.
; By "variable" it's meant any of the RAM addresses that are saved to SRAM
; specified in the sram save table. The returned address will be coherent
; with the current save file loaded when this routine is called (so, make
; sure to not call it before a save file is loaded!).
; This could be useful to read/write values in SRAM directly, for example
; if you need to update some SRAM value without the game being saved.
; Note: this will always return "variable not found" if !sram_feature = 0.
;
; Inputs: variable address to search for in ROM right after the JSL
;         This means the call should look like this:
;             JSL retry_api_get_sram_variable_address
;             dl <variable address>
; Outputs: Carry set = variable not found
;          Carry clear = variable found -> SRAM address stored in $00-$02
;            In this case the value in SRAM can be accessed indirectly with the
;            LDA/STA [$00] and LDA/STA [$00],y instructions.
; Pre: N/A
; Post: A/X/Y 8 bit and clobbered, DB preserved
; Example:
;         JSL retry_api_get_sram_variable_address
;         dl retry_ram_death_counter ; Variable to search for
;         BCS not_found
;     found:
;         LDY #$01
;         LDA #$09
;         STA [$00],y ; Set second death counter digit in SRAM to 9
;     not_found:
;         ...
;================================================
get_sram_variable_address:
if !sram_feature
    phb
    ; Set DBR equal to caller routine bank
    sep #$30
    lda $04,s : pha : plb
    ; Use Y to read address after the routine call
    rep #$30
    lda $02,s : tay
    stz $00
    ldx #$0000
.loop:
    ; Check if the current SRAM variables corresponds to the input
    lda.l sram_tables_save+0,x : cmp $0001,y : bne .next
    lda.l sram_tables_save+1,x : cmp $0002,y : bne .next
.found:
    ; If so, add the calculated offset to the save file SRAM address
    jsr sram_get_sram_addr
    clc : adc $00 : sta $00
    sep #$20
    lda.b #!sram_addr>>16 : sta $02
    ; Clear carry (address found)
    clc
    bra .return
.next:
    ; Update the SRAM offset with the current variable size
    lda.l sram_tables_save+3,x : clc : adc $00 : sta $00
    ; Go to the next SRAM variable
    txa : clc : adc #$0005
    ; If at the end of the SRAM table, end
    cmp.w #sram_tables_sram_defaults-sram_tables_save : bcs .not_found
    tax
    bra .loop
.not_found:
    ; Set carry (address not found)
    sec
.return:
    plb
    ; Make sure the code returns at the right place
    rep #$20
    lda $01,s : inc #3 : sta $01,s
    sep #$30
    rtl
else
    ; Make sure the code returns at the right place
    rep #$20
    lda $01,s : clc : adc #$0003 : sta $01,s
    ; Set carry (address not found)
    sep #$31
endif
    rtl
