; insert act as 25
db $42
JMP Mario : JMP Mario : JMP Mario : JMP Return : JMP Return : JMP Return : JMP Return
JMP Mario : JMP Mario : JMP Mario

; Options, set to 1 to enable, or 0 to disable
!ClearItemBox       = 1         ; clear item box when removing power-up
!ClearPBalloon      = 1         ; clear p-balloon state
!ClearFlightState   = 1         ; clear flight state (recommended to keep this on)

; Sound Effect
!PlaySoundEffect    = 1         ; play a sound effect on power-down

!SFXNum  = $0F
!SFXBank = $1DF9|!addr

; don't change
!ScratchRAM = $0A

Mario:
    ; set scratch ram to prevent repeated SFX plays
    LDA #$01 : STA !ScratchRAM

    ; reset powerup state
    LDA $19 : BEQ +             ; check if small mario
    STZ $19
    STZ !ScratchRAM             ; clear scratch
    +

    ; clear player's itembox
if !ClearItemBox
    LDA $0DC2 : BEQ +           ; check if anything in item box
    STZ $0DC2|!addr             ; empty item box
    STZ !ScratchRAM             ; clear scratch
    +
endif

    ; clear flight state
if !ClearFlightState
    LDA $1407|!addr : BEQ +     ; check if in flight
    STZ $1407|!addr             ; reset cape phase
    LDA $13ED|!addr             ;\
    AND #%01111111              ;| clear cape slide pose
    STA $13ED|!addr             ;/
    STZ !ScratchRAM
    +
endif

    ; clear p-balloon state
if !ClearPBalloon
    LDA $13F3|!addr : BEQ +     ; check if in balloon
    LDA #$01                    ;\ set p-balloon timer to 1 frame (can't do zero here)
    STA $1891|!addr             ;/
    STZ $13F3|!addr             ; make sure not in balloon
    STZ !ScratchRAM
    +
endif

    ; play sound effect
if !PlaySoundEffect
    LDA !ScratchRAM : BNE .no_sfx
    LDA #!SFXNum : STA !SFXBank
.no_sfx
endif

Return:
    RTL

print "Makes Mario small and optionally clears Item Box, removes P-balloon, and flight states."