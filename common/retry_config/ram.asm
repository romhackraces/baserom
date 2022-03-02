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

; Use the same offsets as the retry patch to keep compatibility with other resources.
!ram_timer           = !retry_freeram+$00 ; 3
!ram_respawn         = !retry_freeram+$03 ; 2
!ram_is_respawning   = !retry_freeram+$05 ; 1
!ram_music_to_play   = !retry_freeram+$06 ; 1
!ram_hurry_up        = !retry_freeram+$07 ; 1
!ram_door_dest       = !retry_freeram+$08 ; 2
!ram_music_backup    = !retry_freeram+$0A ; 1
!ram_update_request  = !retry_freeram+$0B ; 1
!ram_prompt_phase    = !retry_freeram+$0C ; 1
!ram_update_window   = !retry_freeram+$0D ; 1
!ram_is_dying        = !retry_freeram+$0E ; 1
!ram_9D_backup       = !retry_freeram+$0F ; 1
!ram_l2_backup       = !retry_freeram+$10 ; 1
!ram_prompt_override = !retry_freeram+$11 ; 1
!ram_disable_exit    = !retry_freeram+$12 ; 1
!ram_set_checkpoint  = !retry_freeram+$13 ; 2
!ram_prompt_x_pos    = !retry_freeram+$15 ; 1
!ram_prompt_y_pos    = !retry_freeram+$16 ; 1
!ram_disable_box     = !retry_freeram+$17 ; 1
!ram_reserved        = !retry_freeram+$18 ; 8 (reserved for future expansion)
!ram_death_counter   = !retry_freeram+$20 ; 5
!ram_checkpoint      = !retry_freeram+$25 ; 192
!ram_cust_obj_data   = !retry_freeram+$E5 ; 1+(!max_custom_midway_num*4)
