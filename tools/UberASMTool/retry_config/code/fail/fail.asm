;===============================================================================
; This manages the fail state when the SRAM or WRAM states are corrupted,
; probably indicating a misuse of Retry (i.e. loading a Retry-less save file or
; save state with Retry newly installed).
;===============================================================================

; Basically width and height of the screen in tiles
!msg_width  #= $10*2
!msg_height #= $0E*2

; How many rows use a different palette
!red_rows = 5

pushtable
incsrc charset.asm

sram_fail_msg:
    db "                                "
    db "                                "
    db "         !!! ERROR !!!          "
    db "                                "
    db "                                "
    db " The Retry System has detected  "
    db " an error in your save data!    "
    db "                                "
    db " This can be caused by:         "
    db " - Loading a save file that was "
    db "   created before inserting     "
    db "   Retry v2.0.0+ in the hack    "
    db " - SRAM corruption              "
    db "                                "
    db " Usually you can solve it by    "
    db " erasing all the save files and "
    db " creating new ones.             "
    db "                                "
    db " If you're the hack creator and "
    db " you think this should not have "
    db " happened, contact me on SMW    "
    db " Central or on Discord.         "
    db "                                "
    db " If you're a player and you are "
    db " reading this, let the hack     "
    db " creator know.                  "
    db "                     - Kevin :) "
    db "                                "
.end:

wram_fail_msg:
    db "                                "
    db "                                "
    db "         !!! ERROR !!!          "
    db "                                "
    db "                                "
    db " The Retry System has detected  "
    db " an error in your RAM state!    "
    db "                                "
    db " This can be caused by:         "
    db " - Loading a save state that    "
    db "   was created before inserting "
    db "   Retry v2.0.0+ in the hack    "
    db " - RAM corruption               "
    db "                                "
    db " Usually you can solve it by    "
    db " restarting the hack and then   "
    db " creating a new save state.     "
    db "                                "
    db " If you're the hack creator and "
    db " you think this should not have "
    db " happened, contact me on SMW    "
    db " Central or on Discord.         "
    db "                                "
    db " If you're a player and you are "
    db " reading this, let the hack     "
    db " creator know.                  "
    db "                     - Kevin :) "
    db "                                "
.end:

assert sram_fail_msg_end-sram_fail_msg == !msg_width*!msg_height, "Error: sram_fail_msg must be !msg_width x !msg_height characters!"
assert wram_fail_msg_end-wram_fail_msg == !msg_width*!msg_height, "Error: wram_fail_msg must be !msg_width x !msg_height characters!"

pulltable

; Macro to upload a palette from a table to the color index specified
macro _upload_palette(dst, src)
    lda.b #<dst> : sta $2121
    ldx #$2200 : stx $4300
    ldx.w #<src> : stx $4302
    ldx.w #<src>_end-<src> : stx $4305
    lda #$01 : sta $420B
endmacro

; Macro to upload a GFX file from a table to the VRAM address specified
macro _upload_gfx(dst, src)
    lda #$80 : sta $2115
    ldx.w #<dst> : stx $2116
    ldx.w #$1801 : stx $4300
    ldx.w #<src> : stx $4302
    ldx.w #<src>_end-<src> : stx $4305
    lda #$01 : sta $420B
endmacro

sram:
    jsr setup
    ldx.w #sram_fail_msg
    jmp finalize

wram:
    jsr setup
    ldx.w #wram_fail_msg
    jmp finalize

