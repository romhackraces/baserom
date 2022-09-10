; Gamemode 0F

init:
    ; If respawning or doing a level transition, skip.
    lda $141A|!addr : bne .transition

if !pipe_entrance_freeze == 2
    ; Reset the $9D backup.
    lda #$00 : sta !ram_9D_backup
endif
    bra main

.transition:
    ; Check if we're respawning from Retry.
    lda !ram_is_respawning : beq .not_respawning

.respawning:
if !pipe_entrance_freeze == 2
    ; If yes, store the $9D backup to $9D.
    ; This makes pipe entrances consistent in how sprites behave during them.
    lda !ram_9D_backup : sta $9D
endif
    bra main

.not_respawning:
if !pipe_entrance_freeze == 2
    ; If it's a normal transition, backup $9D...
    lda $9D : sta !ram_9D_backup
endif

    ; ...and backup the current entrance value for later.
    jsr shared_get_screen_number
    lda $19B8|!addr,x : sta !ram_door_dest
    lda $19D8|!addr,x : sta !ram_door_dest+1

main:
if !fast_transitions
    ; Reset the mosaic timer.
    stz $0DB1|!addr
endif
    
    ; If in the door animation, call the extra routine.
    lda $71 : cmp #$0D : bne .return
    phb : phk : plb
    php
    jsr extra_door_animation
    plp
    plb

.return:
    rtl
