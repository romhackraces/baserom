;================================================================================
; This file handles some processes that need to run at the very end of the main game loop:
; - Death routine: if the player died on this frame, it needs to prevent the
;   death song from playing when applicable, before the music engine is aware
;   of it. It also handles incrementing the death counter-
; - Prompt OAM: if the prompt is being show, it needs to draw it on the
;   screen. You can't draw sprite tiles in gamemode 14 codes, as $7F8000
;   is called shortly after their main code, so we do it here. Being at
;   the end of the loop also allows it to not overwrite sprite tiles used
;   by other elements in the level.
; - Set checkpoint: if a checkpoint has been gotten on this frame (signaled
;   by the !ram_set_checkpoint handle), it needs to actually set it in Retry's
;   RAM. This could be done in gm14 as well, at the start of the next frame,
;   but better to do it as early as possible just to be safe :P
;================================================================================

pushpc

; Hijack the end of game mode 14.
org $00A2EA
    jml gm14_end

pullpc

;================================================================================
; Write a small identifier string in ROM.
; - You can check if a ROM has this patch by doing "if read4(read3($00A2EB)-33) == $72746552"
; - You can find the 3 version number digits at read1(read3($00A2EB)-3), read1(read3($00A2EB)-2) and read1(read3($00A2EB)-1).
;================================================================================
db "Retry patch by KevinM "
db "Version ",!version_a,!version_b,!version_c

gm14_end:
    ; Preserve X and Y and set DBR.
    phx : phy
    phb : phk : plb

    ; Call the custom gm14_end routine.
    php : phb
    jsr extra_gm14_end
    plb : plp

    ; Call the level-specific gm14_end routine.
    php : phb
    jsr run_level_end_frame_code
    plb : plp

    ; Check if we have to set the checkpoint.
    rep #$20
    lda !ram_set_checkpoint : cmp #$FFFF
    sep #$20
    beq .no_checkpoint
    jsr set_checkpoint

.no_checkpoint:
    ; If Mario is dying, call the death routine.
    lda $71 : cmp #$09 : bne .no_death
    jsr death_routine

.no_death:
    ; Check if it's time to draw the tiles.
    lda !ram_prompt_phase : cmp #$02 : beq .draw_prompt
                                       bcc .return
    ; In some cases it's needed to remove the prompt tiles from OAM after the option is chosen.
    jsr erase_tiles
    bra .return
.draw_prompt:
    jsr prompt_oam

.return:
    ; Restore DBR, X and Y.
    plb : ply : plx

    ; Restore original code.
    pla : sta $1D : pla
    jml $00A2EE|!bank

; Import all auxiliary routines called by this file.
incsrc "gm14_end/death_routine.asm"
incsrc "gm14_end/prompt_oam.asm"
incsrc "gm14_end/set_checkpoint.asm"

; Jump to the level-specific "end of level frame" routine.
run_level_end_frame_code:
    rep #$30
    lda $010B|!addr : asl : tax
    lda.w .pointers,x : sta $00
    sep #$30
    jmp ($0000|!dp)

