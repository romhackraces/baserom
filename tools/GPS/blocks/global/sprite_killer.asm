; insert with act as 25
db $42

JMP Return : JMP Return : JMP Return
JMP Sprite : JMP Sprite : JMP Return : JMP Return
JMP Return : JMP Return : JMP Return

; Smoke settings
!DrawSmoke = 1                 ; set to 1 to draw a puff of smoke
!SmokeNum = $12                ; Smoke sprite number from other/puff_of_smoke.asm patch

; Sound effect options
!PlaySoundEffect = 1            ; set to 1 to play a sound effect on sprite kill
!SFXNum  = $25                  ; sound effect number
!SFXBank = $1DFC|!addr          ; sound effect bank ($1DF9, $1DFC)

Sprite:

if !PlaySoundEffect
    ; Play sound effect
    LDA #!SFXNum : STA !SFXBank
endif

if !DrawSmoke
    ; Spawn the smoke sprite
    lda.b #!SmokeNum
    clc
    phx
    %spawn_sprite()
    plx
endif

    ; Kill the original sprite
    stz !14C8,x

if !DrawSmoke
    ; Move the smoke sprite where the old one was
    bcs Return
    sta $04
    %move_spawn_to_sprite()

    ; If the block is on Layer 2, fix the sprite position
    lda $185E|!addr : beq Return
    phx
    ldx $04
    lda !sprite_x_low,x : sec : sbc $26 : sta !sprite_x_low,x
    lda !sprite_x_high,x : sbc $27 : sta !sprite_x_high,x
    lda !sprite_y_low,x : sec : sbc $28 : sta !sprite_y_low,x
    lda !sprite_y_high,x : sbc $29 : sta !sprite_y_high,x
    plx
endif

Return:
    rtl

print "Kills sprites. Does not work for sprites that do not have object interaction."
