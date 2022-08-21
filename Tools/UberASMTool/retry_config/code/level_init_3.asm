; Gamemode 13

init:
    ; Reset some stuff related to lx5's Custom Powerups.
if !custom_powerups == 1
if !dynamic_items == 1
    ldy $0DC2|!addr
    lda.b #read1($02802D|!bank)
    dec
    sta $00
    lda.b #read1($02802E|!bank)
    sta $01
    lda.b #read1($02802F|!bank)
    sta $02
    lda [$00],y
    xba
    rep #$20
    and #$FF00
    lsr #3
    adc.w #read2($00A38B|!bank)
    sta !item_gfx_pointer+4
    clc
    adc #$0200
    sta !item_gfx_pointer+10
    sep #$20
    lda !item_gfx_refresh
    ora #$13
    sta !item_gfx_refresh
endif

    lda #$FF
    sta !item_gfx_oldest
    sta !item_gfx_latest

    lda $86
    sta !slippery_flag_backup

.init_cloud_data
    lda $19
    cmp #!cloud_flower_powerup_num
    bne +

    rep #$30
    phx
    ldx #$006C
-   lda $94
    sta.l !collision_data_x,x
    lda $96
    sta.l !collision_data_x+2,x
    dex #4
    bpl -
    plx
    sep #$30
+   
endif
    
    ; If goal walk is in progress, reset the music to play.
    ; This ensures the song will be reloaded if dying and respawning in the same sublevel.
    lda $1493|!addr : beq +
    lda #$FF : sta $0DDA|!addr
+   
    ; Restore the Layer 2 interaction bit if applicable.
    lda !ram_l2_backup : beq +
    lda #$00 : sta !ram_l2_backup
    lda #$80 : tsb $5B
+
    ; Play the silent checkpoint SFX if applicable.
if !room_cp_sfx != $00
    lda !ram_play_sfx : beq +
    lda.b #!room_cp_sfx : sta !room_cp_sfx_addr
+
endif

    ; Reset DSX sprites.
if !reset_dsx
    stz $06FE|!addr
endif

    ; Reset vanilla Boo rings.
if !reset_boo_rings == 2
    rep #$20
    stz $0FAE|!addr
    stz $0FB0|!addr
    sep #$20
endif
    
if !amk
    ; Store $05 or $06 to $1DFA depending on the
    ; sfx_echo setting for the current sublevel.
    ldy #$05
    jsr shared_get_bitwise_mask
    and.l tables_sfx_echo,x : beq +
    iny
+   sty $1DFA|!addr
endif

    ; If not entering from the overworld, skip.
    lda $141A|!addr : bne .room_transition

    ; Backup the timer value.
    lda $0F31|!addr : sta !ram_timer+0
    lda $0F32|!addr : sta !ram_timer+1
    lda $0F33|!addr : sta !ram_timer+2

.room_transition:
    lda !ram_is_respawning : bne ..respawning
    jsr shared_get_checkpoint_value
    cmp #$02 : bcc .normal

..respawning:
    ; Fix issues with the "level ender" sprite.
    stz $1493|!addr
    stz $13C6|!addr

    ; Reset mode 7 values.
    stz $36
    stz $37
    
if !amk
    ; Backup the music that should play.
    lda $0DDA|!addr : sta !ram_music_to_play
endif

.normal:
    ; Reset the respawning flag.
    lda #$00 : sta !ram_is_respawning

main:
if !fast_transitions
    ; Reset the mosaic timer.
    stz $0DB1|!addr
endif
    rtl
