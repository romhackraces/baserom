incsrc "../retry_config/ram.asm"

; The retry arrows graphic is stored in GFX29
!Tile = $F6

; To change the location check the diagram here:
; https://www.smwcentral.net/?p=memorymap&a=detail&game=smw&region=ram&detail=a70ec5339321
!Location = $0EFE|!addr

main:
    ; check the retry ram prompt type
    lda !ram_prompt_override
    cmp #$01 : beq draw     ; if prompt + jingle
    cmp #$02 : beq draw     ; if prompt + sfx
    cmp #$03 : beq draw     ; if instant
    rtl

draw:
    lda #!Tile : sta !Location
    rtl
