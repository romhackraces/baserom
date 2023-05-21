; These tables determine which sprite tile and palette to use for the sprite status bar.
; Each element of the status bar needs one 16x16 tile reserved for it, but you can choose
; a different one for each level (for example, picking a tile that's unused in that level)
; if you don't want to reserve sprite space for the entire game.
; You can also disable each element individually (or all of them) by using a value of $0000 for the specific level.
; Note that these tables are ignored if !sprite_status_bar = 0 in "settings.asm".
; If you do want to enable one or more elements, specify the tile number to use as a 4 digit number:
; pick the tile in the Lunar Magic 8x8 editor, then subtract 0x400 from it (for example, tile 0x480 -> use $0080,
; tile 0x560 -> use $0160). And yes, any tile in SP1/2/3/4 can be used here.
;
; Additionally, the first digit in the number specifies the palette that will be used:
; 0 = palette 8, 1 = palette 9, etc. For example, $1080 means "use tile $80 (in SP2) with palette 9".
; It's suggested to use palette 8 for coins and timer (i.e., use 0 as the first digit) and palette B for
; the item box (i.e., use 3 as the first digit). Note that using palettes C-F will make the tiles affected
; by color math effects such as translucency and screen darkening effects.
; The default settings replace the berry, flopping fish and smiling coin tiles.
;
; NOTE: enabling the coin counter also enables the display of the Yoshi Coins collected.
;
; NOTE: while the coin counter uses one 16x16 tile, the bottom right 8x8 tile is not used or overwritten,
; so it's safe to use for anything else.

!itemb_tile = $3080 ; use with item_box table
!timer_tile = $0020 ; use with timer table
!coins_tile = $0022 ; use with coins table

!no_display = $0000 ; flag to disable in level

; don't change
!always_off = $0000 ; to disable on title level

item_box:
    ;       0           1           2           3           4           5           6           7           8           9           A           B           C            D          E           F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 000-00F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 010-01F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 020-02F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 030-03F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 040-04F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 050-05F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 060-06F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 070-07F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 080-08F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 090-09F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 0A0-0AF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 0B0-0BF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!always_off,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 0C0-0CF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 0D0-0DF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 0E0-0EF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 0F0-0FF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!itemb_tile,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 100-10F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 110-11F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 120-12F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 130-13F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 140-14F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 150-15F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 160-16F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 170-17F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 180-18F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 190-19F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 1A0-1AF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 1B0-1BF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 1C0-1CF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 1D0-1DF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 1E0-1EF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 1F0-1FF

timer:
    ;       0           1           2           3           4           5           6           7           8           9           A           B           C            D          E           F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 000-00F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 010-01F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 020-02F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 030-03F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 040-04F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 050-05F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 060-06F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 070-07F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 080-08F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 090-09F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 0A0-0AF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 0B0-0BF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!always_off,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 0C0-0CF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 0D0-0DF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 0E0-0EF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 0F0-0FF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!timer_tile,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 100-10F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 110-11F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 120-12F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 130-13F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 140-14F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 150-15F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 160-16F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 170-17F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 180-18F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 190-19F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 1A0-1AF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 1B0-1BF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 1C0-1CF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 1D0-1DF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 1E0-1EF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 1F0-1FF

coins:
    ;       0           1           2           3           4           5           6           7           8           9           A           B           C            D          E           F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 000-00F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 010-01F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 020-02F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 030-03F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 040-04F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 050-05F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 060-06F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 070-07F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 080-08F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 090-09F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 0A0-0AF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 0B0-0BF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!always_off,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 0C0-0CF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 0D0-0DF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 0E0-0EF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 0F0-0FF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!coins_tile,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 100-10F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 110-11F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 120-12F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 130-13F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 140-14F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 150-15F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 160-16F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 170-17F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 180-18F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 190-19F
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 1A0-1AF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 1B0-1BF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 1C0-1CF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 1D0-1DF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 1E0-1EF
    dw !no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display,!no_display ; 1F0-1FF
