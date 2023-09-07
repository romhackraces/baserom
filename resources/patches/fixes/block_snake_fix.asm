; This patch changes the "Standing on a brown block" flag from a global address to a sprite table, so that different block snakes can be triggered at different times, without them stopping when a new one spawns.
; It also makes $7E1909 a free RAM address (never cleared).
; Note: if you're using the "Eating Block Detection Fix" patch, change "STZ $1909|!addr" in it to "STZ !MoveSnakeFlag,x", and copy the "define_sprite_table" stuff in it too.
; If you're using the block snake disassembly (or sprites based off of it), you'll need to do the same in its code.

if read1($00FFD5) == $23
    sa1rom
    !sa1 = 1
    !dp = $3000
    !addr = $6000
    !bank = $000000
    !sprite_slots = 22
else
    lorom
    !sa1 = 0
    !dp = $0000
    !addr = $0000
    !bank = $800000
    !sprite_slots = 12
endif

macro define_sprite_table(name, addr, addr_sa1)
    if !sa1 == 0
        !<name> = <addr>
    else
        !<name> = <addr_sa1>
    endif
endmacro

; Which sprite table is used for the flag. By default it's the unused $1510.
%define_sprite_table(MoveSnakeFlag, $1510, $750A)

; Other sprite tables used.
%define_sprite_table(sprite_num, $9E, $3200)
%define_sprite_table(sprite_status, $14C8, $3242)

org $0184D8
    sta !MoveSnakeFlag,x

org $0392A9
    lda !MoveSnakeFlag,x

org $0392DD
    lda !MoveSnakeFlag,x

org $00EE7A
    autoclean jsl InitFlag : nop

freecode

InitFlag:
    ; Original code: skip if it's not block 132.
    bne .return
    
    phx
        ; Loop through all sprite slots to find the snake blocks.
        ldx.b #!sprite_slots-1

        .loop:
            ; Skip if the sprite is not alive.
            lda !sprite_status,x : cmp #$08 : bne .next
    
            ; Skip if the sprite is not the block snake.
            lda !sprite_num,x : cmp #$B1 : bne .next
        
            ; Reset the flag, meaning it will start moving.
            stz !MoveSnakeFlag,x

        .next:
            ; Go to the next sprite.
            dex : bpl .loop
    plx

.return:
    rtl
