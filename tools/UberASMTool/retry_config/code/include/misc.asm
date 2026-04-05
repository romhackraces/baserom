; Miscellaneous stuff used by Retry.
; You usually shouldn't edit this file.

; Retry version number to write in ROM.
!version = "2.0.1"

; Print version in the terminal
print "    Retry System version: !version"

; What button exits the level while the game is paused (by default, select).
!exit_level_buttons_addr = $16
!exit_level_buttons_bits = $20

; Level number of the intro level (automatically adjusted to $01C5 when necessary).
!intro_level = $00C5

; Read death time from ROM.
!death_time #= read1($00F61C)

; SRAM size in the ROM header. Actual size is (2^!sram_size) KB.
; You can change it to expand the SRAM to bigger sizes.
; On SA-1 it's not recommended to be changed as this value is not actually used:
; the SRAM size is fixed to 128KB, but only 8KB are reserved for a custom SRAM
; area. If you know what you're doing, you can edit the !file_size define
; directly and also edit !sram_addr below if needed.
!sram_size = $03

; How many save files are in your hack. If you're using patches that reduce
; them, you can change this to have more SRAM available for each one.
!file_number = 3

; How big (in bytes) each save file is in SRAM/BW-RAM.
; This is auto-calculated so that the SRAM can hold enough data for 3 of our
; custom file size and $400 of the vanilla file size (even though vanilla does
; not use $400 bytes entirely, we use the unused area for the global variables).
!file_size #= floor((((2**!sram_size)*1024)-$400)/!file_number)

; SRAM/BW-RAM address to save to.
if !sa1
    !sram_addr        #= $41A000
    !sram_addr_global #= !sram_addr+(!file_size*!file_number)
else ; if not(!sa1)
    !sram_addr        #= $700400
    !sram_addr_global #= $7002CB+143
endif ; !sa1

; Check which channel is used for windowing HDMA, for SA-1 v1.35 (H)DMA remap compatibility.
; It will be 7 on lorom or with SA-1 <1.35, and 1 with SA-1 >=1.35.
!window_mask    #= read1($0092A1)
!window_channel #= log2(!window_mask)

; DMA channel used to upload the GFX tiles.
; This one should be fine for both lorom and SA-1, even if the DMA remap patch
; is used.
!upload_channel = 2

; Where in VRAM the prompt tiles will be uploaded to.
!sprite_vram = $6000

; Default amount of Yoshi Coins per level, used for the sprite status bar.
; Note that usually this is not used, as the value is read from the ROM.
; In case of patches editing the area around $00F346 (except for the
; "Per Level Yoshi Coins Amount" patch) then this value will be used.
!default_dc_amount = 5

; Stripe image table defines.
!stripe_index = $7F837B
!stripe_table = $7F837D

; Define the original and remapped sprites load table addresses.
; Note that !sprite_load_table_orig should not have |!addr (lorom only).
!sprite_load_table_orig = $1938
%define_sprite_table(sprite_load_table_remapped, $7FAF00, $418A00)

; OW translevel number table.
if !sa1
    !7ED000 = $40D000
else ; if not(!sa1)
    !7ED000 = $7ED000
endif ; !sa1

; Detect the SRAM Plus patch.
if read1($009B42) == $04
    !sram_plus = 1
else ; if not(read1($009B42) == $04)
    !sram_plus = 0
endif ; read1($009B42) == $04

; Detect the BW-RAM Plus patch.
if read1($009BD2) == $5C
    !bwram_plus = 1
else ; if not(read1($009BD2) == $5C)
    !bwram_plus = 0
endif ; read1($009BD2) == $5C

; Detects lx5's Custom Powerups.
if read2($00D067) == $DEAD
    !custom_powerups = 1
else ; if not(read2($00D067) == $DEAD)
    !custom_powerups = 0
endif ; read2($00D067) == $DEAD

; Detects the "Level Depending on Ram" and similar patches.
if read1($05DCDD) == $22 || read1($05DCE2) == $22
    !dynamic_ow_levels = 1
else ; if not(read1($05DCDD) == $22 || read1($05DCE2) == $22)
    !dynamic_ow_levels = 0
endif ; read1($05DCDD) == $22 || read1($05DCE2) == $22

; Detects if SA-1 MaxTile is inserted.
if read1($00FFD5) == $23 && read3($0084C0) == $5A123 && read1($0084C3) >= 140
    !maxtile = 1
    !maxtile_buffer_max    = $6180
    !maxtile_buffer_high   = $6190
    !maxtile_buffer_normal = $61A0
    !maxtile_buffer_low    = $61B0
else ; if not(read1($00FFD5) == $23 && read3($0084C0) == $5A123 && read1($0084C3) >= 140)
    !maxtile = 0
endif ; read1($00FFD5) == $23 && read3($0084C0) == $5A123 && read1($0084C3) >= 140

; Macro to insert a table of repeating 1 byte values
macro dbn(val, n)
    fillbyte <val> : fill <n>
endmacro

; Macro to insert a table of repeating 2 byte values
macro dwn(val, n)
    fillword <val> : fill (<n>)*2
endmacro

; Macro to insert a table of repeating 3 byte values
macro dln(val, n)
    filllong <val> : fill (<n>)*3
endmacro

; Macro to insert a table of repeating 4 byte values
macro ddn(val, n)
    filldword <val> : fill (<n>)*4
endmacro

; Only used for breakpoints during debugging (stolen from Selicre)
macro debug(x)
    sta.l $005000+<x>
endmacro

; Deprecated label macro used for documentation purposes
macro deprecated(x)
    <x>:
endmacro
