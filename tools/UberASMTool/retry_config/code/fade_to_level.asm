; Gamemode 0F

init:
    ; If respawning or doing a level transition, skip.
    lda $141A|!addr : bne .transition

if !enter_level_sfx != $00
    ; If not loading the level from a No Yoshi intro, play the SFX.
    lda $71 : cmp #$0A : beq +
    lda.b #!enter_level_sfx : sta !enter_level_sfx_addr|!addr
    lda.b #!enter_level_delay : sta $0DB1|!addr
+
endif ; !enter_level_sfx != $00

    bra main

.transition:
    ; Check if we're respawning from Retry.
    lda !ram_is_respawning : bne main

.not_respawning:
    ; Backup the current entrance value for later.
    ; (if warping to Yoshi Wings, change the entrance to the correct level
    ; and set the Yoshi Wings flag in the checkpoint RAM).
    lda $1B95|!addr : beq +
    %jsl_to_rts_db($05DBAC)
    lda $19D8|!addr,x : and #$FE : ora $010C|!addr : ora #$80
    bra ++
+   jsr shared_get_screen_number
    lda $19D8|!addr,x
++  sta !ram_door_dest+1
    lda $19B8|!addr,x : sta !ram_door_dest+0 

main:
if !fast_transitions
    ; Reset the mosaic timer.
    stz $0DB1|!addr
endif ; !fast_transitions
    
    ; If in the door animation, call the extra routine.
    lda $71 : cmp #$0D : bne .return
    php
    jsl extra_door_animation
    plp

.return:
    rtl
