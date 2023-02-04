; Retry table-based settings. These are used to have different settings for different levels.

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
    db $00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 100-10F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 110-11F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 120-12F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 130-13F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 140-14F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 150-15F
    db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02 ; 160-16F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 170-17F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 180-18F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 190-19F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 1A0-1AF
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 1B0-1BF
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 1C0-1CF
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 1D0-1DF
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 1E0-1EF
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 1F0-1FF

;=======================;
; Echo SFX Enable table ;
;=======================;
; Allows you to enable echo on SFX on a sublevel basis.
; You can already do that easily with an UberASM init code, but it may be tedious
; to have to insert the same code in a lot of levels, so this table makes it easier.
;
; Each digit in the table corresponds to a sublevel: if a digit is set to 1,
; the corresponding sublevel will have life loss enabled.
; For example, %10000001 as the first value means the setting is on for levels 000 and 007.
; The guides at the top and right of the table should help visualize it.
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
; Format is the same as the sfx_echo table: each digit corresponds to one sublevel.

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

;===================================;
; Disable Room Checkpoint SFX table ;
;===================================;
; This table is used when !room_cp_sfx is not $00 in "settings.asm".
; It allows you to disable the SFX that plays when getting a room entrance checkpoint
; for specific sublevels (if the value in this table is 1 for that sublevel).
; Of course, the value here doesn't matter if the sublevel doesn't give checkpoints on entrance
; (i.e., if the checkpoint value in the "checkpoint_effect" table is not 2 or 3).
; Note: if you don't want the SFX in any level, don't use this but just set !room_cp_sfx = $00.
;
; Format is the same as the sfx_echo table: each digit corresponds to one sublevel.

disable_room_cp_sfx:
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

;==================;
; Lose Lives table ;
;==================;
; This table is only used when !infinite_lives = 0 in settings.asm.
; With this, you can choose to disable life loss for specific sublevels, while keeping it for all others.
; It could be useful for tutorial rooms, cutscenes, etc. or for harder levels in a non-Kaizo collab.
; Note: if you just want to have infinite lives for the entire game,
; don't use this but just set !infinite_lives = 1 in settings.asm.
;
; Format is the same as the sfx_echo table: each digit corresponds to one sublevel.

lose_lives:
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
