if read1($00FFD5) == $23
    sa1rom
    !sa1 = 1
    !addr = $6000
    !bank = $000000
else
    lorom
    !sa1 = 0
    !addr = $0000
    !bank = $800000
endif

; 1 byte of freeram
!freeram = $60

; Don't edit from here
if read1($02A03B) == $AC
    !ext_nmstl = 1
else
    !ext_nmstl = 0
endif

org $00FEA8
    autoclean jml shoot_fireball

org $00FAD6
    autoclean jml clear_extended

if !ext_nmstl == 0

; If ExtNMSTL isn't installed, we need to take care of OAM ourselves
org $02A03B
    autoclean jml get_oam_slot

else

; Restore the JSR opcode in case ExtNMSTL was applied after this patch, to prevent a game crash
; In any case, applying this one after ExtNMSTL will make them work together
org $02A03E
    db $20

endif

freecode

shoot_fireball:
    ldx #$09
    stz $00
    stz $01
.loop:
    lda $170B|!addr,x : beq ..empty
    cmp #$05 : bne ..next
    inc $00
    bra ..next
..empty:
    stx $01
..next:
    dex : bpl .loop
..end:
    lda $00 : cmp !freeram : bcs .return
    ldx $01
.found:
    jml $00FEB5|!bank
.return:
    jml $00FEB4|!bank

clear_extended:
.loop:
    lda $170B|!addr,y : cmp #$05 : beq ..next
    lda #$00 : sta $170B|!addr,y
..next:
    dey : bpl .loop
..end:
    jml $00FADE|!bank

if !ext_nmstl == 0
get_oam_slot:
    lda.l .oam,x : tay
    pea.w $02A041-1
    jml $02A1A7|!bank

.oam:
    db $90,$94,$98,$9C,$A0,$A4,$A8,$AC,$F8,$FC

endif
