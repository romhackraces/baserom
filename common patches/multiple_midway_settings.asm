; To apply changes to the baserom in the main folder, just execute 'save_common_patch_settings.bat'.

; Alternatively you can use the new custom midway objects.
; See "custom_bar.png".


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    Multiple Midway Settings     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The following table sets the behavior of a midway bar and level entrances(main/secondary/midway) in each sublevel.
; $00 = Vanilla. The midway bar in the corresponding sublevel will lead to the midway entrance of the main level.
; $01 = The Midway bar in the corresponding sublevel will lead to the midway entrance of this sublevel as a checkpoint.
; $02 = Any main/secondary/midway entrance through door/pipe/etc. whose destination is the corresponding sublevel will trigger a checkpoint like midway bars,
;       and the checkpoint will lead to this entrance.
; $03 = This option enables both the effects of $01(midway bar) and $02(level entrances).



.checkpoint
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 000-00F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 010-01F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 020-02F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 030-03F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 040-04F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 050-05F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 060-06F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 070-07F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 080-08F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 090-09F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 0A0-0AF
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 0B0-0BF
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 0C0-0CF
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 0D0-0DF
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 0E0-0EF
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 0F0-0FF
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 100-10F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 110-11F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 120-12F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 130-13F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 140-14F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 150-15F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 160-16F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 170-17F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 180-18F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 190-19F
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 1A0-1AF
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 1B0-1BF
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 1C0-1CF
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 1D0-1DF
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 1E0-1EF
db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01	;Sublevels 1F0-1FF