setup:
    phk : plb
    sep #$20
    rep #$10
    ; Disable interrupts
    sei
    stz $4200
    ; Disable HDMA
    stz $420C
    ; Clear SPC I/O
    stz $2140
    stz $2141
    stz $2142
    stz $2143
    ; Enable f-blank
    lda #$80 : sta $2100
    ; Enable background color
    stz $2130
    lda #$20 : sta $2131
    ; BG color: #181818
    lda #$83 : sta $2132
    lda #$43 : sta $2132
    lda #$23 : sta $2132
    ; No bullshit modes
    stz $2133
    ; Layer 3 at (0,-1)
    stz $2111 : stz $2111
    lda #$FF : sta $2112 : sta $2112
    ; Layer 3 and objects on main, nothing on sub
    lda #$14 : sta $212C
    stz $212D
    stz $212E
    stz $212F
    ; 8x8 and 16x16 objects, sprite GFX at VRAM $6000
    lda #$03 : sta $2101
    ; No OAM bullshit
    stz $2102
    stz $2103
    ; Mode 1
    lda #$01 : sta $2105
    ; No mosaic
    stz $2106
    ; No windows
    stz $2123
    stz $2124
    stz $2125
    stz $2126
    stz $2127
    stz $2128
    stz $2129
    stz $212A
    stz $212B
    ; Layer 3 256x256 tilemap at VRAM $5000
    lda #$50 : sta $2109
    ; Layer 3 GFX at VRAM $4000
    lda #$04 : sta $210C
    ; Set DMA bank for all uploads
    lda.b #bank(setup) : sta $4304
    ; Upload layer 3 GFX to VRAM $4000
    %_upload_gfx($4000, layer3_gfx)
    ; Upload sprite GFX to VRAM $6000
    %_upload_gfx($6000, sprite_gfx)
    ; Upload layer 3 tilemap properties
    lda #$80 : sta $2115
    ldx.w #$5000 : stx $2116
    ldx.w #$1908 : stx $4300
    ldx.w #layer3_props1 : stx $4302
    ldx.w #!msg_width*!red_rows : stx $4305
    lda #$01 : sta $420B
    lda #$80 : sta $2115
    ldx.w #$5000+(!msg_width*!red_rows) : stx $2116
    ldx.w #$1908 : stx $4300
    ldx.w #layer3_props2 : stx $4302
    ldx.w #!msg_width*(!msg_height-!red_rows) : stx $4305
    lda #$01 : sta $420B
    ; Upload layer 3 palette
    %_upload_palette($00, layer3_pal)
    ; Upload sprite palette
    %_upload_palette($80, sprite_pal)
    ; Clear OAM table
    ldy.w #$0200-4
    ldx.w #$0080-1
    lda #$F0
-   sta $0201|!addr,y
    stz $0400|!addr,x
    dey #4
    dex
    bpl -
    ; Copy sprite tilemap to OAM table
    ldy.w #sprite_tilemap_end-sprite_tilemap-1
-   lda.w sprite_tilemap,y : sta $0200|!addr,y
    dey : bpl -
    ; Upload OAM table
    ldx.w #$0400 : stx $4300
    ldx.w #$0200|!addr : stx $4302
    stz $4304
    ldx #$0220 : stx $4305
    lda #$01 : sta $420B
    rts

layer3_gfx:
    incbin "layer3.bin"
.end:

layer3_props1:
    db $24

layer3_props2:
    db $20

layer3_pal:
    dw $0000,$7FDD,$0000,$0000
    dw $0000,$001F,$0000,$0000
.end:

sprite_gfx:
    incbin "sprite.bin"
.end:

sprite_pal:
    ; Mario palette
    dw $0000,$7FFF,$0000,$0D71,$1E9B,$3B7F,$635F,$581D
    dw $000A,$391F,$44C4,$4E08,$6770,$30B6,$35DF,$03FF
    ; Luigi palette
    dw $0000,$7FFF,$0000,$0D71,$1E9B,$3B7F,$4F3F,$581D
    dw $1140,$3FE0,$3C07,$7CAE,$7DB3,$2F00,$165F,$03FF
.end:

!spr1_x = $20
!spr1_y = $08
!spr1_p = $00
!spr2_x = $C8
!spr2_y = !spr1_y
!spr2_p = $42

sprite_tilemap:
    ; First Mario
    db !spr1_x+$00,!spr1_y+$00,$00,!spr1_p
    db !spr1_x+$08,!spr1_y+$00,$01,!spr1_p
    db !spr1_x+$00,!spr1_y+$08,$02,!spr1_p
    db !spr1_x+$08,!spr1_y+$08,$03,!spr1_p
    db !spr1_x+$00,!spr1_y+$10,$04,!spr1_p
    db !spr1_x+$08,!spr1_y+$10,$05,!spr1_p
    ; Second Mario
    db !spr2_x+$00,!spr2_y+$00,$01,!spr2_p
    db !spr2_x+$08,!spr2_y+$00,$00,!spr2_p
    db !spr2_x+$00,!spr2_y+$08,$03,!spr2_p
    db !spr2_x+$08,!spr2_y+$08,$02,!spr2_p
    db !spr2_x+$00,!spr2_y+$10,$05,!spr2_p
    db !spr2_x+$08,!spr2_y+$10,$04,!spr2_p
.end:

finalize:
    ; Upload layer 3 tilemap tiles (X = src address)
    stx $4302
    lda.b #bank(finalize) : sta $4304
    stz $2115
    ldx.w #$5000 : stx $2116
    ldx.w #$1800 : stx $4300
    ldx.w #!msg_width*!msg_height : stx $4305
    lda #$01 : sta $420B
    ; Waiting for next v-blank
-   bit $4212 : bmi -
-   bit $4212 : bpl -
    ; Turn on the screen
    lda #$0F : sta $2100
    ; We stuck here :(
-   bra -
