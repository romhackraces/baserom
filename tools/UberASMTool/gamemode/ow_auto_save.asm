incsrc "callisto.asm"
%import_library("freeram.asm")

; Simple auto-save on overworld movement by AmperSam

; Play sound effect after saving
!PlaySFX = 0
!sfx_num  = $22
!sfx_addr = $1DFC|!addr

; FreeRAM flag used make code runs only once per level-tile.
!TileCheck = !auto_save_tile_check_freeram ; clears on Overworld load

main:
    ; check if the player is looking around the map, in switch palace event or exchanging lives
    lda $13D4|!addr : ora $13D2|!addr : ora $1B87|!addr : bne .return
    ; check if player is moving on the overworld
    lda $13D9|!addr : cmp #$04 : beq .clear_flag
    ; check the freeram flag
    lda !TileCheck : cmp #$01 : beq .return
    ; check if the player is standing on a tile and save
    lda $13D9|!addr : cmp #$03 : beq save_game
.return
    rtl

.clear_flag
    ; clear flag
    stz !TileCheck
    rtl

; save game routine
save_game:

    ; use retry api to save game
    JSL retry_api_save_game

if !PlaySFX
    ; play save sound effect
    lda #!sfx_num : sta !sfx_addr
endif
    ; set our flag
    lda #$01 : sta !TileCheck

.return
    rtl