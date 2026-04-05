; Routines related to the retry prompt box and menu.

;===============================================================================
; handle_menu routine
;===============================================================================
handle_menu:
    jsr handle_cursor

    ; If no option was selected, return.
    cpy #$FF : beq .skip

    ; Signal to update window HDMA next frame
    lda #$80 : sta !ram_update_window

    ; Now we need to disable window 2
if !prompt_type == 0
    lda #$88
else ; if not(!prompt_type == 0)
    lda #$CC
endif ; !prompt_type == 0
    trb $41 : trb $42

    ; Check if we have to retry or exit.
    cpy #$00 : beq .retry

.exit:
    ; Call the custom exit routine.
    phy : php : phb
    jsl extra_prompt_exit
    plb : plp : ply

    ; Set prompt phase to "shrinking with exit selected".
    lda !ram_prompt_phase : clc : adc #$03 : sta !ram_prompt_phase

    ;lda !ram_hurry_up : bne ..return
    
    ; Play the correct death song and set Exit animation time.
if !exit_animation == 2
    lda.b #!death_time : sta $1496|!addr
endif ; !exit_animation == 2
    
    ; Handle exit music differently if AMK is inserted or not.
    lda.l !rom_amk_byte : cmp #$5C : beq ..amk

..no_amk:
    lda #$FF : sta $0DDA|!addr
    bra ..common

..amk:
if !death_jingle_alt != $FF
if !exit_animation == 0
    lda !ram_hurry_up : beq +
endif ; !exit_animation == 0
    lda.b #!death_jingle_alt : sta $1DFB|!addr
+   rts
endif ; !death_jingle_alt != $FF

..common:
if !exit_animation == 0
    lda !ram_hurry_up : beq .skip
endif ; !exit_animation == 0
    lda.l !rom_death_song : sta $1DFB|!addr
    rts

.retry:
    ; Set prompt phase to "shrinking with retry selected".
    lda !ram_prompt_phase : inc : sta !ram_prompt_phase

.skip:
    rts

;===============================================================================
; handle_cursor routine
;
; Handles the cursor frame counter and checks for player input
; (to move the cursor or select an option).
; Return the selected option in Y ($FF if none was selected).
;===============================================================================
handle_cursor:
    ; Increase the cursor frame counter.
    inc $1B91|!addr

    ; Initialize the number of options.
    ldy #$01
    lda !ram_disable_prompt_exit : bne +
    iny
+   sty $8A
    
if !dim_screen
    ; Fade the brightness.
    lda $0DAE|!addr : and #$F0 : sta $00
    lda $0DAE|!addr : and #$0F : cmp.b #!brightness+1 : bcc +
    dec : ora $00 : sta $0DAE|!addr
+
endif ; !dim_screen
    
    ; If the exit button is pressed, go to the exiting prompt phase.
    lda !exit_button_address : and.b #!exit_button : beq +
    lda #$01 : sta $1B92|!addr
    bra .selected
+
    ; If B, Start or A are not pressed, skip.
    lda $16 : and #$90 : bne .selected
    lda $18 : bpl .not_selected

.selected:
    ; Otherwise, play the SFX and return the result.
if !option_sfx != $00
    lda.b #!option_sfx : sta !option_sfx_addr|!addr
endif ; !option_sfx != $00
    ldy $1B92|!addr
    stz $1B92|!addr

if !dim_screen
    ; Also, reset the screen brightness to max.
    lda $0DAE|!addr : and #$F0 : ora #$0F : sta $0DAE|!addr
endif ; !dim_screen
    rts

.not_selected:
    ; Mark result as "not selected".
    ldy #$FF

    ; If there's less than 2 options, return (can't move the cursor).
    lda $8A : cmp #$02 : bcc ..return

    ; If the prompt cooldown is active, tick it and return.
    lda !ram_update_window : beq +
    dec : sta !ram_update_window
    rts
+
    ; If Select or a direction is not pressed, return.
    lda $16 : and #$20 : lsr #3
    ora $16 : and #$0C : lsr #2
    ora $16 : and #$03 : beq ..return

    ; Load the index to the cursor_speed table.
    tax

    ; Otherwise, play the cursor SFX.
if !cursor_sfx != $00
    lda.b #!cursor_sfx : sta !cursor_sfx_addr|!addr
