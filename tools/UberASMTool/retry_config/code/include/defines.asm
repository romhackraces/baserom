; Defines for miscellaneous values used by Retry
!retry_type_follow_global      #= $00
!retry_type_prompt_death_song  #= $01
!retry_type_prompt_death_sfx   #= $02
!retry_type_prompt_max         #= !retry_type_prompt_death_sfx
!retry_type_instant_death_sfx  #= $03
!retry_type_instant_death_song #= $04
!retry_type_instant_max        #= !retry_type_instant_death_song
!retry_type_enabled_max        #= !retry_type_instant_max
!retry_type_vanilla            #= $05
!retry_type_min                #= !retry_type_follow_global
!retry_type_max                #= !retry_type_vanilla

!checkpoint_type_vanilla                         #= $00
!checkpoint_type_midway_bar                      #= $01
!checkpoint_type_all_entrance                    #= $02
!checkpoint_type_midway_bar_all_entrance         #= $03
!checkpoint_type_main_midway_entrance            #= $04
!checkpoint_type_midway_bar_main_midway_entrance #= $05
!checkpoint_type_secondary_entrance              #= $06
!checkpoint_type_midway_bar_secondary_entrance   #= $07
!checkpoint_type_min                             #= !checkpoint_type_vanilla
!checkpoint_type_max                             #= !checkpoint_type_midway_bar_secondary_entrance
