; act as 25

!smoke_num = $69

db $42

jmp ++ : jmp ++ : jmp ++
jmp + : jmp + : jmp ++ : jmp ++
jmp ++ : jmp ++ : jmp ++

+   ; Spawn the smoke sprite
    lda.b #!smoke_num
    clc
    phx
    %spawn_sprite()
    plx

    ; Kill the original sprite
    stz !14C8,x

    ; Move the new sprite where the old one was
    bcs ++
    sta $04
    %move_spawn_to_sprite()

    ; If the block is on Layer 2, fix the sprite position
    lda $185E|!addr : beq ++
    phx
    ldx $04
    lda !sprite_x_low,x : sec : sbc $26 : sta !sprite_x_low,x
    lda !sprite_x_high,x : sbc $27 : sta !sprite_x_high,x
    lda !sprite_y_low,x : sec : sbc $28 : sta !sprite_y_low,x
    lda !sprite_y_high,x : sbc $29 : sta !sprite_y_high,x
    plx
++  rtl

print "A block that kills sprites."