endif ; !cursor_sfx != $00

    ; Reset the cursor frame counter.
    stz $1B91|!addr

    ; Update the cursor position, taking into account the wraparound.
    lda $1B92|!addr : adc.l .cursor_speed-1,x : bpl +
    lda $8A : dec
+   cmp $8A : bcc ++
    lda #$00
++  sta $1B92|!addr

..return:
    rts

; Distance to move the cursor when pressing down/right/select, up/left, and either of those.
.cursor_speed:
    db $01,$FF,$FF

;===============================================================================
; handle_box routine
;
; Routine to handle the retry box expanding/shrinking.
;===============================================================================
handle_box:
    ; Check if the box has finished expanding/shrinking.
    ldx #$00
    lda !ram_prompt_phase : cmp #$01 : beq +
    inx
+
    ; If we shouldn't show the box, then just go to the next phase immediately.
    lda !ram_disable_prompt_bg : bne +
    lda $1B89|!addr : cmp.l .size,x : bne .not_finished
+
    ; Go to the next prompt phase.
    lda !ram_prompt_phase : inc : sta !ram_prompt_phase

    ; Check if it finished expanding or shrinking.
    txa : beq .finished_expanding

.finished_shrinking:
    ; If the box is enabled, reset the screen settings and disable windowing.
    lda !ram_disable_prompt_bg : bne +
    stz $41
    stz $42
    stz $43
    lda.b #~$02 : trb $44
    lda.b #!window_mask : trb $0D9F|!addr
+
    rts

.finished_expanding:
    ; Reset cursor counters.
    stz $1B91|!addr
    stz $1B92|!addr

    lda !ram_disable_prompt_bg : bne ..no_window

    ; Now we can enable window 2 as well
if !prompt_type == 0
    lda #$88
else ; if not(!prompt_type == 0)
    lda #$CC
endif ; !prompt_type == 0
    tsb $41 : tsb $42

    ; If the box is enabled, signal that we have to update the window and set the cooldown.
    lda.b #$80|!prompt_cooldown : sta !ram_update_window

    rts

..no_window:
    ; If the box is disabled, just set the cooldown.
if !prompt_cooldown != $00
    lda.b #!prompt_cooldown : sta !ram_update_window
endif ; !prompt_cooldown != $00

    ; Make sprites appear above the window.
    ; This fixes an issue when dying while the level end circle is covering the screen,
    ; which would make the retry letters not appear.
    ; The sprite palettes will be glitched, but at least the letters will be visible.
    lda #$0F : trb $43
    rts

.not_finished:
    ; Update the box size.
    clc : adc.l .speed,x : sta $1B89|!addr

if !prompt_type == 0
    ; Update the windowing tables.
    rep #$30
    ldx #$016E
    lda #$00FF
-   sta $04F0|!addr,x
    dex #2
    bpl -
    sep #$30

    lda $1B89|!addr : clc : adc #$80 : xba
    lda $1B89|!addr : lsr : adc $1B89|!addr : lsr : and #$FE : tax
    lda #$80 : sec : sbc $1B89|!addr
    rep #$20
    ldy #$48
-   cpy #$00
    bmi +
    sta $0548|!addr,y
+   sta $0590|!addr,x
    dey #2
    dex #2
    bpl -
    sep #$20

    ; Change screen settings (enable window 1 for everything but sprites).
    ; Window 2 is enabled when it's finished expanding.
    lda #$22 : sta $41 : sta $42
    sta $43
    lda $44 : and #$03 : ora #$20 : sta $44

    ; Enable windowing.
    lda.b #!window_mask : tsb $0D9F|!addr
    rts

assert !box_window_size%!prompt_box_speed == 0,\
    "Error: \!prompt_box_speed must evenly divide !box_window_size!"

.size:
    db !box_window_size,$00
.speed:
    db !prompt_box_speed,-!prompt_box_speed

else ; if not(!prompt_type == 0)

    ; Start writing from the start to win the race with the beam
    rep #$30
    ldx.w #$0000

if !prompt_bar_position != 0
    lda #$FF00
-   sta $04A0|!addr,x
    inx #2
    cpx.w #!prompt_bar_position*2 : bcc -
endif ; !prompt_bar_position != 0

    lda $1B89|!addr : and #$00FF : beq ..no_window
