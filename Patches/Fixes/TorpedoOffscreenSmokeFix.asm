if read1($00FFD5) == $23
    sa1rom
    !sa1 = 1
    !dp = $3000
    !addr = $6000
    !bank = $000000
else
    lorom
    !sa1 = 0
    !dp = $0000
    !addr = $0000
    !bank = $800000
endif

macro define_sprite_table(name, addr, addr_sa1)
    if !sa1 == 0
        !<name> = <addr>
    else
        !<name> = <addr_sa1>
    endif
endmacro

%define_sprite_table(sprite_off_screen_vert, $186C, $7642)

org $02B98B
    autoclean jml CheckOffscreen

freecode

CheckOffscreen:
    sbc $1B
    bne .skip
    lda !sprite_off_screen_vert,x
    beq .spawn
.skip
    jml $02B9A3|!bank
.spawn
    jml $02B98F|!bank
