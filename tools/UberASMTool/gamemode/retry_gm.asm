;>dbr off

; Max gamemode used by Retry
!retry_gm_max = $19

; Macro to jump to the correct routine depending on the gamemode
; from a table of word pointers to the routines
macro jump_to_gm_ptr(table)
    ; Compile time sanity check
    assert <table>_end-<table> == (!retry_gm_max+1)*2, "<table> table is invalid"

    ; Even if something changed the gamemode we're gucci
    lda.l retry_ram_gm_backup : cmp.b #!retry_gm_max+1 : bcs return
    ; Set $00 = jump pointer
    ; The bank is the same for all pointers
    asl : tax
    rep #$20
    lda.l <table>,x : sta $00
    sep #$20
    lda.b #retry_empty>>16 : sta $02
    jml [$0000|!dp]
endmacro

init:
    lda $0100|!addr : sta.l retry_ram_gm_backup
    %jump_to_gm_ptr(init_ptrs)

main:
    %jump_to_gm_ptr(main_ptrs)

end:
    %jump_to_gm_ptr(end_ptrs)

nmi:
    ; Only gamemode 14 needs NMI
    lda $0100|!addr : cmp #$14 : bne return
    jml retry_nmi_level

return:
    rtl

init_ptrs:
    dw retry_startup_init           ; $00
    dw retry_empty                  ; $01
    dw retry_empty                  ; $02
    dw retry_empty                  ; $03
    dw retry_empty                  ; $04
    dw retry_empty                  ; $05
    dw retry_level_init_3_init      ; $06
    dw retry_empty                  ; $07
    dw retry_empty                  ; $08
    dw retry_empty                  ; $09
    dw retry_empty                  ; $0A
    dw retry_empty                  ; $0B
    dw retry_load_overworld_init    ; $0C
    dw retry_fade_to_overworld_init ; $0D
    dw retry_empty                  ; $0E
    dw retry_fade_to_level_init     ; $0F
    dw retry_level_transition_init  ; $10
    dw retry_level_init_1_init      ; $11
    dw retry_level_init_2_init      ; $12
    dw retry_level_init_3_init      ; $13
    dw retry_empty                  ; $14
    dw retry_time_up_init           ; $15
    dw retry_game_over_init         ; $16
    dw retry_empty                  ; $17
    dw retry_empty                  ; $18
    dw retry_level_transition_init  ; $19
.end:

main_ptrs:
    dw retry_empty              ; $00
    dw retry_empty              ; $01
    dw retry_empty              ; $02
    dw retry_empty              ; $03
    dw retry_empty              ; $04
    dw retry_empty              ; $05
    dw retry_level_init_3_main  ; $06
    dw retry_in_level_main      ; $07
    dw retry_empty              ; $08
    dw retry_empty              ; $09
    dw retry_empty              ; $0A
    dw retry_empty              ; $0B
    dw retry_empty              ; $0C
    dw retry_empty              ; $0D
    dw retry_empty              ; $0E
    dw retry_fade_to_level_main ; $0F
    dw retry_empty              ; $10
    dw retry_empty              ; $11
    dw retry_empty              ; $12
    dw retry_level_init_3_main  ; $13
    dw retry_in_level_main      ; $14
    dw retry_empty              ; $15
    dw retry_empty              ; $16
    dw retry_empty              ; $17
    dw retry_empty              ; $18
    dw retry_empty              ; $19
.end:

end_ptrs:
    dw retry_empty        ; $00
    dw retry_empty        ; $01
    dw retry_empty        ; $02
    dw retry_empty        ; $03
    dw retry_empty        ; $04
    dw retry_empty        ; $05
    dw retry_empty        ; $06
    dw retry_in_level_end ; $07
    dw retry_empty        ; $08
    dw retry_empty        ; $09
    dw retry_empty        ; $0A
    dw retry_empty        ; $0B
    dw retry_empty        ; $0C
    dw retry_empty        ; $0D
    dw retry_empty        ; $0E
    dw retry_empty        ; $0F
    dw retry_empty        ; $10
    dw retry_empty        ; $11
    dw retry_empty        ; $12
    dw retry_empty        ; $13
    dw retry_in_level_end ; $14
    dw retry_empty        ; $15
    dw retry_empty        ; $16
    dw retry_empty        ; $17
    dw retry_empty        ; $18
    dw retry_empty        ; $19
.end:
