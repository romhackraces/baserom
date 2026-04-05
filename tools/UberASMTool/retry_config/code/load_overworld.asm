; Gamemode 0C

init:
    ; Apply counterbreak
    jsr counterbreak_from_ow

; Reset the current level's checkpoint if the level was beaten.
.reset_checkpoint:
    ; Skip if the level wasn't just beaten.
    lda $0DD5|!addr : beq ..skip
                      bmi ..skip

    ; Remove the checkpoint for the current level.
    jsr shared_reset_checkpoint

..skip:
    rtl
