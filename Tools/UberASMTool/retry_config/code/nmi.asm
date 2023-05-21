; Gamemode 14

;=====================================
; nmi routine
;
; I know that uploading each tile individually is slow, but it makes it easy
; to change where the tiles are uploaded to for the user, and easier to manage
; the case where the "exit" option is left out.
;=====================================

; Helper functions to compute addresses more compactly.
function vram_addr(offset) = (!sprite_vram+(offset*$10))
function gfx_size(num)     = (num*$20)

level:
if !sprite_status_bar
    ; Update the sprite status bar graphics.
    jsr sprite_status_bar_nmi
endif

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

    ; Push GFX address depending on the box being enabled or not.
    ; Additionally the size to upload for the cursor is pushed as well.
    lda !ram_disable_box : beq +
    lda #$02
+   tay
    rep #$20
    lda.w .cursor_size,y : pha
    lda.w .gfx_addr,y : pha

    ; These values are the same for all uploads, so put them out of the loop.
    ldy.b #$80 : sty $2115
    lda.w #$1801 : sta.w prompt_dma($4300)
    ldy.b #retry_gfx>>16 : sty.w prompt_dma($4304)
    ldy.b #1<<!prompt_channel
.loop:
    lda.w .dest,x : sta $2116
    lda.w .src,x : clc : adc $01,s : sta.w prompt_dma($4302)
    ; All uploads are 8x8 except the cursor,
    ; which is 16x8 only when the prompt box is enabled.
    lda.w #gfx_size(1)
    cpx #$00 : bne +
    lda $03,s
+   sta.w prompt_dma($4305)
    sty $420B
    dex #2 : bpl .loop
..end:

    ; If the box is enabled, transfer the black tiles too.
    cmp.w #gfx_size(1) : beq +
    sta.w prompt_dma($4305)
    lda.w #vram_addr(!tile_blk) : sta $2116
    lda.w #retry_gfx_box+gfx_size(7) : sta.w prompt_dma($4302)
    sty $420B
+
    ; Realign the stack.
    pla : pla
    plb

.return:
    sep #$20
    rtl

; Base address of the letters GFX when the prompt box is enabled/disabled.
.gfx_addr:
    dw retry_gfx_box
    dw retry_gfx_no_box

; Size to upload for the cursor when the prompt box is enabled/disabled
.cursor_size:
    dw gfx_size(2)
    dw gfx_size(1)

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
