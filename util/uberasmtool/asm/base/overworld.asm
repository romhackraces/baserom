macro CallOverworldResources(offset)
    lda #<offset>
    pha

    %OverworldAllJSLs()      ; added by UAT in asm/work/resource_calls.asm

    ldx $0DB3|!addr          ; 0 = mario, 1 = luigi
    lda $1F11|!addr,x        ; current OW map for player x
    asl
    tax
    lda.l OverworldResourcePointers,x : sta $00      ; these point to the lists-of-jsls
    lda.l OverworldResourcePointers+1,x : sta $01
    ldx #$00
    jsr (!dp,x)
    pla
endmacro

; This has been removed as of 2.0
;db "uber"
;level_asm_table:
;level_init_table:
;level_nmi_table:
;level_load_table:
;db "tool"

CallOverworldMainEnd:
    jsl $7F8000              ; restore clobbered
    phb

    %CallOverworldResources($02)

; call main part of OW routine, taking care to invoke the sa-1 side like the sa-1 patch does here
    if !sa1
        lda #$41 : sta $3180
        lda #$82 : sta $3181
        lda #$04 : sta $3182
        jsr $1E80
    else
        jsl $848241
    endif

; fall through to the code to run end: for overworld stuff

    %CallOverworldResources($04)
    plb

; return from hijack, this just jumps to the OAM prep routine, which is what the next instruction would have done
    jml $008494|!bank


;----------------------------    

CallOverworldInit:
; restore clobbered jsr $92A0
    phk
    pea .return-1
    pea $84CF-1          ; bank 00
    jml $0092A0|!bank
.return:

    phb
    %CallOverworldResources($00)
    plb

; return from hijack
    jml $0093F4|!bank