if !prompt_bar_direction != 0
if !prompt_bar_direction == 1
    eor #$FFFF : clc : adc.w #!prompt_bar_size+1 ; +1 for 2s complement
else ; !prompt_bar_direction != 1
    lsr : eor #$FFFF : clc : adc.w #(!prompt_bar_size/2)+1 ; +1 for 2s complement
endif ; !prompt_bar_direction == 1
    tay
    beq +
    lda #$FF00
-   sta $04A0|!addr,x
    inx #2
    dey : bne -
+   lda $1B89|!addr : and #$00FF
endif ; !prompt_bar_direction != 0
    tay
    lda #$00FF
-   sta $04A0|!addr,x
    inx #2
    dey : bne -
..no_window:

    cpx.w #$E0*2 : bcs ..end
    lda #$FF00
-   sta $04A0|!addr,x
    inx #2
    cpx.w #$E0*2 : bcc -
..end:
    sep #$30

    ; Change screen settings (enable inverted window 1 on everything but sprites).
    ; Window 2 is enabled when it's finished expaning.
    lda #$33 : sta $41 : sta $42
    sta $43
    lda $44 : and #$03 : ora #$20 : sta $44

    ; Enable windowing.
    lda.b #!window_mask : tsb $0D9F|!addr
    rts

if !prompt_bar_direction == 2

assert !prompt_bar_speed%2 == 0,\
    "Error: With \!prompt_bar_direction = 2, \!prompt_bar_speed must be even!"

endif ; !prompt_bar_direction < 2

assert !prompt_bar_size%!prompt_bar_speed == 0,\
    "Error: \!prompt_bar_speed must evenly divide \!prompt_bar_size!"

.size:
    db !prompt_bar_size,0
.speed:
    db !prompt_bar_speed,-!prompt_bar_speed

endif ; !prompt_type == 0

;===============================================================================
; update_window routine
;
; This changes the normal window shape.
; It's what allows the letters to go above the prompt and other sprites behind it.
;===============================================================================
update_window:
    ; Only update for 1 frame.
    and #$7F : sta !ram_update_window

    ; Check which HDMA to set.
    lda !ram_prompt_phase : cmp #$03 : bcc .custom

.vanilla:
    ; Restore the vanilla windowing HDMA table.
    ldx #$04
-   lda.l $009277|!bank,x : sta.w window_dma($4300),x
    dex : bpl -
    stz.w window_dma($4307)
    rts

.custom:
    ; Set the custom windowing HDMA table.
    ; If exit is disabled, the second line is all filled.
    lda !ram_disable_prompt_exit : rep #$20 : bne +
    lda.w #.window
    bra ++
+   lda.w #.window_no_exit
++  sta.w window_dma($4302)
    lda.w #$2604 : sta.w window_dma($4300)
    sep #$20
    lda.b #bank(.window) : sta.w window_dma($4304)
    rts

;===============================================================================
; Windowing tables generation below
; Warning: it's a hot unreadable mess, proceed with caution
;===============================================================================

; Macro to add an entry to the windowing table
; If size == 0, the entry is not inserted
; If size > $80, the entry is duplicated to keep the entries position <= $size
macro _win_entry(size, x1, x2, x3, x4)
    if <size> != $00
        if <size> <= $80
            db <size> : db <x1>,<x2>,<x3>,<x4>
        else ; if not(<size> < $80)
            db $80       : db <x1>,<x2>,<x3>,<x4>
            db <size>-$80 : db <x1>,<x2>,<x3>,<x4>
        endif ; <size> < $80
    endif ; <size> != $00
endmacro

; Macro to start the windowing table building
macro _win_start()
    !__win_size #= 0
endmacro

; Macro to add a new entry in the windowing table, and keep track of the total size
macro _win_add(size, x1, x2, x3, x4)
    %_win_entry(<size>,<x1>,<x2>,<x3>,<x4>)
    !__win_size #= !__win_size+<size>
endmacro

; Macro to add the last entry in the windowing table
; The last size is calculated automatically to fit until the end of the screen
; and also the terminator $00 is added at the end of the table
macro _win_stop(x1, x2, x3, x4)
    if !__win_size < $E0
        %_win_entry($E0-!__win_size,<x1>,<x2>,<x3>,<x4>)
    endif ; !__win_size < $E0
    db $00
