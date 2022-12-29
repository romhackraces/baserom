; Miscellaneous stuff used by Retry.
; You usually shouldn't edit this file.

; Retry version number (Va.b.c) to write in ROM.
!version_a = 0
!version_b = 4
!version_c = 3

; Read death time from ROM.
!death_time #= read1($00F61C)

; What button exits the level while the game is paused (by default, select).
!exit_level_buttons_addr = $16
!exit_level_buttons_bits = $20

; Level number of the intro level (automatically adjusted to $01C5 when necessary).
!intro_level = $00C5

; Stripe image table defines.
!stripe_index = $7F837B
!stripe_table = $7F837D

; Address for the custom midway amount.
!ram_cust_obj_num = !ram_cust_obj_data+(!max_custom_midway_num*4)

; Address for the custom midway entrance value.
!ram_cust_obj_entr = !ram_cust_obj_data+(!max_custom_midway_num*2)

; Define the custom sprites load table address.
%define_sprite_table(sprite_load_table, $7FAF00, $418A00)

; OW translevel number table.
if !sa1
    !7ED000 = $40D000
else
    !7ED000 = $7ED000
endif

; Check which channel is used for windowing HDMA, for SA-1 v1.35 (H)DMA remap compatibility.
; It will be 7 on lorom or with SA-1 <1.35, and 1 with SA-1 >=1.35.
!window_mask    #= read1($0092A1)
!window_channel #= log2(!window_mask)

; Where in VRAM the prompt tiles will be uploaded to. You should never need to edit this.
; $6000 = SP1/SP2, $7000 = SP3/SP4.
!base_vram = $6000

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

; Detects lx5's Custom Powerups.
if read2($00D067) == $DEAD
    !custom_powerups = 1
    incsrc powerup_defs.asm
else
    !custom_powerups = 0
endif

; Detects the "Level Depending on Ram" and similar patches.
if read1($05DCDD) == $22 || read1($05DCE2) == $22
    !dynamic_ow_levels = 1
else
    !dynamic_ow_levels = 0
endif
