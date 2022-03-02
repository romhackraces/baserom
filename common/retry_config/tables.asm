; Retry table-based settings.

;=================================================;
; Multiple Midway and Local Retry Prompt Settings ;
;=================================================;
; The following table controls two different behaviors for each sublevel.
; Each $XX value refers to a sublevel. The guides at the top and right of the table should help visualize it.
;
; The first digit in XX is used to change the Retry behavior for the sublevel:
;  0 = follow the global setting (!default_prompt_type)
;  1 = prompt + play the death jingle when players die. Recommended if you want the music to restart on each death.
;  2 = prompt + play only the sfx when players die (music won't be interrupted).
;  3 = no prompt + play only the sfx (the fastest option; "yes" is chosen automatically).
;        In this option, you can press start then select to exit the level.
;  4 = no retry (as if "no" is chosen automatically). Use this to have a vanilla death sequence.
;
; The second digit sets the behavior of midways bars and level entrances in the sublevel (see the figures in the "midway instruction" folder):
;  0 = Vanilla. The midway bar in the corresponding sublevel will lead to the midway entrance of the main level.
;  1 = The Midway bar in the corresponding sublevel will lead to the midway entrance of this sublevel as a checkpoint.
;  2 = Any main/secondary/midway entrance through door/pipe/etc. whose destination is the corresponding sublevel will
;        trigger a checkpoint like midway bars, and the checkpoint will lead to this entrance.
;  3 = This option enables both the effects of 1 (midway bar) and 2 (level entrances).
;
; NOTE: The custom midway objects could do almost everything that you may want without using this.
;       However this may be easier to use for some people, and it's what original retry also uses.
;
; For example, having $32 as the value for level 105 will set the value 3 for the Retry prompt
; (no prompt + play only the sfx) and 2 for the checkpoint (any entrance to the level will set a checkpoint).

checkpoint_effect:
;       0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 000-00F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 010-01F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 020-02F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 030-03F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 040-04F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 050-05F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 060-06F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 070-07F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 080-08F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 090-09F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 0A0-0AF
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 0B0-0BF
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 0C0-0CF
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 0D0-0DF
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 0E0-0EF
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 0F0-0FF
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 100-10F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 110-11F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 120-12F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 130-13F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 140-14F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 150-15F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 160-16F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 170-17F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 180-18F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 190-19F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 1A0-1AF
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 1B0-1BF
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 1C0-1CF
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 1D0-1DF
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 1E0-1EF
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 1F0-1FF

;==================;
; Lose Lives table ;
;==================;
; This table allows you to set in which sublevels dying will cause the life counter to decrease.
; By default it's set to all 0, meaning that the game will effectively have infinite lives,
; which is recommended for Kaizo or very hard standard hacks.
; Still, if your game has some easier levels or a mix of standard and Kaizo, for example, you may
; want to keep the vanilla life system, at least in some levels, and you can do that by changing the table.
; Note that this is independent of the Retry prompt settings: you could have a level with instant respawn and
; no infinite lives, although that may not be recommended: usually this works better for levels with the vanilla death sequence.
;
; Each digit in the table corresponds to a sublevel: if a digit is set to 1,
; the corresponding sublevel will have life loss enabled.
; For example, %10000001 as the first value means the setting is on for levels 000 and 007.
;
; The guides at the top and right of the table should help visualize it.

lose_lives:
;       01234567  89ABCDEF
    db %00000000,%00000000 ; 000-00F
    db %00000000,%00000000 ; 010-01F
    db %00000000,%00000000 ; 020-02F
    db %00000000,%00000000 ; 030-03F
    db %00000000,%00000000 ; 040-04F
    db %00000000,%00000000 ; 050-05F
    db %00000000,%00000000 ; 060-06F
    db %00000000,%00000000 ; 070-07F
    db %00000000,%00000000 ; 080-08F
    db %00000000,%00000000 ; 090-09F
    db %00000000,%00000000 ; 0A0-0AF
    db %00000000,%00000000 ; 0B0-0BF
    db %00000000,%00000000 ; 0C0-0CF
    db %00000000,%00000000 ; 0D0-0DF
    db %00000000,%00000000 ; 0E0-0EF
    db %00000000,%00000000 ; 0F0-0FF
    db %00000000,%00000000 ; 100-10F
    db %00000000,%00000000 ; 110-11F
    db %00000000,%00000000 ; 120-12F
    db %00000000,%00000000 ; 130-13F
    db %00000000,%00000000 ; 140-14F
    db %00000000,%00000000 ; 150-15F
    db %00000000,%00000000 ; 160-16F
    db %00000000,%00000000 ; 170-17F
    db %00000000,%00000000 ; 180-18F
    db %00000000,%00000000 ; 190-19F
    db %00000000,%00000000 ; 1A0-1AF
    db %00000000,%00000000 ; 1B0-1BF
    db %00000000,%00000000 ; 1C0-1CF
    db %00000000,%00000000 ; 1D0-1DF
    db %00000000,%00000000 ; 1E0-1EF
    db %00000000,%00000000 ; 1F0-1FF

;=======================;
; Echo SFX Enable table ;
;=======================;
; Allows you to enable echo on SFX on a sublevel basis.
; You can already do that easily with an UberASM init code, but it may be tedious
; to have to insert the same code in a lot of levels, so this table makes it easier.
;
; Format is the same as the lose_lives table: each digit corresponds to one sublevel.
;
; NOTE: this feature only works with AddmusicK.

sfx_echo:
;       01234567  89ABCDEF
    db %00000000,%00000000 ; 000-00F
    db %00000000,%00000000 ; 010-01F
    db %00000000,%00000000 ; 020-02F
    db %00000000,%00000000 ; 030-03F
    db %00000000,%00000000 ; 040-04F
    db %00000000,%00000000 ; 050-05F
    db %00000000,%00000000 ; 060-06F
    db %00000000,%00000000 ; 070-07F
    db %00000000,%00000000 ; 080-08F
    db %00000000,%00000000 ; 090-09F
    db %00000000,%00000000 ; 0A0-0AF
    db %00000000,%00000000 ; 0B0-0BF
    db %00000000,%00000000 ; 0C0-0CF
    db %00000000,%00000000 ; 0D0-0DF
    db %00000000,%00000000 ; 0E0-0EF
    db %00000000,%00000000 ; 0F0-0FF
    db %00000000,%00000000 ; 100-10F
    db %00000000,%00000000 ; 110-11F
    db %00000000,%00000000 ; 120-12F
    db %00000000,%00000000 ; 130-13F
    db %00000000,%00000000 ; 140-14F
    db %00000000,%00000000 ; 150-15F
    db %00000000,%00000000 ; 160-16F
    db %00000000,%00000000 ; 170-17F
    db %00000000,%00000000 ; 180-18F
    db %00000000,%00000000 ; 190-19F
    db %00000000,%00000000 ; 1A0-1AF
    db %00000000,%00000000 ; 1B0-1BF
    db %00000000,%00000000 ; 1C0-1CF
    db %00000000,%00000000 ; 1D0-1DF
    db %00000000,%00000000 ; 1E0-1EF
    db %00000000,%00000000 ; 1F0-1FF

;=================;
; Reset RNG table ;
;=================;
; With this table you can control in which sublevels the RNG seeds will be reset when dying.
; 1 = reset RNG, 0 = don't reset RNG.
; By default this applies to all levels, to have consistent setups after death,
; but you can disable it when preferred.
;
; Format is the same as the lose_lives table: each digit corresponds to one sublevel.

reset_rng:
;       01234567  89ABCDEF
    db %11111111,%11111111 ; 000-00F
    db %11111111,%11111111 ; 010-01F
    db %11111111,%11111111 ; 020-02F
    db %11111111,%11111111 ; 030-03F
    db %11111111,%11111111 ; 040-04F
    db %11111111,%11111111 ; 050-05F
    db %11111111,%11111111 ; 060-06F
    db %11111111,%11111111 ; 070-07F
    db %11111111,%11111111 ; 080-08F
    db %11111111,%11111111 ; 090-09F
    db %11111111,%11111111 ; 0A0-0AF
    db %11111111,%11111111 ; 0B0-0BF
    db %11111111,%11111111 ; 0C0-0CF
    db %11111111,%11111111 ; 0D0-0DF
    db %11111111,%11111111 ; 0E0-0EF
    db %11111111,%11111111 ; 0F0-0FF
    db %11111111,%11111111 ; 100-10F
    db %11111111,%11111111 ; 110-11F
    db %11111111,%11111111 ; 120-12F
    db %11111111,%11111111 ; 130-13F
    db %11111111,%11111111 ; 140-14F
    db %11111111,%11111111 ; 150-15F
    db %11111111,%11111111 ; 160-16F
    db %11111111,%11111111 ; 170-17F
    db %11111111,%11111111 ; 180-18F
    db %11111111,%11111111 ; 190-19F
    db %11111111,%11111111 ; 1A0-1AF
    db %11111111,%11111111 ; 1B0-1BF
    db %11111111,%11111111 ; 1C0-1CF
    db %11111111,%11111111 ; 1D0-1DF
    db %11111111,%11111111 ; 1E0-1EF
    db %11111111,%11111111 ; 1F0-1FF

;=====================================;
; Save and SRAM default values tables ;
;=====================================;
; This table can be used to save custom values to SRAM, so they can persist when the console is turned off. By default it saves the custom checkpoint ram and the death counter.
; Each line is formatted as follows:
;  dl $XXXXXX : dw $YYYY
; where:
;  $XXXXXX = what RAM address to save. Make sure it's always 3 bytes long (i.e. use $7E0019 instead of $19 or $0019).
;  $YYYY = how many bytes to save at that address (remove the $ to use a decimal value).
; For example, adding "dl $7E1F3C : dw 12" will make the 1-Up checkpoints for all levels save.
; Make sure to always put a colon between the two elements!
;
; NOTE: for each address you add here, you need to add the default values in the sram_defaults table below.
; NOTE: if using SA-1, for addresses in $7E0000-$7E1FFF you must change the bank to $40 ($400000-$401FFF).
; NOTE: if using FastROM, using $000000-$001FFF instead of $7E0000-$7E1FFF will make the save/load process a bit faster.

save:
    dl !ram_checkpoint    : dw 192
    dl !ram_death_counter : dw 5

    ; Feel free to add your own stuff here.
    
    
    

; Here you specify the default values of the addresses you want to save, for when a new save file is started.
; You can do "db $XX,$XX,..." for 1 byte values, "dw $XXXX,$XXXX,..." for 2 bytes values and "dl $XXXXXX,$XXXXXX,..." for 3 bytes values.
; The amount of values of each entry should correspond to the dw $YYYY value in the save table
; (for example, the checkpoint values are 192, and the death counter values are 5).

sram_defaults:
    
    ; Default checkpoint values (don't edit this!).
    dw $0000,$0001,$0002,$0003,$0004,$0005,$0006,$0007
    dw $0008,$0009,$000A,$000B,$000C,$000D,$000E,$000F
    dw $0010,$0011,$0012,$0013,$0014,$0015,$0016,$0017
    dw $0018,$0019,$001A,$001B,$001C,$001D,$001E,$001F
    dw $0020,$0021,$0022,$0023,$0024,$0101,$0102,$0103
    dw $0104,$0105,$0106,$0107,$0108,$0109,$010A,$010B
    dw $010C,$010D,$010E,$010F,$0110,$0111,$0112,$0113
    dw $0114,$0115,$0116,$0117,$0118,$0119,$011A,$011B
    dw $011C,$011D,$011E,$011F,$0120,$0121,$0122,$0123
    dw $0124,$0125,$0126,$0127,$0128,$0129,$012A,$012B
    dw $012C,$012D,$012E,$012F,$0130,$0131,$0132,$0133
    dw $0134,$0135,$0136,$0137,$0138,$0139,$013A,$013B

    ; Initial death counter value (don't edit this!).
    db $00,$00,$00,$00,$00

    ; Feel free to add your own stuff here.
    
    
    
