; How fast the screen moves (px/frame) when catching up to the new (far) position
!hscroll_catchup_speed = $0006

if read1($00FFD5) == $23
    sa1rom
    !sa1  = 1
    !addr = $6000
    !dp   = $3000
    !bank = $000000
else
    lorom
    !sa1  = 0
    !addr = $0000
    !dp   = $0000
    !bank = $800000
endif

org $00F8B0
    autoclean jsl hscroll_fix
    ldx $13FF|!addr

freecode

hscroll_fix:
    ; Prevent messing up the starting level position
    lda $0100|!addr : and #$00FF
    cmp #$0003 : beq .return
    cmp #$0011 : beq .return

    ; Clamp the hscroll speed
    lda $02 : bmi .left
.right:
    cmp.w #!hscroll_catchup_speed : bcc .return
    lda.w #!hscroll_catchup_speed : sta $02
    rtl
.left:
    cmp.w #-!hscroll_catchup_speed+1 : bcs .return
    lda.w #-!hscroll_catchup_speed : sta $02
.return:
    rtl
