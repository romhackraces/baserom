; Miscellaneous stuff used by retry.
; You usually shouldn't edit this file.

; Retry version number (Va.b.c) to write in ROM.
!version_a = 0
!version_b = 3
!version_c = 5

; Read death time from ROM.
!death_time #= read1($00F61C)

; Read death pose value from ROM.
!death_pose #= read1($00D0B9)

; Read death song number from ROM.
!death_song #= read1($00F60B)

; Read timer seconds duration from ROM.
!timer_ticks #= read1($008D8B)

; What button exits the level while the game is paused (by default, select).
!exit_level_buttons_addr = $16
!exit_level_buttons_bits = $20

; Level number of the intro level (automatically adjusted to $01C5 when necessary).
!intro_level = $00C5

if read2($01E762) == $EAEA && read1($009EF0) != $00
    !intro_sublevel #= !intro_level|$0100
else
    !intro_sublevel #= !intro_level
endif

; Level number (low byte) of the Yoshi Wings levels.
!wings_level = read1($05DBAA)

; OW translevel number table.
if !sa1
    !7ED000 = $40D000
else
    !7ED000 = $7ED000
endif

; Stripe image table defines.
!stripe_index = $7F837B
!stripe_table = $7F837D

; Address for the custom midway amount.
!ram_cust_obj_num = !ram_cust_obj_data+(!max_custom_midway_num*4)

; Address for the custom midway entrance value.
!ram_cust_obj_entr = !ram_cust_obj_data+(!max_custom_midway_num*2)

; Detect Lunar Magic v3.0+.
if (((read1($0FF0B4)-'0')*100)+((read1($0FF0B4+2)-'0')*10)+(read1($0FF0B4+3)-'0')) > 253
    !lm3 = 1
else
    !lm3 = 0
endif

; Detect AddmusicK.
if read1($008075) == $5C
    !amk = 1
else
    !amk = 0
endif

; Detect ObjecTool.
if read1($0DA106) == $5C
    !object_tool = 1
else
    !object_tool = 0
endif

; Detect the SRAM Plus patch.
if read1($009B42) == $04
    !sram_plus = 1
else
    !sram_plus = 0
endif

; Detect the BW-RAM Plus patch.
if read1($009BD2) == $5C
    !bwram_plus = 1
else
    !bwram_plus = 0
endif

; Detect if using PIXI's 255 sprite per level feature.
if read1($01AC9C) == $5C && read3(read3($01AC9C+1)+5) == $7FAF00
    !255_sprites_per_level = 1
else
    !255_sprites_per_level = 0
endif

if !sa1
    !255_sprites_per_level = 1
endif

; Define the sprites load table address.
if !255_sprites_per_level
    %define_sprite_table(sprite_load_table, $7FAF00, $418A00)
else
    %define_sprite_table(sprite_load_table, $1938, $418A00)
endif

; Detects lx5's Custom Powerups.
if read2($00D067) == $DEAD
    !custom_powerups = 1
    incsrc powerup_defs.asm
else
    !custom_powerups = 0
endif

; Detects the "Individual Dragon Coins Save" patch.
if read1($05D7AB) == $5C
    !dcsave = 1
else
    !dcsave = 0
endif

; Detects lx5's Dynamic Spriteset System.
if read3($01DF78) == $535344
    !dss = 1
else
    !dss = 0
endif

; Check which channel is used for windowing HDMA, for SA-1 v1.35 (H)DMA remap compatibility.
; It will be 7 on lorom or with SA-1 <1.35, and 1 with SA-1 >=1.35.
!window_mask    #= read1($0092A1)
!window_channel #= log2(!window_mask)

; Where in VRAM the prompt tiles will be uploaded to. You should never need to edit this.
; $6000 = SP1/SP2, $7000 = SP3/SP4.
!base_vram = $6000
