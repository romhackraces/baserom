; Gamemode 14

;=====================================
; nmi routine
;
; I know that uploading each tile individually is slow, but it makes it easy
; to change where the tiles are uploaded to for the user, and easier to manage
; the case where the "exit" option is left out.
;=====================================

; Helper functions to compute addresses more compactly.
function vram_addr(offset) = (!base_vram+(offset*$10))
function gfx_size(num)     = (num*$20)

level:
    ; Skip if it's not time to upload the tiles.
    lda !ram_update_request : bne .upload
    rtl

.upload:
    ; Only upload on this frame.
    dec : sta !ram_update_request

    ; With 5+ cycle iterations it saves time over doing lda.l.
    phb : phk : plb

    ; Loop to upload all the tiles.
    ; If the exit option is disabled, we skip the XI tiles.
    lda !ram_disable_exit : beq +
    lda #$01
+   tay
    ldx.w .index,y

    ; Set GFX address depending on the box being enabled or not.
    ; Additionally the disable box flag is copied to $02 for later.
    lda !ram_disable_box : beq +
    lda #$01
+   sta $02
    asl : tay
    rep #$20
    lda.w .gfx_addr,y : sta $00

    ; These values are the same for all uploads, so put them out of the loop.
    ldy.b #$80 : sty $2115
    lda.w #$1801 : sta $4320
    ldy.b #retry_gfx>>16 : sty $4324
.loop:
    lda.w .dest,x : sta $2116
    lda.w .src,x : clc : adc $00 : sta $4322
    ; All uploads are 8x8 except the cursor,
    ; which is 16x8 only when the prompt box is enabled.
    lda.w #gfx_size(1)
    cpx #$00 : bne +
    ldy $02 : bne +
    asl
+   sta $4325
    ldy.b #$04 : sty $420B
    dex #2 : bpl .loop
..end:
    plb

    ; If the box is enabled, transfer the black tiles too.
    ldy $02 : bne .return
    lda.w #vram_addr(!tile_blk) : sta $2116
    lda.w #retry_gfx_box+gfx_size(7) : sta $4322
    lda.w #gfx_size(2) : sta $4325
    ldy.b #$04 : sty $420B

.return:
    sep #$20
    rtl

; Base address of the letters GFX when the prompt box is enabled/disabled.
.gfx_addr:
    dw retry_gfx_box
    dw retry_gfx_no_box

; Index in the below tables to start from when the exit option is enabled/disabled.
.index:
    db .src_end-.src-2
    db .src_exit-.src-2

; Tables for cursor and "RETRY" tiles.
.src:
    dw gfx_size(6) ; Cursor
    dw gfx_size(2) ; R
    dw gfx_size(3) ; E
    dw gfx_size(1) ; T
    dw gfx_size(5) ; Y
..exit:
    dw gfx_size(4) ; X
    dw gfx_size(0) ; I
..end:

.dest:
    dw vram_addr(!tile_curs)
    dw vram_addr(!tile_r)
    dw vram_addr(!tile_e)
    dw vram_addr(!tile_t)
    dw vram_addr(!tile_y)
..exit:
    dw vram_addr(!tile_x)
    dw vram_addr(!tile_i)
..end:
