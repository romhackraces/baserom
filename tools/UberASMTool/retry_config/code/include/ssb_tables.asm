if !sprite_status_bar

macro _build_status_bar_value(name)
    assert !default_<name>_palette <= $0F,\
        "Error: \!default_<name>_palette is not valid!"
    assert !default_<name>_tile <= $1FF,\
        "Error: \!default_<name>_tile is not valid!"

    if !default_<name>_tile == 0 || !default_<name>_palette == 0
        !default_<name>_value #= 0
    else ; if not(!default_<name>_tile == 0 || !default_<name>_palette == 0)
        !default_<name>_value #= ((!default_<name>_palette)<<12)|(!default_<name>_tile)
    endif ; !default_<name>_tile == 0 || !default_<name>_palette == 0

    assert !default_<name>_value == 0 || !default_<name>_value&$8000 >= $8000,\
        "Error: \!default_<name>_palette is not valid!"

    !default_<name>_value #= !default_<name>_value&$7FFF
endmacro

%_build_status_bar_value(item_box)
%_build_status_bar_value(timer)
%_build_status_bar_value(coin_counter)
%_build_status_bar_value(lives_counter)
%_build_status_bar_value(bonus_stars)
%_build_status_bar_value(death_counter)

assert !default_coin_counter_behavior <= 2,\
    "Error: \!default_coin_counter_behavior is not valid!"
!default_coin_counter_value #= !default_coin_counter_value|(!default_coin_counter_behavior<<9)

item_box:
    %dwn(!default_item_box_value,$200)

timer:
    %dwn(!default_timer_value,$200)

coins:
    %dwn(!default_coin_counter_value,$200)

lives:
    %dwn(!default_lives_counter_value,$200)

bonus_stars:
    %dwn(!default_bonus_stars_value,$200)

death:
    %dwn(!default_death_counter_value,$200)

macro _ssb_config_shared(level, tile, pal, name)
    assert <level> >= 0 && <level> <= $1FF,\
        "Error: %ssb_config_<name> level value needs to be between $000 and $1FF!"
    assert <tile> <= $1FF,\
        "Error: %ssb_config_<name> tile is not valid!"
    assert <pal> <= $0F,\
        "Error: %ssb_config_<name> palette is not valid!"

    if <tile> == 0 || <pal> == 0
        !_value #= 0
    else ; if not(<tile> == 0 || <pal> == 0)
        !_value #= ((<pal>)<<12)|(<tile>)
    endif ; <tile> == 0 || <pal> == 0

    assert !_value == 0 || !_value&$8000 >= $8000,
        "Error: %ssb_config_<name> palette is not valid!"
    
    !_value #= !_value&$7FFF

    pushpc

    org ssb_tables_<name>+(<level>*2)
        dw !_value

    pullpc

    undef "_value"
endmacro

macro ssb_config_item_box(level, tile, pal)
    %_ssb_config_shared(<level>, <tile>, <pal>, item_box)
endmacro

macro ssb_config_timer(level, tile, pal)
    %_ssb_config_shared(<level>, <tile>, <pal>, timer)
endmacro

macro ssb_config_coins(level, tile, pal, beha)
    assert <beha> <= 2,\
        "Error: %ssb_config_coins beha value is not valid!"

    %_ssb_config_shared(<level>, <tile>, <pal>, coins)

    if <tile> != 0 && <pal> != 0
        pushpc
            org ssb_tables_coins+(<level>*2)
                dw ((((<pal>)<<12)|(<tile>))&$7FFF)|((<beha>)<<9)
        pullpc
    endif ; <tile> != 0 && <pal> != 0
endmacro

macro ssb_config_lives(level, tile, pal)
    %_ssb_config_shared(<level>, <tile>, <pal>, lives)
endmacro

macro ssb_config_bonus_stars(level, tile, pal)
    %_ssb_config_shared(<level>, <tile>, <pal>, bonus_stars)
endmacro

macro ssb_config_death(level, tile, pal)
    %_ssb_config_shared(<level>, <tile>, <pal>, death)
endmacro

macro ssb_config(level, item_box_tile, item_box_pal, timer_tile, timer_pal, coins_tile, coins_pal, coins_beha, lives_tile, lives_pal, bonus_stars_tile, bonus_stars_pal, death_tile, death_pal)
    %ssb_config_item_box(<level>, <item_box_tile>, <item_box_pal>)
    %ssb_config_timer(<level>, <timer_tile>, <timer_pal>)
    %ssb_config_coins(<level>, <coins_tile>, <coins_pal>, <coins_beha>)
    %ssb_config_lives(<level>, <lives_tile>, <lives_pal>)
    %ssb_config_bonus_stars(<level>, <bonus_stars_tile>, <bonus_stars_pal>)
    %ssb_config_death(<level>, <death_tile>, <death_pal>)
endmacro

macro ssb_hide_item_box(level)
    %ssb_config_item_box(<level>, 0, 0)
endmacro

macro ssb_hide_timer(level)
    %ssb_config_timer(<level>, 0, 0)
endmacro

macro ssb_hide_coins(level)
    %ssb_config_coins(<level>, 0, 0, 0)
endmacro

macro ssb_hide_lives(level)
    %ssb_config_lives(<level>, 0, 0)
endmacro

macro ssb_hide_bonus_stars(level)
    %ssb_config_bonus_stars(<level>, 0, 0)
endmacro

macro ssb_hide_death(level)
    %ssb_config_death(<level>, 0, 0)
endmacro

macro ssb_hide(level)
    %ssb_config(<level>, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
endmacro

if not(!use_legacy_tables)

; Load the sprite status bar config for the current level
load:
    phx
    php
    rep #$30
    lda $010B|!addr : asl : tax
    lda.l item_box,x    : sta !ram_status_bar_item_box_tile
    lda.l timer,x       : sta !ram_status_bar_timer_tile
    lda.l coins,x       : sta !ram_status_bar_coins_tile
    lda.l lives,x       : sta !ram_status_bar_lives_tile
    lda.l bonus_stars,x : sta !ram_status_bar_bonus_stars_tile
    lda.l death,x       : sta !ram_status_bar_death_tile
    plp
    plx
    rts

else ; if !use_legacy_tables

; Load the default sprite status bar config
load:
    php
    rep #$20
    lda.w #!default_item_box_value      : sta !ram_status_bar_item_box_tile
    lda.w #!default_timer_value         : sta !ram_status_bar_timer_tile
    lda.w #!default_coin_counter_value  : sta !ram_status_bar_coins_tile
    lda.w #!default_lives_counter_value : sta !ram_status_bar_lives_tile
    lda.w #!default_bonus_stars_value   : sta !ram_status_bar_bonus_stars_tile
    lda.w #!default_death_counter_value : sta !ram_status_bar_death_tile
    plp
    rts

endif ; not(!use_legacy_tables)

else ; if not(!sprite_status_bar)

macro ssb_config_item_box(level, tile, pal)
endmacro

macro ssb_config_timer(level, tile, pal)
endmacro

macro ssb_config_coins(level, tile, pal, beha)
endmacro

macro ssb_config_lives(level, tile, pal)
endmacro

macro ssb_config_bonus_stars(level, tile, pal)
endmacro

macro ssb_config_death(level, tile, pal)
endmacro

macro ssb_config(level, item_box_tile, item_box_pal, timer_tile, timer_pal, coins_tile, coins_pal, coins_beha, lives_tile, lives_pal, bonus_stars_tile, bonus_stars_pal, death_tile, death_pal)
endmacro

macro ssb_hide_item_box(level)
endmacro

macro ssb_hide_timer(level)
endmacro

macro ssb_hide_coins(level)
endmacro

macro ssb_hide_lives(level)
endmacro

macro ssb_hide_bonus_stars(level)
endmacro

macro ssb_hide_death(level)
endmacro

macro ssb_hide(level)
endmacro

load:
    rts

endif ; !sprite_status_bar
