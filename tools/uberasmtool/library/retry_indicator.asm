incsrc "../retry_config/ram.asm"
incsrc "../../../shared/freeram.asm"

main:
; run during end (UberASMTool 2.0 only)
end:

    ; check the retry ram for the prompt type
    lda !ram_prompt_override
    cmp #$01 : beq draw     ; if prompt + jingle
    cmp #$02 : beq draw     ; if prompt + sfx
    cmp #$03 : beq draw     ; if instant
    rtl

draw:
    lda !toggle_retry_indicator_freeram     ; check if toggle is set for indicator
    beq .return
    lda !toggle_statusbar_freeram           ; check if the status bar is hidden
    beq draw_layer3_tile                    ; ...if not, draw layer 3 tile
    jmp draw_sprite_tile                    ; ... otherwise jump to drawing sprite tile
.return
    rtl

;------------------------------
; Draw Layer 3 tile
;------------------------------

; Tile number to display; the baserom's retry arrows graphic is in GFX29
!Tile = $F6

; Important: the YXPCCCTT (orientation, palette, etc.) values are hardcoded in ROM.
; If you want to change those you will have to hex edit the value for each status bar tile.
; See here: https://www.smwcentral.net/?p=memorymap&a=detail&game=smw&region=ram&detail=f2a5bf492c3e

; Where on the status bar to show the tile
!Location = $0F19|!addr

; This location is a single 8x8 tile, to change the location check the diagram here:
; https://www.smwcentral.net/?p=memorymap&a=detail&game=smw&region=ram&detail=a70ec5339321

draw_layer3_tile:
    lda #!Tile : sta !Location
    rtl

;------------------------------
; Draw Sprite Tile
;------------------------------

; Tile position
!xpos = $08
!ypos = $07

; Tile properties
!tile = $69     ; Tile number, in SP1
!prop = $22     ; YXPCCCTT properties

; OAM Settings
!slot = $20
!oam_index #= !slot*4

draw_sprite_tile:
    LDA.b #!xpos
    STA $0200|!addr+!oam_index
    LDA.b #!ypos
    STA $0201|!addr+!oam_index
    LDA.b #!tile
    STA $0202|!addr+!oam_index
    LDA.b #!prop
    STA $0203|!addr+!oam_index
    rtl