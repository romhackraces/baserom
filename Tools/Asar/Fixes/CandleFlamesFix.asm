if read1($00FFD5) == $23 && read3($0084C0) == $5A123 && read1($0084C3) >= 140

    ; Cluster tables defines, replace with yours if you remapped them
    !cluster_num     = $1892|$6000
    !cluster_y_low   = $1E02|$6000
    !cluster_x_low   = $1E16|$6000
    !cluster_table_1 = $0F4A|$6000

    ; Disable original candle code
    org $02F825+(2*5)
        dw $F820

    ; Run in gamemode 14 after JSL $7F8000
    org $00A29D
        jsl main

    ; Freespace
    org $02FA16
    main:
        ; Only run when cluster sprites are active
        lda $78B8 : beq .return
        phb
        lda #$02 : pha : plb
        ldx #$13
        autoclean jsl cluster_loop
        plb
    .return:
        ; Restore original code
        jml $05BC00

    warnpc $02FA84

    freedata

    cluster_loop:
        lda !cluster_num,x : cmp #$05 : bne .next
        jsr candle
    .next:
        dex : bpl cluster_loop
        rtl

    ; Adapted from $02FA16 + use MaxTile to draw
    candle:
        lda $9D : bne +
        jsl $01ACF9
        and #$07 : tay
        lda $13 : and.w $02FA02,y : bne +
        inc !cluster_table_1,x
    +   lda !cluster_x_low,x : sec : sbc $1E : sta $00 : stz $01
        lda !cluster_y_low,x : sec : sbc $20 : sta $02
        lda !cluster_table_1,x : and #$03 : tay
        lda.w $02FA0E,y : sta $03
        lda.w $02FA12,y : sta $04
        phx
        ; Request 1 or 2 tiles at lowest priority
        ; (2 if the flame needs to loop around the screen)
        rep #$30
        ldy #$0001
        stz $05
        lda $00 : cmp #$00F0 : bcc +
        iny
        inc $05
    +   lda #$0003
        jsl $0084B0
        bcc .return
        sep #$20
        ; Draw the tile(s)
        ldx $3100
        lda $00 : sta $400000,x
        lda $02 : sta $400001,x
        lda $03 : sta $400002,x
        lda $04 : sta $400003,x
        lda $05 : beq +
        lda $00 : sta $400004,x
        lda $02 : sta $400005,x
        lda $03 : sta $400006,x
        lda $04 : sta $400007,x
    +   ldx $3102
        lda #$02 : sta $400000,x
        lda $05 : beq .return
        lda #$03 : sta $400001,x
    .return:
        sep #$30
        plx
        rts
else
    print "This patch is meant to be used with SA-1 v1.40+, skipping."
endif
