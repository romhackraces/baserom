; To apply changes to the baserom in the main folder, just execute 'save_common_patch_settings.bat'.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    Retry System                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


!default_prompt_type = $01      ; $00 = play the death jingle when players die
                                ; $01 = play only the sfx when players die (music won't be interrupted)
                                ; $02 = play only the sfx & skip the prompt (the fastest option; "yes" is chosen automatically)
                                ;       in this option, you can press start then select to exit the level
                                ; $03 = no retry prompt (as if "no" is chosen automatically, use this if you only want the multi-midway feature)


;;; the below is sfx which may be used instead of the death jingle
;;; for the list of vanilla sfx, check https://www.smwcentral.net/?p=viewthread&t=6665
;;; or use addmusick to insert the custom sfx

!death_sfx = $2A                ; $01-$FF: sfx number
!death_sfx_bank = $1DFC         ; $1DF9 or $1DFC
