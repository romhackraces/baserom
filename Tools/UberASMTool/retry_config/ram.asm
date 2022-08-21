;=====================================
; RAM addresses used by retry.
; You usually don't need to change these.
;=====================================

;=====================================
; What freeram to use.
; 230 + (!max_custom_midway_num*4) bytes are used.
;=====================================
!retry_freeram     = $7FB400
!retry_freeram_sa1 = $40A400

;=====================================
; What freeram is used by AMK. Shoudln't need to be changed usually.
;=====================================
!amk_freeram = $7FB000

;=====================================
; Don't change from here.
;=====================================
if read1($00FFD5) == $23
    !retry_freeram = !retry_freeram_sa1
endif

macro retry_ram(name,offset)
    !ram_<name> #= !retry_freeram+<offset>
    !retry_ram_<name> #= !ram_<name>

    pushpc
    warnings disable W1009
        org !ram_<name>
            ram_<name>:
    warnings enable W1009
    pullpc
endmacro

namespace off

; Use the same offsets as the retry patch to keep compatibility with other resources.
; The way to read these is: each row defines a Retry freeram address, where the name is the name to append to "!retry_ram_", and the number is the offset from !retry_freeram.
; For example, "%retry_ram(is_respawning,$05)" is defining "!retry_ram_is_respawning" as address "!retry_freeram+$05" (the "1" in the comment just means it's a 1 byte address).
; To use these in UberASM code, just use "retry_ram_is_respawning" (or whatever address you want), without the "!".
; To use these in other codes (patch, sprites, etc.), copy paste this file's contents at the start of the patch/sprite/etc., then use "!retry_ram_is_respawning" (with "!") or "retry_ram_is_respawning" (without "!").

%retry_ram(timer,$00)           ; 3
%retry_ram(respawn,$03)         ; 2
%retry_ram(is_respawning,$05)   ; 1
%retry_ram(music_to_play,$06)   ; 1
%retry_ram(hurry_up,$07)        ; 1
%retry_ram(door_dest,$08)       ; 2
%retry_ram(music_backup,$0A)    ; 1
%retry_ram(update_request,$0B)  ; 1
%retry_ram(prompt_phase,$0C)    ; 1
%retry_ram(update_window,$0D)   ; 1
%retry_ram(is_dying,$0E)        ; 1
%retry_ram(9D_backup,$0F)       ; 1
%retry_ram(l2_backup,$10)       ; 1
%retry_ram(prompt_override,$11) ; 1
%retry_ram(disable_exit,$12)    ; 1
%retry_ram(set_checkpoint,$13)  ; 2
%retry_ram(prompt_x_pos,$15)    ; 1
%retry_ram(prompt_y_pos,$16)    ; 1
%retry_ram(disable_box,$17)     ; 1
%retry_ram(play_sfx,$18)        ; 1
%retry_ram(reserved,$19)        ; 7 (reserved for future expansion)
%retry_ram(death_counter,$20)   ; 5
%retry_ram(checkpoint,$25)      ; 192
%retry_ram(cust_obj_data,$E5)   ; 1+(!max_custom_midway_num*4)
