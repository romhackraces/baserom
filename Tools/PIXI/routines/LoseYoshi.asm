;; LoseYoshi:
;;    Taken from GIEPY's routines.
;;    If the player is riding Yoshi, this routine will make him run away as if
;;    hit by an enemy.
;; No input
;; Preserves:
;;    A (8-bit)
;;    X/Y (8-bit)

.LoseYoshi
    PHA
    LDA $187A|!addr                ; If the player is not on Yoshi, return.
    BEQ .noYoshi
    PHX
    PHY
    LDX $18E2|!addr                ; Load index to Yoshi in the sprite tables.
    LDA #$10                        ; Set timer to disable damage to Yoshi.
    STA !sprite_misc_163e-1,x
    LDA #$03                        ; Play sound effects.
    STA $1DFA|!addr
    LDA #$13
    STA $1DFC|!addr
    LDA #$02                        ; Update phase pointer to "running".
    STA !sprite_misc_c2-1,x
    STZ $187A|!addr                ; Clear Yoshi flags.
    STZ $0DC1|!addr
    LDA #$C0                        ; Set player speed.
    STA $7D
    STZ $7B
    LDY !sprite_misc_157c-1,x       ; Set X speed of Yoshi based on his facing.
    PHX : TYX
    LDA $02A4B3|!bank,x
    PLX
    STA !sprite_speed_x-1,x
    STZ !sprite_misc_1594-1,x       ; Cancel tounge animations.
    STZ !sprite_misc_151c-1,x
    STZ $18AE|!addr
    LDA #$30                        ; Give invulnerability to the player.
    STA $1497|!addr
    PLY
    PLX
.noYoshi
    PLA
    RTL