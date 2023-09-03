; This file handles expanding the normal SRAM and saving custom addresses to it.
; It works on both lorom (SRAM) and SA-1 (BW-RAM).
; You can change the parameters below if you want. The default should be fine in most cases.

; SRAM size in the ROM header. Actual size is (2^!sram_size) KB.
; Not used on SA-1 roms.
!sram_size = $03

; How big (in bytes) each save file is in SRAM/BW-RAM.
!file_size = $0955

; SRAM/BW-RAM address to save to.
if !sa1
    !sram_addr = $41A000
else
    !sram_addr = $700400
endif

; Bank byte of the SRAM/BW-RAM address.
!sram_bank          = (!sram_addr>>16)
!sram_defaults_bank = (tables_sram_defaults>>16)

; How big is the save table.
!save_table_size           = (tables_sram_defaults-tables_save)
!save_table_size_game_over = (tables_save_not_game_over-tables_save)

if !sram_feature

pushpc

; Change SRAM size in the header.
if read1($00FFD8) < !sram_size
org $00FFD8
    db !sram_size
endif

; Hijack save game routine.
org $009BCB
    jml save_game

; Hijack load game routine.
org $009CF5
    jml load_game

pullpc

; Some helper macros.
macro transfer(src,dst)
    pla
    mvn <dst>,<src>
    bra ..next
endmacro

macro next_iteration()
    lda $02 : clc : adc $04 : sta $02
    plb : plx
    txa : clc : adc #$0005 : tax
    cpx $06 : bcc .loop
endmacro

;=====================================
; save_game routine
;=====================================
save_game:
    ; Set the DBR.
    phk : plb

    ; Call the custom save routine.
    php : phb
    jsr extra_save_file
    plb : plp

    jsr get_sram_addr
    lda.w #!save_table_size : sta $06
    ldx #$0000
.loop:
    lda.w tables_save,x : sta $00
    phx : phb
    lda.w tables_save+3,x : sta $04
    dec : pha
    lda.w tables_save+2,x
    ldx $00
    ldy $02
    and #$00FF : beq ..use_00
    cmp #$007E : beq ..use_7E
if !sa1
    cmp #$007F : beq ..use_7F
    cmp #$0040 : beq ..use_40
..use_41:
    %transfer($41,!sram_bank)
..use_40:
    %transfer($40,!sram_bank)
endif
..use_7F:
    %transfer($7F,!sram_bank)
..use_7E:
    %transfer($7E,!sram_bank)
..use_00:
    %transfer($00|!bank8,!sram_bank)
..next:
    %next_iteration()
.end:
    sep #$30
    
    ; Restore original code and jump back.
    plb
    ldx $010A|!addr
    jml $009BCF|!bank

;=====================================
; load_game routine
;=====================================
load_game:
    ; Load or init the file
    beq +
    jmp init_file
+   
    ; Preserve DB, X, Y, P.
    phb : phk : plb
    phx : phy : php

    ; Call the custom load routine.
    sep #$30
    php : phb
    jsr extra_load_file
    plb : plp

    ; Set the save table size.
    rep #$30
    lda.w #!save_table_size : sta $06

    ; Load the save file.
    jsr load_file

    ; Restore DBR, P, X and Y.
    plp : ply : plx
    plb
    
    ; Restore original code and jump back.
    phx
    stz $0109|!addr
    jml $009CFB|!bank

load_game_over:
    ; Preserve DB, X, Y, P.
    phb : phk : plb
    phx : phy : php

    ; Set the save table size.
    rep #$30
    lda.w #!save_table_size_game_over : sta $06

    ; Load the save file.
    jsr load_file

    ; Restore DBR, P, X and Y.
    plp : ply : plx
    plb
    rtl

load_file:
    jsr get_sram_addr
    ldx #$0000
.loop:
    lda.w tables_save,x : tay
    phx : phb
    lda.w tables_save+3,x : sta $04
    dec : pha
    lda.w tables_save+2,x
    ldx $02
    and #$00FF : beq ..use_00
    cmp #$007E : beq ..use_7E
if !sa1
    cmp #$007F : beq ..use_7F
    cmp #$0040 : beq ..use_40
..use_41:
    %transfer(!sram_bank,$41)
..use_40:
    %transfer(!sram_bank,$40)
endif
..use_7F:
    %transfer(!sram_bank,$7F)
..use_7E:
    %transfer(!sram_bank,$7E)
..use_00:
    %transfer(!sram_bank,$00|!bank8)
..next:
    %next_iteration()
.end:
    rts

init_file:
    ; Preserve X and Y.
    phx : phy

    ; Set 8 bit X/Y for the custom routine.
    sep #$10

    ; Set DBR.
    phb : phk : plb

    ; Call the custom load routine.
    php : phb
    jsr extra_load_new_file
    plb : plp

    rep #$30
    lda.w #tables_sram_defaults : sta $02
    lda.w #!save_table_size : sta $06
    ldx #$0000
.loop:
    lda.w tables_save,x : tay
    phx : phb
    lda.w tables_save+3,x : sta $04
    dec : pha
    lda.w tables_save+2,x
    ldx $02
    and #$00FF : beq ..use_00
    cmp #$007E : beq ..use_7E
if !sa1
    cmp #$007F : beq ..use_7F
    cmp #$0040 : beq ..use_40
..use_41:
    %transfer(!sram_defaults_bank,$41)
..use_40:
    %transfer(!sram_defaults_bank,$40)
endif
..use_7F:
    %transfer(!sram_defaults_bank,$7F)
..use_7E:
    %transfer(!sram_defaults_bank,$7E)
..use_00:
    %transfer(!sram_defaults_bank,$00|!bank8)
..next:
    %next_iteration()
..end:
    ; Initialize the intro level checkpoint.
    jsr shared_get_intro_sublevel
    sta !ram_checkpoint

    ; Keep 16 bit X/Y for the original code.
    sep #$20

    ; Restore DBR, Y and X.
    plb : ply : plx

    ; Jump back.
    jml $009D22|!bank

;=====================================
; get_sram_addr routine.
;
; Small routine to get the low and high byte of the destination address into $02.
;=====================================
get_sram_addr:
    rep #$30
    lda $010A|!addr : and #$00FF : asl : tax
    lda.w .sram_addr,x : sta $02
    rts    

.sram_addr:
    dw !sram_addr,!sram_addr+!file_size,!sram_addr+(2*!file_size)

else

; Restore code, in case settings are changed.
if not(!sram_plus) && not(!bwram_plus)

pushpc

if read1($00FFD8) == !sram_size
org $00FFD8
    db $01
endif

if read1($009BCB) == $5C
org $009BCB
    plb
    ldx $010A|!addr
endif

if read1($009CF5) == $5C
org $009CF5
    bne $2B
    phx
    stz $0109|!addr
endif

pullpc

endif

endif
