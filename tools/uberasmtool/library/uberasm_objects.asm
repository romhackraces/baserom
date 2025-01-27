incsrc "callisto.asm"
%import_library("freeram.asm")

;=================================================================
; UberASM Objects System
;=================================================================
; run the "init" in gamemode 12 (level prepare) and the "main"
; in gamemode 14 (in level).
;
; This requires ObjecTool and reserves Extended objects 98-DF
; see patches/objectool/custom_object_code.asm for details
;=================================================================

; requires 13 bytes of FreeRAM, cleared on before the level loads
!FreeRAM = !objectool_level_flags_bank


; macro to loop through routines
macro RoutineLoop(label)
    phb : phk : plb
    lda.b #routines_<label>&$FF
    sta $00
    lda.b #routines_<label>>>8
    sta $01
    rep #$10
    ldy.w #routines_<label>_done-routines_<label>-3
    jsr run_routines
    plb
endmacro

init:
    lda $71
    cmp #$0A
    bne .not_castle_entrance
    rtl
.not_castle_entrance
    %RoutineLoop(init)
    rtl

main:
    lda $71
    cmp #$0A
    bne .not_castle_entrance
    rtl

.not_castle_entrance
    %RoutineLoop(main)
    rtl

end:
    lda $71
    cmp #$0A
    bne .not_castle_entrance
    rtl
.not_castle_entrance
    %RoutineLoop(end)
    rtl

;=================================================================
; word routine table pointer in $00-$01
; table size - 3 (in bytes) in 16-bit Y (16-bit needed since 3 * 0x68 > 0xFF)
; clobbers: $02, $03, $04
;=================================================================
run_routines:
.loop
    lda ($00),y     ; load current custom object number
    sta $02         ; cache in $02
    lsr #3          ; divide custom object number by 8 to get byte index into FreeRAM
    sta $03         ; cache in $03
    stz $04         ; zero out $04 so 16-bit X can load index later
    lda #$00
    xba             ; zero out high byte of A so we can transfer to 16-bit X later
    lda $02         ; restore custom object number from $02
    and #$07        ; modulo 8 to get bit index
    tax
    lda ..masks,x   ; load correct mask for the bit
    ldx $03         ; load byte index from $03-$04
    and !FreeRAM,x
    beq ..next      ; if bit not set skip the routine

    iny
    lda ($00),y
    sta $02
    iny
    lda ($00),y
    sta $03         ; otherwise, load word routine address into $02-$03

    phy             ; pushing current table index rather than caching in scratch so routines can use scratch
    sep #$10        ; ensuring routines get 8-bit everything
    ldx #$00
    jsr ($0002|!dp,x)   ; jump to object routine in $02-$03
    rep #$10        ; restore 16-bit X/Y
    ply             ; restore current table index

    dey #2          ; need to undo the two iny's from earlier

..next
    dey #3          ; move to next table entry
    bpl .loop
    sep #$10
    rts

..masks
    db 1,2,4,8,16,32,64,128

; Include routines
incsrc "./uberasm_objects_routines.asm"