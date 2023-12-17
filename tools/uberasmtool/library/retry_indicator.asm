incsrc "../retry_config/ram.asm"

; Tile number to display; the baserom's retry arrows graphic is in GFX29
!Tile = $F6

; Important: the YXPCCCTT (orientation, palette, etc.) values are hardcoded in ROM.
; If you want to change those you will have to hex edit the value for each status bar tile.
; See here: https://www.smwcentral.net/?p=memorymap&a=detail&game=smw&region=ram&detail=f2a5bf492c3e

; Where on the status bar to show the tile
!Location = $0EFE|!addr

; This location is a single 8x8 tile, to change the location check the diagram here:
; https://www.smwcentral.net/?p=memorymap&a=detail&game=smw&region=ram&detail=a70ec5339321

main:
    ; check the retry ram for the prompt type
    lda !ram_prompt_override
    cmp #$01 : beq draw_tile     ; if prompt + jingle
    cmp #$02 : beq draw_tile     ; if prompt + sfx
    cmp #$03 : beq draw_tile     ; if instant
    rtl

draw_tile:
    lda #!Tile : sta !Location
    rtl
