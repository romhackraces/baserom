; Gamemode 14

;===============================================================================
; nmi routine
;
; I know that uploading each tile individually is slow, but it makes it easy
; to change where the tiles are uploaded to for the user, and easier to manage
; the case where the "exit" option is left out.
;===============================================================================

level:
    ; Don't run on lag frames.
    lda $10 : beq .run
    rtl
.run:

if !sprite_status_bar
    ; Update the sprite status bar graphics.
    jsr sprite_status_bar_nmi
endif ; !sprite_status_bar

if !no_prompt_draw
    rtl
else ; if not(!no_prompt_draw)
    ; Skip if it's not time to upload the tiles.
    lda !ram_update_request : bne .upload
    rtl

.upload:
    ; Only upload on this frame.
    dec : sta !ram_update_request

    ; With 5+ cycle iterations it saves time over doing lda.l.
    phb : phk : plb

    ; Loop to upload all the tiles.
    ; If the exit option is disabled, we skip the second line tiles.
    lda !ram_disable_prompt_exit : beq +
    lda #$01
+   tay
    ldx.w .index,y

    ; Save GFX address depending on the box being enabled or not.
    ; Additionally the size to upload for the cursor is saved as well.
    lda !ram_disable_prompt_bg : beq +
    lda #$02
+   tay
    rep #$20
    lda.w .cursor_size,y : sta $00
    lda.w .gfx_addr,y : sta $02

    ; These values are the same for all uploads, so put them out of the loop.
    ldy.b #$80 : sty $2115
    lda.w #$1801 : sta.w upload_dma($4300)
    ldy.b #!gfx_bank : sty.w upload_dma($4304)
    ldy.b #1<<!upload_channel
    clc

    ; Upload the cursor separately since it has a different size
.cursor:
    lda.w #vram_addr(!prompt_tile_cursor) : sta $2116
    lda.w #gfx_size(!prompt_gfx_index_cursor) : adc $02 : sta.w upload_dma($4302)
    lda $00 : sta.w upload_dma($4305)
    sty $420B

    ; Upload all remaining 8x8 tiles
.tile_loop:
    lda.w .dest,x : sta $2116
    lda.w .src,x : adc $02 : sta.w upload_dma($4302)
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
    dex #2 : bpl .tile_loop

.return:
    sep #$20
    plb
    rtl

; Base address of the letters GFX when the prompt box is enabled/disabled.
.gfx_addr:
    dw gfx_prompt_box
    dw gfx_prompt_no_box

; Size to upload for the cursor when the prompt box is enabled/disabled
.cursor_size:
if !prompt_type == 0
    dw gfx_size(3)
else ; if not(!prompt_type == 0)
    dw gfx_size(2)
endif ; !prompt_type == 0
    dw gfx_size(1)

; Index in the below tables to start from when the exit option is enabled/disabled.
.index:
    db .src_end-.src-2
    db .src_exit-.src-2

macro _vram_addrs(...)
    for i = 0..sizeof(...)
        dw vram_addr(<...[!i]>)
    endfor
endmacro

macro _gfx_sizes(...)
    for i = 0..sizeof(...)
        dw gfx_size(<...[!i]>)
    endfor
endmacro

.src:
    %_gfx_sizes(!prompt_gfx_index_line1)
..exit:
if defined("prompt_gfx_index_line2")
    %_gfx_sizes(!prompt_gfx_index_line2)
endif ; defined("prompt_gfx_index_line2")
..end:

.dest:
    %_vram_addrs(!prompt_tiles_line1)
..exit:
if defined("prompt_tiles_line2")
    %_vram_addrs(!prompt_tiles_line2)
endif ; defined("prompt_tiles_line2")
..end:

endif ; !no_prompt_draw
