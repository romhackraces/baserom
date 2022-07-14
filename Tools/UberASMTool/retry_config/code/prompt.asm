; Routines related to the retry prompt box and menu.

;=====================================
; handle_menu routine
;=====================================

handle_menu:
    jsr handle_cursor

    ; If no option was selected, return.
    cpy #$FF : beq .skip

    ; Restore vanilla window HDMA.
    ldx #$04
-   lda.l $009277|!bank,x : sta.w window_dma($4300),x
    dex : bpl -
    stz.w window_dma($4307)

    ; Check if we have to retry or exit.
    cpy #$00 : beq .retry
.exit:
    ; Call the custom exit routine.
    phy : php : phb : phk : plb
    jsr extra_prompt_exit
    plb : plp : ply

    ; Set prompt phase to "shrinking with exit selected".
    lda !ram_prompt_phase : clc : adc #$03 : sta !ram_prompt_phase

    ;lda !ram_hurry_up : bne ..return
    
    ; Play the correct death song.
if !amk
if !death_jingle_alt != $FF
    lda.b #!death_time : sta $1496|!addr
    lda.b #!death_jingle_alt : sta $1DFB|!addr
    rts
endif
else
    lda #$FF : sta $0DDA|!addr
endif

    lda.b #!death_time+$1E : sta $1496|!addr
    lda.b #!death_song : sta $1DFB|!addr
    rts
.retry:
    ; Set prompt phase to "shrinking with retry selected".
    lda !ram_prompt_phase : inc : sta !ram_prompt_phase
.skip:
    rts

;=====================================
; handle_cursor routine
;
; Handles the cursor frame counter and checks for player input
; (to move the cursor or select an option).
; Return the selected option in Y ($FF if none was selected).
;=====================================
handle_cursor:
    ; Increase the cursor frame counter.
    inc $1B91|!addr

    ; Initialize the number of options.
    ldy #$01
    lda !ram_disable_exit : bne +
    iny
+   sty $8A
    
if !dim_screen
    ; Fade the brightness.
    lda $0DAE|!addr : and #$F0 : sta $00
    lda $0DAE|!addr : and #$0F : cmp.b #!brightness+1 : bcc +
    dec : ora $00 : sta $0DAE|!addr
+
endif
    
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
    lda.b #!option_sfx : sta !option_sfx_addr
endif
    ldy $1B92|!addr
    stz $1B92|!addr

if !dim_screen
    ; Also, reset the screen brightness to max.
    lda $0DAE|!addr : and #$F0 : ora #$0F : sta $0DAE|!addr
endif
    rts

.not_selected:
    ; Mark result as "not selected".
    ldy #$FF

    ; If there's less than 2 options, return (can't move the cursor).
    lda $8A : cmp #$02 : bcc +

    ; If Select, Up or Down are not pressed, return.
    lda $16 : and #$20 : lsr #3
    ora $16 : and #$0C : beq +

    ; Load the index to the cursor_speed table.
    lsr #2 : tax

    ; Otherwise, play the cursor SFX.
if !cursor_sfx != $00
    lda.b #!cursor_sfx : sta !cursor_sfx_addr
endif

    ; Reset the cursor frame counter.
    stz $1B91|!addr

    ; Update the cursor position, taking into account the wraparound.
    lda $1B92|!addr : adc.l .cursor_speed-1,x : bpl ++
    lda $8A : dec
++  cmp $8A : bcc +++
    lda #$00
+++ sta $1B92|!addr
+   rts

; Distance to move the cursor when pressing down/select, up and both respectively.
.cursor_speed:
    db $01,$FF,$FF

;=====================================
; handle_box routine
;
; Routine to handle the retry box expanding/shrinking.
;=====================================
handle_box:
    ; Check if the box has finished expanding/shrinking.
    ldx $1B88|!addr

    ; If we shouldn't show the box, then just go to the next phase immediately.
    lda !ram_disable_box : bne +
    lda $1B89|!addr : cmp.l .size,x : bne .not_finished
+
    ; Go to the next prompt phase.
    lda !ram_prompt_phase : inc : sta !ram_prompt_phase

    ; Check if it finished expanding or shrinking.
    txa : beq .finished_expanding

.finished_shrinking:
    ; Reset shrinking flag.
    stz $1B88|!addr

    ; If the box is enabled, reset the screen settings and disable windowing.
    lda !ram_disable_box : bne +
    stz $41
    stz $42
    stz $43
    lda #$02 : sta $44
    lda.b #!window_mask : trb $0D9F|!addr
+
    rts

.finished_expanding:
    ; Go to the next box phase.
    inc $1B88|!addr

    ; Reset cursor counters.
    stz $1B91|!addr
    stz $1B92|!addr

    ; If the box is enabled, signal that we have to update its shape.
    lda !ram_disable_box : bne +
    lda #$01 : sta !ram_update_window
    rts
+
    ; Otherwise, make sprites appear above the window.
    ; This fixes an issue when dying while the level end circle is covering the screen,
    ; which would make the retry letters not appear.
    ; The sprite palettes will be glitched, but at least the letters will be visible.
    lda #$0F : trb $43
    rts

.not_finished:
    ; Update the box size.
    clc : adc.l .speed,x : sta $1B89|!addr

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

    ; Change screen settings.
    lda #$AA : sta $41 : sta $42
    lda #$22 : sta $43 : sta $44

    ; Enable windowing.
    lda.b #!window_mask : tsb $0D9F|!addr
    rts

.size:
    db $48,$00
.speed:
    db !prompt_speed,-!prompt_speed

;=====================================
; update_window routine
;
; This changes the normal window shape.
; It's what allows the letters to go above the prompt and other sprites behind it.
;=====================================
update_window:
    ; Only update for 1 frame.
    lda #$00 : sta !ram_update_window

    ; Update the HDMA table.
    ; If exit is disabled, the second line is all filled.
    lda !ram_disable_exit : rep #$20 : bne +
    lda.w #.window
    bra ++
+   lda.w #.window_no_exit
++  sta.w window_dma($4302)
    lda.w #$2604 : sta.w window_dma($4300)
    sep #$20
    lda.b #.window>>16 : sta.w window_dma($4304)
    rts

; Windowing table to use normally
.window:
    ; all cover / layer123 cover
    db $5D : db $FF,$00,$FF,$00
    db $12 : db $38,$C8,$FF,$00
    db $08 : db $90,$C8,$38,$C8
    db $08 : db $38,$C8,$FF,$00
    db $08 : db $88,$C8,$38,$C8
    db $0D : db $38,$C8,$FF,$00
    db $4C : db $FF,$00,$FF,$00
    db $00

; Windowing table to use when exit is disabled
.window_no_exit:
    ; all cover / layer123 cover
    db $5D : db $FF,$00,$FF,$00
    db $12 : db $38,$C8,$FF,$00
    db $08 : db $90,$C8,$38,$C8
    db $1D : db $38,$C8,$FF,$00
    db $4C : db $FF,$00,$FF,$00
    db $00