endmacro

; Calculate window left position for the two prompt text lines based on the
; user tile index lists
if !prompt_type == 0

!__win_pos_line1 #= !prompt_box_text_x_pos+$10+($08*!prompt_line1_length)
!__win_pos_line2 #= !prompt_box_text_x_pos+$10+($08*!prompt_line2_length)

else ; if not(!prompt_type == 0)

assert !prompt_bar_size >= $08,\
    "Error: \!prompt_bar_size must be >= $08!"
assert !prompt_bar_position+!prompt_bar_size <= $E0,\
    "Error: \!prompt_bar_position + \!prompt_bar_size must be <= $E0!"

if not(!no_prompt_bg) ; Avoid unexpected compilation errors, even if it might fail at runtime
assert !prompt_bar_text_y_pos >= !prompt_bar_position,\
    "Error: \!prompt_bar_text_y_pos must be >= \!prompt_bar_position!"
assert !prompt_bar_text_y_pos <= !prompt_bar_position+!prompt_bar_size-$08,\
    "Error: \!prompt_bar_text_y_pos must be <= \!prompt_bar_position + \!prompt_bar_size! - 8"
endif ; not(!no_prompt_bg)

!__win_pos_line1 #= !prompt_bar_text_x_pos
!__win_pos_line1_end #= !__win_pos_line1+$10+($08*!prompt_line1_length)
!__win_pos_line2 #= !__win_pos_line1+$10+!prompt_bar_exit_x_offset+($08*!prompt_line2_length)

endif ; !prompt_type == 0

; Windowing table to use normally
.window:
if defined("prompt_tile_index_line2")
if !prompt_type == 0
    ; all cover / layer123 cover
    %_win_start()
    %_win_add($5D,$FF,$00,$FF,$00)
    %_win_add($12,!box_window_x_pos,$100-!box_window_x_pos,$FF,$00)
    %_win_add($08,!__win_pos_line1,$100-!box_window_x_pos,!box_window_x_pos,$100-!box_window_x_pos)
    %_win_add($08,!box_window_x_pos,$100-!box_window_x_pos,$FF,$00)
    %_win_add($08,!__win_pos_line2,$100-!box_window_x_pos,!box_window_x_pos,$100-!box_window_x_pos)
    %_win_add($0D,!box_window_x_pos,$100-!box_window_x_pos,$FF,$00)
    %_win_stop($FF,$00,$FF,$00)
else ; if not(!prompt_type == 0)
    %_win_start()
    %_win_add(!prompt_bar_position,$00,$FF,$00,$FF)
    %_win_add(!prompt_bar_text_y_pos-!prompt_bar_position,$FF,$00,$FF,$00)
    %_win_add($08,!__win_pos_line1,!__win_pos_line2-1,$FF,$00)
    %_win_add(!prompt_bar_size-$08-(!prompt_bar_text_y_pos-!prompt_bar_position),$FF,$00,$FF,$00)
    %_win_stop($00,$FF,$00,$FF)
endif ; !prompt_type == 0
endif ; defined("prompt_tile_index_line2")

; Windowing table to use when exit is disabled
.window_no_exit:
if !prompt_type == 0
    ; all cover / layer123 cover
    %_win_start()
    %_win_add($5D,$FF,$00,$FF,$00)
    %_win_add($12,!box_window_x_pos,$100-!box_window_x_pos,$FF,$00)
    %_win_add($08,!__win_pos_line1,$100-!box_window_x_pos,!box_window_x_pos,$100-!box_window_x_pos)
    %_win_add($1D,!box_window_x_pos,$100-!box_window_x_pos,$FF,$00)
    %_win_stop($FF,$00,$FF,$00)
else ; if not(!prompt_type == 0)
    %_win_start()
    %_win_add(!prompt_bar_position,$00,$FF,$00,$FF)
    %_win_add(!prompt_bar_text_y_pos-!prompt_bar_position,$FF,$00,$FF,$00)
    %_win_add($08,!__win_pos_line1,!__win_pos_line1_end-1,$FF,$00)
    %_win_add(!prompt_bar_size-$08-(!prompt_bar_text_y_pos-!prompt_bar_position),$FF,$00,$FF,$00)
    %_win_stop($00,$FF,$00,$FF)
endif ; !prompt_type == 0
