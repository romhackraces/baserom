if read1($00FFD5) == $23
    sa1rom
    !sa1  = 1
    !dp   = $3000
    !addr = $6000
    !bank = $000000
    !14C8 = $3242
    !1656 = $75D0
else
    lorom
    !sa1  = 0
    !dp   = $0000
    !addr = $0000
    !bank = $800000
    !14C8 = $14C8
    !1656 = $1656
endif

macro set_167A_bit0(id)
    org $07F4C7+<id>
        db read1($07F4C7+<id>)|$01
endmacro

macro skip_if_dead(ok_addr,ret_addr)
    lda $9D : bne ?return
    lda !14C8,x : cmp #$08 : bne ?return
?ok:
    jml <ok_addr>|!bank
?return:
    jml <ret_addr>|!bank
endmacro

; Bob-Omb
; In this case we set it to disappear in a cloud of smoke, but only when exploding
org $028095
    autoclean jml bobomb

; Bowser's Big Balls
%set_167A_bit0($A1)

org $03B166
    autoclean jml bowser_ball

; Iggy's Balls
%set_167A_bit0($A7)

org $01FA7D
    autoclean jml iggy_ball

; Blarggs
; We make it disappear in a cloud of smoke, since Blarggs look weird outside of lava
org $07F26C+$A8
    db read1($07F26C+$A8)|$80

; Fishin' Boo
%set_167A_bit0($AE)

org $039068
    autoclean jml fishin_boo

; Falling Spike
%set_167A_bit0($B2)

org $039237
    autoclean jml falling_spike

; Bowser Statue Fireball
%set_167A_bit0($B3)

org $038EEF
    autoclean jml bowser_statue_fireball

; Grinder (not line-guided)
; Code already checks for alive state
%set_167A_bit0($B4)

; Reflecting Fireball
; Code already checks for alive state
%set_167A_bit0($B6)

; Bowser Statue
%set_167A_bit0($BC)

org $038A3F
    autoclean jml bowser_statue

freedata

bobomb:
    lda !1656,x : ora #$80 : sta !1656,x
    lda $9D : bne .return
.ok:
    jml $028099|!bank
.return:
    jml $02809C|!bank

bowser_ball:
    %skip_if_dead($03B16A,$03B1D4)

iggy_ball:
    %skip_if_dead($01FA81,$01FAB3)

fishin_boo:
    %skip_if_dead($03906C,$0390EA)

falling_spike:
    lda !14C8,x : cmp #$08 : bne .return
    lda $9D : bne .return_clear_speed
.ok:
    jml $03923B|!bank
.return:
    jml $03926E|!bank
.return_clear_speed:
    jml $03926C|!bank

bowser_statue_fireball:
    %skip_if_dead($038EF3,$038F06)

bowser_statue:
    %skip_if_dead($038A43,$038A68)
