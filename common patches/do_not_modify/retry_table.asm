
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; global settings                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!lose_lives = $00               ; $00 = not lose your lives when you die
                                ; $01 = lose your lives (vanilla)

!initial_lives = 99             ; in decimal

!midway_powerup = $00           ; $00 = small
                                ; $01 = big (vanilla)

!counterbreak_yoshi = $01       ; $00 = no (vanilla), $01 = yes (resets your yoshi status when you die or enter a level)
                                ; set this to $01 if you have a problem of yoshi not respawned in a level with no yoshi intro
                                ; (corresponding to !clear_parked_yoshi in version 2.04 or below)

!counterbreak_powerup = $01     ; $00 = no (vanilla), $01 = yes (resets your powerup status when you die or enter a level)
                                ; (corresponding to !clear_itembox in version 2.04 or below)

!counterbreak_coin = $01        ; $00 = no (vanilla), $01 = yes (resets coins when you die or enter a level)




!sprite_initial_face_fix = $01  ; $00 = fix only when resetting a level
                                ; $01 = always fix (RECOMMENDED)

!reset_rng = $01                ; $00 = do not reset the random number generator when resetting a level
                                ; $01 = reset the random number generator when resetting a level


!midway_sram = $00		; $00 = no, $01 = yes (install the code that saves the midway states to SRAM)
				; this feature does not support SA-1 ROMs, for which this option will be ignored. (you will need BWRAM Plus instead.)
				; if you are already using SRAM Plus, this option will be ignored.
				; * whenever you change this option and apply the patch, erase the previous srm file from your hard drive.


!max_custom_midway_num = $08    ; the number of custom midway bars (custom object) allowed in one sublevel
                                ; the bigger, the more free ram address is required


;;; free RAM addresses
!freeram = $7FB400              ; 12 bytes
!freeram_checkpoint = $7FB40C   ; 192 bytes
!freeram_custobjdata = $7FB4CC  ; (!max_custom_midway_num*4)+1 bytes (33 bytes for $08)

; *** in case you're using SA-1 *** (if not, you may skip this)
!freeram_SA1 = $40B400              ; 12 bytes
!freeram_checkpoint_SA1 = $40B40C   ; 192 bytes
!freeram_custobjdata_SA1 = $40B4CC  ; (!max_custom_midway_num*4)+1 bytes (33 bytes for $08)



;;; the alternative death jingle which will be played after the death_sfx when "no" is chosen.
;;; (only available when you're using addmusick)
!death_jingle_alt = $FF         ; $01-$FE: custom song number, $FF = do not use this feature

!addmusick_ram_addr = $7FB000   ; don't need to change this in most case


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; local settings (for each translevel)  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; decides the prompt type
;;; $00 = follow the global setting (!default_prompt_type)
;;; $01 = play the death jingle when players die
;;; $02 = play only the sfx when players die (music won't be interrupted)
;;; $03 = play only the sfx & skip the prompt (the fastest option; "yes" is chosen automatically)
;;;       in this option, you can press start then select to exit the level
;;; $04 = no retry (as if "no" is chosen automatically)

.effect
db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;Levels 0~F
db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;Levels 10~1F
db $00,$00,$00,$00,$00							;Levels 20~24
db     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;Levels 101~10F
db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;Levels 110~11F
db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;Levels 120~12F
db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00			;Levels 130~13B


incsrc ../retry_prompt_settings.asm
incsrc ../multiple_midway_settings.asm
