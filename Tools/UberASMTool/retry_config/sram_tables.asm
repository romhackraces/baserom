;=====================================;
; Things to Save                      ;
;=====================================;

!DragonCoinSaving = 0

; Matches Asar\DragonCoinSave.asm
!dcsave_freeram     = $7FA660   ; 0x300 bytes, $7FA660-$7FA95F
!dcsave_freeram_sa1 = $40A660   ; 0x300 bytes, $40A660-$40A95F

;=====================================;
; Save and SRAM default values tables ;
;=====================================;
; This table can be used to save custom values to SRAM, so they can persist when the console is turned off.
; By default it saves the custom checkpoint ram (so multiple midways will save properly) and the death counter.
; Each line is formatted as follows:
;  dl $XXXXXX : dw $YYYY
; where:
;  $XXXXXX = what RAM address to save. Make sure it's always 3 bytes long (i.e. use $7E0019 instead of $19 or $0019).
;  $YYYY = how many bytes to save at that address (remove the $ to use a decimal value).
; For example, adding "dl $7E1F3C : dw 12" will make the 1-Up checkpoints for all levels save.
; Make sure to always put a colon between the two elements!
; The addresses you put under ".not_game_over" will be saved like usual, but they won't be reloaded from SRAM when getting a game over.
; This can be useful if you want some things to retain even if the player got a game over before being able to save them.
;
; Note: for each address you add here, you need to add the default values in the sram_defaults table below.
; Note: if using SA-1, for addresses in $7E0000-$7E1FFF you must change the bank to $40 ($400000-$401FFF).
;       Additionally, a lot of other addresses might be remapped to different locations (see SA-1 docs for more info).
; Note: if using FastROM, using $000000-$001FFF instead of $7E0000-$7E1FFF will make the save/load process a bit faster.


save:
    dl !ram_checkpoint    : dw 192
    ; Feel free to add your own stuff here.

if !DragonCoinSaving
    ; Dragon Coin saving
    if !sa1
        dl $401F2F : dw $000C
        dl !dcsave_freeram : dw $0300
    else
        dl $7E1F2F : dw $000C
        dl !dcsave_freeram_sa1 : dw $0300
    endif
endif

.not_game_over:
    dl !ram_death_counter : dw 5
    ; Feel free to add your own stuff here.


; Here you specify the default values of the addresses you want to save, for when a new save file is started.
; You can do "db $XX,$XX,..." for 1 byte values, "dw $XXXX,$XXXX,..." for 2 bytes values and "dl $XXXXXX,$XXXXXX,..." for 3 bytes values.
; The amount of values of each entry should correspond to the dw $YYYY value in the save table
; (for example, the checkpoint values are 192, and the death counter values are 5).
; If you have some addresses after ".not_game_over" in the save table, put their default values after ".not_game_over" here too
; (in the same order as the other table, of course).
; Note: you can use a shorthand for big addresses with all the same default values, so you don't have to write
; "db $YY" dozens of times: rep X : db $YY where X = amount of values, $YY = value to repeat. See below for an example.

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
    ; Feel free to add your own stuff here.

if !DragonCoinSaving
    ; Dragon Coin Save
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
    db $C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00
endif

.not_game_over:
    ; Initial death counter value (don't edit this!).
    rep 5 : db $00
    ; Feel free to add your own stuff here.


