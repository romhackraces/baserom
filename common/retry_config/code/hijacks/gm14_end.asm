;================================================================================
; This file handles some processes that need to run at the very end of the main game loop:
; - Death routine: if the player died on this frame, it needs to prevent the
;   death song from playing when applicable, before the music engine is aware
;   of it. It also handles incrementing the death counter-
; - Prompt OAM: if the prompt is being show, it needs to draw it on the
;   screen. You can't draw sprite tiles in gamemode 14 codes, as $7F8000
;   is called shortly after their main code, so we do it here. Being at
;   the end of the loop also allows it to not overwrite sprite tiles used
;   by other elements in the level.
; - Set checkpoint: if a checkpoint has been gotten on this frame (signaled
;   by the !ram_set_checkpoint handle), it needs to actually set it in Retry's
;   RAM. This could be done in gm14 as well, at the start of the next frame,
;   but better to do it as early as possible just to be safe :P
;================================================================================

pushpc

; Hijack the end of game mode 14.
org $00A2EA
    jml gm14_end

pullpc

;================================================================================
; Write a small identifier string in ROM.
; - You can check if a ROM has this patch by doing "if read4(read3($00A2EB)-33) == $72746552"
; - You can find the 3 version number digits at read1(read3($00A2EB)-3), read1(read3($00A2EB)-2) and read1(read3($00A2EB)-1).
;================================================================================
db "Retry patch by KevinM "
db "Version ",!version_a,!version_b,!version_c

gm14_end:
    ; Preserve X and Y and set DBR.
    phx : phy
    phb : phk : plb

    ; Call the custom gm14_end routine.
    php : phb
    jsr extra_gm14_end
    plb : plp

    ; Check if we have to set the checkpoint.
    rep #$20
    lda !ram_set_checkpoint : cmp #$FFFF
    sep #$20
    beq .no_checkpoint
    jsr set_checkpoint

.no_checkpoint:
    ; If Mario is dying, call the death routine.
    lda $71 : cmp #$09 : bne .no_death
    jsr death_routine

.no_death:
    ; Check if it's time to draw the tiles.
    lda !ram_prompt_phase : cmp #$02 : beq .draw_prompt
                                       bcc .return
    ; In some cases it's needed to remove the prompt tiles from OAM after the option is chosen.
    jsr erase_tiles
    bra .return
.draw_prompt:
    jsr prompt_oam

.return:
    ; Restore DBR, X and Y.
    plb : ply : plx

    ; Restore original code.
    pla : sta $1D : pla
    jml $00A2EE|!bank

; Import all auxiliary routines called by this file.
incsrc "gm14_end/death_routine.asm"
incsrc "gm14_end/prompt_oam.asm"
incsrc "gm14_end/set_checkpoint.asm"
