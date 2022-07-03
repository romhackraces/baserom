; Gamemode 0D

; Tile used for empty space. By default it's the border "filled" tile.
!empty_tile  = $FE
!empty_props = l3_prop(6,0)

init:

; Draw the death counter in the Overworld.
.death_counter:
if !ow_death_counter
    ; Set the DBR to $7F to use the stripe table with ,y.
    %set_dbr(!stripe_table)

    ; Write the stripe image header.
    rep #$30
    ldy.w !stripe_index
    lda.w #str_header1(!ow_death_counter_x_pos,!ow_death_counter_y_pos)
    sta.w !stripe_table,y
    iny #2
    lda.w #str_header2((5*2)-1,0)
    sta.w !stripe_table,y
    iny #2

    ; Loop through all digits in the death counter
    ; and write them to the stripe image table.
    ldx #$0000
    sep #$20
    stz $00
    
..stripe_loop:
    ; If the current digit is zero, turn it into an empty tile,
    ; but only if no non-zero digit has been reached yet.
    lda.l !ram_death_counter,x : bne ...normal
    cpx.w #$0005-1 : beq ...normal
    lsr $00 : bcs ...normal
    lda.b #!empty_tile : sta.w !stripe_table,y
    lda.b #!empty_props
    bra +

...normal:
    clc : adc.b #!ow_digit_0 : sta.w !stripe_table,y
    lda #$01 : sta $00
    lda.b #!ow_death_counter_props
+   sta.w !stripe_table+1,y

...next:
    iny #2
    inx
    cpx #$0005 : bcc ..stripe_loop

...end:
    ; Write the terminator and update the stripe index.
    lda #$FF : sta.w !stripe_table,y
    sty.w !stripe_index
    sep #$10
    
    plb
endif

    rtl
