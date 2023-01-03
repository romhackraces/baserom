; This patch frees up tile 69 in SP1.
; It makes one frame of the splash tile animation use 3 8x8 tiles instead of 1 16x16 tile.
; It requires Extended NMSTL patch to work.

if read1($00FFD5) == $23
    sa1rom
    !sa1  = 1
    !dp   = $3000
    !addr = $6000
    !bank = $000000
else
    lorom
    !sa1  = 0
    !dp   = $0000
    !addr = $0000
    !bank = $800000
endif

; The 3 non-empty 8x8 tiles in tile 68
!tile1 = $68
!tile2 = $78
!tile3 = $79

org $028DCF
    autoclean jml water_splash

freecode

water_splash:
    ; Get the OAM index back
    tya : asl #2 : tay

    ; If tile 68 was drawn, use 3 8x8 tiles instead
    lda $0202|!addr,y : cmp.b #!tile1 : bne +

    ; Set the OAM X positions
    lda $0200|!addr,y
    sta $0204|!addr,y
    clc : adc #$08 : sta $0208|!addr,y

    ; Set the OAM Y positions
    lda $0201|!addr,y : clc : adc #$08
    sta $0205|!addr,y : sta $0209|!addr,y

    ; Set the OAM tile numbers
    lda.b #!tile2 : sta $0206|!addr,y
    lda.b #!tile3 : sta $020A|!addr,y

    ; Set the OAM properties
    lda $0203|!addr,y
    sta $0207|!addr,y : sta $020B|!addr,y

    ; Set the OAM sizes
    tya : lsr #2 : tay
    lda #$00
    sta $0420|!addr,y : sta $0421|!addr,y : sta $0422|!addr,y
+
    ; Restore original code
    lda $9D : bne +
    jml $028DD3|!bank
+   jml $028DD6|!bank
