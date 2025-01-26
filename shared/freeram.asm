includeonce

; Shared FreeRAM Definitions

; Large blocks of ram
if read1($00FFD5) == $23
    !objectool_level_flags_bank             = $409400 ; 13 bytes used
    !toggles_freeram_bank                   = $409410 ; 8 bytes used
    !scroll_pipes_freeram_bank              = $409420 ; 5 bytes used
    !scroll_fix_freeram_bank                = $409430 ; 8 bytes used
    ;!retry_freeram                          = $40A400 ; 241 (+ 4 * # of midways) bytes used
else
    !objectool_level_flags_bank             = $7FA400 ; 13 bytes used
    !toggles_freeram_bank                   = $7FA410 ; 8 bytes used
    !scroll_pipes_freeram_bank              = $7FA420 ; 5 bytes used
    !scroll_fix_freeram_bank                = $7FA430 ; 8 bytes used
    ;!retry_freeram                          = $7FB400 ; 241 (+ 4 * # of midways) bytes used
endif

; If you're looking to update or add freeram definitions do check the RAM Map first:
; https://www.smwcentral.net/?p=memorymap&game=smw&region[]=ram&type=Empty

; Resource FreeRAM (sorted by used address)
!block_duplication_freeram                  = $13E6|!addr ; 1 byte
!triangles_fix_freeram                      = $14BE|!addr ; 1 byte
!auto_save_tile_check_freeram               = $14C1|!addr ; 1 byte
!goal_point_reward_fix_freeram              = $15E8|!addr ; 1 byte
!extended_nstl_freeram                      = $1869|!addr ; 2 bytes
!skull_raft_fix_freeram                     = $18E6|!addr ; 1 byte
!capespin_direction_freeram                 = $1923|!addr ; 1 byte
!double_hit_fix_freeram                     = $1DFD|!addr ; 1 byte

; addresses used by some resources to toggle their behaviour
; these all use a freed bank of ram addresses defined above
!toggle_lr_scroll_freeram                   = !toggles_freeram_bank   ; 1 byte
!toggle_statusbar_freeram                   = !toggles_freeram_bank+1 ; 1 byte
!toggle_spinjump_fireball_freeram           = !toggles_freeram_bank+2 ; 1 byte
!toggle_block_duplication_freeram           = !toggles_freeram_bank+3 ; 1 byte
!toggle_capespin_direction_freeram          = !toggles_freeram_bank+4 ; 1 byte
!toggle_springboard_fixes_freeram           = !toggles_freeram_bank+5 ; 1 byte
!toggle_rope_glitch_freeram                 = !toggles_freeram_bank+6 ; 1 byte