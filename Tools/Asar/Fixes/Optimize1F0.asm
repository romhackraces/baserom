; Optimize 1F0 patch by Fernap
;
; The idea for this came from a post dug up by LouisDoucet, posted by Morsel, originally noted by MellonPizza (I think).
; The actual implementation is by Fernap.
;
; This reduces the processing time that SMW spends when sprites are sitting on 1F0 (in fact, 1D8-1FF) tiles, mitigating the chance for slowdown.


if read1($00FFD5) == $23
    sa1rom
    !sprite_y_low = $3216
    !sprite_y_high = $3258
    !bank = $000000
else
    lorom
    !sprite_y_low = $D8
    !sprite_y_high = $14D4
    !bank = $800000
endif

org $01939D
    autoclean jml Optimize1F0

freecode

; This moves the sprite up by the amount into the block it is, and then calls the interaction routine a second time,
; rather than moving up one pixel at a time as in the original game
Optimize1F0:
    lda $0c
    and #$0f
    eor #$ff
    clc
    adc !sprite_y_low,x
    sta !sprite_y_low,x
    lda !sprite_y_high,x
    adc #$ff
    sta !sprite_y_high,x
    jml $0192C9|!bank
