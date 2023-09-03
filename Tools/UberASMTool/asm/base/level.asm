macro CallLevelResources(offset)
    lda #<offset>
    pha

    %LevelAllJSLs()                ; added by UAT in asm/work/resource_calls.asm

    rep #$30
    lda !level
    asl
    tax
    lda.l LevelResourcePointers,x  ; these point to the lists-of-jsls
    sta $00
    sep #$30
    ldx #$00
    jsr (!dp,x)
    pla
endmacro

; no longer used as of 2.0, but the existence of this table is used specifically to determine if 1.x is currently patched
;db "uber"
;level_asm_table:
;level_init_table:
;level_nmi_table:
;level_load_table:
;db "tool"

; -----------------------------------------------------

; called with 8-bit A, 16-bit X/Y
CallLevelLoad:
    sep #$30
    phb

    %CallLevelResources($06)
    plb

; return back from hijack
    rep #$10
    phk
    pea .return-1
    pea $8125-1      ; bank 05
    jml $0583AC|!bank
.return:
    sep #$30
    jml $058091|!bank

;--------------------------------------------------

; called with A/X/Y already 16-bit
CallLevelInit:
    sep #$30
    phb
    %CallLevelResources($00)
    plb

; return back from hijack -- first instruction back sets A/X/Y back to 8-bit, which we've already done
; restore clobbered jsr $00919B
    phk
    pea .return-1
    pea $84CF-1
    jml $00919B|!bank
.return
    jml $00A5F3|!bank

;----------------------------------------------------

CallLevelMain:
    phb

    ; TODO: this may wind up calling 7F8000 twice in mode 7 boss fights; check on this
    lda $13D4|!addr
    bne +
    jsl $7F8000
+

    %CallLevelResources($02)
    plb

; return back from hijack
    lda $13D4|!addr
    beq +
    jml $00A25B|!bank
+
    jml $00A28A|!bank

;--------------------------------------

CallLevelEnd:
    sta $1C                 ; restore clobbered

    phb
    %CallLevelResources($04)
    plb

; return back from hijack, which just jumps to the OAM prep routine

    jml $008494|!bank