.pointers:
namespace level_end_frame
    dw level000,level001,level002,level003,level004,level005,level006,level007
    dw level008,level009,level00A,level00B,level00C,level00D,level00E,level00F
    dw level010,level011,level012,level013,level014,level015,level016,level017
    dw level018,level019,level01A,level01B,level01C,level01D,level01E,level01F
    dw level020,level021,level022,level023,level024,level025,level026,level027
    dw level028,level029,level02A,level02B,level02C,level02D,level02E,level02F
    dw level030,level031,level032,level033,level034,level035,level036,level037
    dw level038,level039,level03A,level03B,level03C,level03D,level03E,level03F
    dw level040,level041,level042,level043,level044,level045,level046,level047
    dw level048,level049,level04A,level04B,level04C,level04D,level04E,level04F
    dw level050,level051,level052,level053,level054,level055,level056,level057
    dw level058,level059,level05A,level05B,level05C,level05D,level05E,level05F
    dw level060,level061,level062,level063,level064,level065,level066,level067
    dw level068,level069,level06A,level06B,level06C,level06D,level06E,level06F
    dw level070,level071,level072,level073,level074,level075,level076,level077
    dw level078,level079,level07A,level07B,level07C,level07D,level07E,level07F
    dw level080,level081,level082,level083,level084,level085,level086,level087
    dw level088,level089,level08A,level08B,level08C,level08D,level08E,level08F
    dw level090,level091,level092,level093,level094,level095,level096,level097
    dw level098,level099,level09A,level09B,level09C,level09D,level09E,level09F
    dw level0A0,level0A1,level0A2,level0A3,level0A4,level0A5,level0A6,level0A7
    dw level0A8,level0A9,level0AA,level0AB,level0AC,level0AD,level0AE,level0AF
    dw level0B0,level0B1,level0B2,level0B3,level0B4,level0B5,level0B6,level0B7
    dw level0B8,level0B9,level0BA,level0BB,level0BC,level0BD,level0BE,level0BF
    dw level0C0,level0C1,level0C2,level0C3,level0C4,level0C5,level0C6,level0C7
    dw level0C8,level0C9,level0CA,level0CB,level0CC,level0CD,level0CE,level0CF
    dw level0D0,level0D1,level0D2,level0D3,level0D4,level0D5,level0D6,level0D7
    dw level0D8,level0D9,level0DA,level0DB,level0DC,level0DD,level0DE,level0DF
    dw level0E0,level0E1,level0E2,level0E3,level0E4,level0E5,level0E6,level0E7
    dw level0E8,level0E9,level0EA,level0EB,level0EC,level0ED,level0EE,level0EF
    dw level0F0,level0F1,level0F2,level0F3,level0F4,level0F5,level0F6,level0F7
    dw level0F8,level0F9,level0FA,level0FB,level0FC,level0FD,level0FE,level0FF
    dw level100,level101,level102,level103,level104,level105,level106,level107
    dw level108,level109,level10A,level10B,level10C,level10D,level10E,level10F
    dw level110,level111,level112,level113,level114,level115,level116,level117
    dw level118,level119,level11A,level11B,level11C,level11D,level11E,level11F
    dw level120,level121,level122,level123,level124,level125,level126,level127
    dw level128,level129,level12A,level12B,level12C,level12D,level12E,level12F
    dw level130,level131,level132,level133,level134,level135,level136,level137
    dw level138,level139,level13A,level13B,level13C,level13D,level13E,level13F
    dw level140,level141,level142,level143,level144,level145,level146,level147
    dw level148,level149,level14A,level14B,level14C,level14D,level14E,level14F
    dw level150,level151,level152,level153,level154,level155,level156,level157
    dw level158,level159,level15A,level15B,level15C,level15D,level15E,level15F
    dw level160,level161,level162,level163,level164,level165,level166,level167
    dw level168,level169,level16A,level16B,level16C,level16D,level16E,level16F
    dw level170,level171,level172,level173,level174,level175,level176,level177
    dw level178,level179,level17A,level17B,level17C,level17D,level17E,level17F
    dw level180,level181,level182,level183,level184,level185,level186,level187
    dw level188,level189,level18A,level18B,level18C,level18D,level18E,level18F
    dw level190,level191,level192,level193,level194,level195,level196,level197
    dw level198,level199,level19A,level19B,level19C,level19D,level19E,level19F
    dw level1A0,level1A1,level1A2,level1A3,level1A4,level1A5,level1A6,level1A7
    dw level1A8,level1A9,level1AA,level1AB,level1AC,level1AD,level1AE,level1AF
    dw level1B0,level1B1,level1B2,level1B3,level1B4,level1B5,level1B6,level1B7
    dw level1B8,level1B9,level1BA,level1BB,level1BC,level1BD,level1BE,level1BF
    dw level1C0,level1C1,level1C2,level1C3,level1C4,level1C5,level1C6,level1C7
    dw level1C8,level1C9,level1CA,level1CB,level1CC,level1CD,level1CE,level1CF
    dw level1D0,level1D1,level1D2,level1D3,level1D4,level1D5,level1D6,level1D7
    dw level1D8,level1D9,level1DA,level1DB,level1DC,level1DD,level1DE,level1DF
    dw level1E0,level1E1,level1E2,level1E3,level1E4,level1E5,level1E6,level1E7
    dw level1E8,level1E9,level1EA,level1EB,level1EC,level1ED,level1EE,level1EF
    dw level1F0,level1F1,level1F2,level1F3,level1F4,level1F5,level1F6,level1F7
    dw level1F8,level1F9,level1FA,level1FB,level1FC,level1FD,level1FE,level1FF
namespace off
