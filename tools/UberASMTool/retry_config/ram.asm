includeonce

; What freeram Retry uses: 257 + (!max_custom_midway_num*4) bytes are used.
; On SA-1, only !retry_freeram_sa1 is used.
!retry_freeram     = $7FB400
!retry_freeram_sa1 = $40A400

; Don't change from here.
if read1($00FFD5) == $23
    !retry_freeram = !retry_freeram_sa1
endif ; read1($00FFD5) == $23

macro retry_ram(name,offset)
    !ram_<name> #= !retry_freeram+<offset>
    !retry_ram_<name> #= !ram_<name>
    if defined("retry_source")
        base !ram_<name>
            global ram_<name>:
        base off
    endif
endmacro

; Use the same offsets as the retry patch to keep compatibility with other resources.
; The way to read these is: each row defines a Retry freeram address, where the name is the name to append to "!retry_ram_", and the number is the offset from !retry_freeram.
; For example, "%retry_ram(is_respawning,$05)" is defining "!retry_ram_is_respawning" as address "!retry_freeram+$05" (the "1" in the comment just means it's a 1 byte address).
; To use these in UberASM code, just use "retry_ram_is_respawning" (or whatever address you want), without the "!".
; To use these in other codes (patch, sprites, etc.), copy this file in the block/patch/sprite folder, then add this line to the file where you want to use it:
;    incsrc "ram.asm"
; Then you can use them like "!retry_ram_is_respawning".

%retry_ram(timer,$00)                       ; 3
%retry_ram(respawn,$03)                     ; 2
%retry_ram(is_respawning,$05)               ; 1
%retry_ram(music_to_play,$06)               ; 1
%retry_ram(hurry_up,$07)                    ; 1
%retry_ram(door_dest,$08)                   ; 2
%retry_ram(music_backup,$0A)                ; 1
%retry_ram(update_request,$0B)              ; 1
%retry_ram(prompt_phase,$0C)                ; 1
%retry_ram(update_window,$0D)               ; 1
%retry_ram(is_dying,$0E)                    ; 1
%retry_ram(gm_backup,$0F)                   ; 1
%retry_ram(midway_powerup,$10)              ; 1
%retry_ram(prompt_override,$11)             ; 1
%retry_ram(disable_prompt_exit,$12)         ; 1
%retry_ram(set_checkpoint,$13)              ; 2
%retry_ram(prompt_x_pos,$15)                ; 1
%retry_ram(prompt_y_pos,$16)                ; 1
%retry_ram(disable_prompt_bg,$17)           ; 1
%retry_ram(play_sfx,$18)                    ; 1
%retry_ram(midways_override,$19)            ; 1
%retry_ram(coin_backup,$1A)                 ; 1
%retry_ram(lives_backup,$1B)                ; 1
%retry_ram(bonus_stars_backup,$1C)          ; 1
%retry_ram(status_bar_item_box_tile,$1D)    ; 2
%retry_ram(status_bar_timer_tile,$1F)       ; 2
%retry_ram(status_bar_coins_tile,$21)       ; 2
%retry_ram(status_bar_lives_tile,$23)       ; 2
%retry_ram(status_bar_bonus_stars_tile,$25) ; 2
%retry_ram(status_bar_death_tile,$27)       ; 2
%retry_ram(status_bar_force_upload,$29)     ; 1
%retry_ram(canary,$2A)                      ; 2
%retry_ram(reserved,$2C)                    ; 15 (reserved for future expansion)
%retry_ram(death_counter,$3B)               ; 5
%retry_ram(checkpoint,$40)                  ; 192
%retry_ram(cust_obj_data,$100)              ; 1+(!max_custom_midway_num*4)

; What freeram is used by AddmusicK. Shouldn't need to be changed usually.
!amk_freeram = $7FB000
