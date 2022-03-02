; Position to write the counter to in the status bar.
!counter_status_bar = $0F15|!addr

; YXPCCCT properties of the "DEATHS" word.
; The first number is the palette, the second is the GFX page (0 or 1).
; If you want to change the word itself, look at the table below.
!death_word_props = l3_prop(6,0)

if !status_death_word

pushpc

; Here you can edit which tiles are drawn to the status bar.
; The first value in l3_tile is the tile number.
org $008C89
    dw l3_tile($0D,!death_word_props) ; D
    dw l3_tile($0E,!death_word_props) ; E
    dw l3_tile($0A,!death_word_props) ; A
    dw l3_tile($1D,!death_word_props) ; T
    dw l3_tile($11,!death_word_props) ; H
    dw l3_tile($1C,!death_word_props) ; S

pullpc

elseif read1($008F49) == $5C

pushpc

; Restore the original tilemap.
; Here I assume that people won't turn on the "DEATHS" display without also turning on the death counter display.
org $008C89
    db $30,$28,$31,$28,$32,$28,$33,$28,$34,$28,$FC,$38

pullpc

endif

if !status_death_counter

pushpc

org $008F49
    jml status_death_counter

pullpc

status_death_counter:
    ldx #$04
.tiles_loop:
    lda !ram_death_counter,x : sta !counter_status_bar,x
    dex : bpl .tiles_loop
.hide_loop:
    inx
    lda !ram_death_counter,x : bne .return
    cpx #$04 : beq .return
    lda #$FC : sta !counter_status_bar,x
    bra .hide_loop
.return:
    jml $008F5B|!bank

else

pushpc

; Restore the hijack if settings are changed.
if read1($008F49) == $5C
org $008F49
    lda $0DBE|!addr
    inc
endif

pullpc

endif
