includeonce

; Resource Freeram
!block_duplication_freeram = $13E6|!addr ; 2 bytes
!capespin_direction_freeram = $1869|!addr ; 2 bytes
!double_hit_fix_freeram = $1DFD|!addr ; 1 byte
!screen_scrolling_pipes_freeram = $18C5|!addr ; 5 bytes
!skull_raft_fix_freeram = $18E6|!addr ; 1 byte
!sprite_scroll_fix_position_freeram = $0DC3|!addr ; 4 bytes
!sprite_scroll_fix_displacement_freeram = $1487|!addr ; 4 bytes
!triangles_fix_freeram = $14BE|!addr ; 1 byte

; Flags
!toggle_lr_scroll_freeram = $7C ; 1 byte
!toggle_statusbar_freeram = $79 ; 1 byte
!toggle_vanilla_turnaround_freeram = $186A|!addr ; 1 byte
!toggle_block_duplication_freeram = $13E7|!addr ; 1 byte

; Large blocks of ram
if read1($00FFD5) == $23
    !objectool_level_flags_freeram = $409400 ; 13 bytes
    !retry_freeram =  $40A400
else
    !objectool_level_flags_freeram = $7FA400 ; 13 bytes
    !retry_freeram = $7FB400
endif