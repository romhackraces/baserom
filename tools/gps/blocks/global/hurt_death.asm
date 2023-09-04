;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; spikes / death block for kaizo / pit hacks
; has the same hitbox as vanilla munchers / castle spikes
; version 1.0.1 by dacin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!instant_death = 1
; 0 = hurt like munchers or castle spikes
; 1 = instant death

!yoshi_can_walk_on_top = 0
; 0 = top edge of block kills the player on yoshi
; 1 = the player can walk on top if on yoshi

!solid_for_sprites = 1
; -1 = sprites can pass through, can be overwritten by vines or coin snakes
;  0 = sprites can pass through, stops vines and coin snakes
;  1 = solid for sprites

!allow_wall_run = 0
; 0 = kills the player when wall running on it
; 1 = lets the player wall run (like munchers / spikes in vanilla)



db $37
JMP HurtOrKill : JMP MarioAbove : JMP MarioSide
JMP SpriteStuff : JMP SpriteStuff : JMP SpriteStuff : JMP SpriteStuff
JMP MarioCorner : JMP HurtOrKill : JMP MarioHead
JMP WallRun : JMP WallRun


MarioAbove:
MarioCorner:
    if !yoshi_can_walk_on_top = 1
        LDA $187A|!addr		    ; \ if the player is riding Yoshi
        BNE MarioAboveReturn    ; / let him live
    endif

    LDA $7D         ; \ only hurt the player
    BPL HurtOrKill  ; / if he's moving downward

    MarioAboveReturn:
    RTL


SidePixelTable:
    db $02,$0D

MarioHead:
MarioSide:
    PHY                     ; > y is used for act as -> preserve it
    LDY $93                 ; \
    LDA $94                 ; | use proper muncher hitbox for the side
    AND.B #$0F              ; | so the block doesn't stick out by 1 pixel
    CMP.W SidePixelTable,Y  ; /
    BNE HurtOrKillPopY
    PLY
    RTL


WallRun:
    if !allow_wall_run = 1
        RTL
    else
        JMP HurtOrKill
    endif


SpriteStuff:
    if !solid_for_sprites = 1
        LDA #$30				; \
        STA $1693|!addr		    ; | act as tile 130 (cement block)
        LDY #$01				; /
    elseif  !solid_for_sprites = 0
        LDA #$48				; \
        STA $1693|!addr			; | act as tile 48 (always turning block)
        LDY #$00				; /
    else
        LDA #$25				; \
        STA $1693|!addr			; | act as tile 25 (air)
        LDY #$00				; /
    endif
    RTL


    if !instant_death = 0
HurtOrKill:
        PHY
HurtOrKillPopY:
        JSL $00F5B7|!bank ; > hurt the player (might overwrite Y).
        PLY
    else
HurtOrKillPopY:
        PLY
HurtOrKill:
        JSL $00F606|!bank ; > kill the player.
    endif
    RTL


macro select_text(name, variable, option_0, option_1)
if !<variable> == 0
    !<name> = "<option_0>"
else
    !<name> = "<option_1>"
endif
endmacro
%select_text(text_1, instant_death, "hurts", "kills")
%select_text(text_2, yoshi_can_walk_on_top, "(even on yoshi)", "(unless he's on yoshi)")
%select_text(text_3, solid_for_sprites, "passable", "solid")
%select_text(text_4, allow_wall_run, "!text_1 on", "supports")

print "Block that !text_1 the player !text_2, is !text_3 for sprites and !text_4 wall running."
