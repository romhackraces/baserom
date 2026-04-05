; This file handles expanding the normal SRAM and saving custom addresses to it.
; It works on both lorom (SRAM) and SA-1 (BW-RAM).

; Bank byte of the SRAM default table.
!sram_defaults_bank = bank(tables_sram_defaults)

; Helper defines for size and index in the save table
!save_table_size_local           = (tables_save_global-tables_save)
!save_table_size_local_game_over = (tables_save_not_game_over-tables_save)
!save_table_size_global          = (tables_sram_defaults-tables_save_global)
!save_table_size                 = !save_table_size_local+!save_table_size_global
!save_table_index_global         = !save_table_size_local

; Magic number to mark save areas in SRAM
!sram_magic_number = $52544552 ; RETR

if !sram_feature

pushpc

; Change SRAM size in the header.
if read1($00FFD8) < !sram_size
org $00FFD8
    db !sram_size
endif ; if read1($00FFD8) < !sram_size

; Hijack save game routine.
org $009BCB
    jml save_game

; Hijack load game routine.
org $009CF5
    jml load_game

pullpc

; Place the MVN routine in RAM to be able to change the bank parameters at runtime
; MVN <src_bank>,<dst_bank> : RTS
; Note that MVN has dst_bank before src_bank when assembled
base $0008|!dp
    data_transfer:
        .mvn:      skip 1
        .dst_bank: skip 1
        .src_bank: skip 1
        .rts:      skip 1
base off

; Setup MVN and RTS in data_tranfer
macro setup_data_transfer()
    ; MVN = opcode $54
    lda #$54 : sta.b data_transfer_mvn

    ; RTS = opcode $60
    lda #$60 : sta.b data_transfer_rts
endmacro

macro next_iteration()
    ; Progress to the sram address to save to
    lda $02 : clc : adc $04 : sta $02
    
    ; Increase save table index
    ; PLA === PLX : TXA
    ; Carry cannot be set unless the save table is too large (invalid anyway)
    pla : adc #$0005 : tax

    ; If not at the end of the save table, loop
    cpx $06 : bcc .loop
endmacro

;=====================================
; save_global routine
;=====================================
save_global:
    ; Setup data transfer routine
    sep #$30
    %setup_data_transfer()

    ; Write destination bank parameter in data transfer routine
    lda.b #!sram_bank : sta.b data_transfer_dst_bank

    ; Check if global save is needed
    rep #$30
    lda.w #!save_table_size_global : beq .return
    
    ; $06 = save table ending index to save
    lda.w #!save_table_size : sta $06

    ; $02 = starting sram address
    jsr get_global_sram_addr : sta $02

    ; Save the global data
    ldx.w #!save_table_index_global
    jsr save_data

    ; Save the magic number to global SRAM
    lda.w #!sram_magic_number : sta !sram_addr_global
    lda.w #!sram_magic_number>>16 : sta !sram_addr_global+2

.return:
    rts

;=====================================
; load_global routine
;=====================================
load_global:
    phb : phk : plb

    ; Setup data transfer routine
    %setup_data_transfer()

    ; Check if global save is used
    rep #$30
    lda.w #!save_table_size_global : beq .return

    ; $06 = save table ending index to init/load
    lda.w #!save_table_size : sta $06

    ; If magic number is in SRAM, load the global data
    lda !sram_addr_global : cmp.w #!sram_magic_number : bne .init
    lda !sram_addr_global+2 : cmp.w #!sram_magic_number>>16 : bne .init

.load:
    ; Write source bank parameter in data transfer routine
    sep #$20
    lda.b #!sram_bank : sta.b data_transfer_src_bank
    rep #$20

    ; $02 = starting sram address
    jsr get_global_sram_addr : sta $02

    ; Load the global data
    ldx.w #!save_table_index_global
    jsr load_data

    bra .return

.init:
    ; Write source bank parameter in data transfer routine
    sep #$20
    lda.b #!sram_defaults_bank : sta.b data_transfer_src_bank
    rep #$20

    ; $02 = starting sram defaults address
    lda.w #tables_sram_defaults_global : sta $02

    ; Load the data from rom (sram defaults table)
    ldx.w #!save_table_index_global
    jsr load_data

    ; Save the global data to SRAM
    jsr save_global

.return:
    sep #$30
    plb
    rts

;=====================================
; save_game routine
;=====================================
save_game:
    ; Call the custom save routine.
    php : phb
    jsl extra_save_file
    plb : plp

    ; Setup data transfer routine
    %setup_data_transfer()

    ; Write destination bank parameter in data transfer routine
    lda.b #!sram_bank : sta.b data_transfer_dst_bank

    ; Get starting sram address
    jsr get_file_sram_addr

    ; Save the magic number to the save file (-4 from the sram addr returned)
    ; Also set the code bank on the stack
-   %set_dbr(!sram_addr)
    sec : sbc #$0004 : sta $02
    lda.w #!sram_magic_number : sta ($02)
    ldy #$0002
    lda.w #!sram_magic_number>>16 : sta ($02),y
    lda $02 : clc : adc #$0004 : sta $02
    ; Now $02 and the DBR is set up correctly
    plb

    ; $06 = save table ending index to save
    lda.w #!save_table_size_local : sta $06

    ; Save the save file data
    ldx #$0000
    jsr save_data

    ; Save the global data
    jsr save_global

.no_global:    
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
    beq .load
    jmp init_file

.load:
    phb : phx : phy : php

    ; Call the custom load routine.
    sep #$30
    php : phb
    jsl extra_load_file
    plb : plp

    ; $06 = save table ending index to load (entire local table)
    rep #$30
    lda.w #!save_table_size_local : sta $06
    jsr load_file

    plp : ply : plx : plb
    
    ; Restore original code and jump back.
    phx
    stz $0109|!addr
    jml $009CFB|!bank

;=====================================
; load_game_over routine
;=====================================
load_game_over:
    phb : phx : phy : php

    ; Load carry with save file empty check result
    jsr shared_is_save_file_empty
    
    ; $06 = save table ending index to init/load (not the game_over part)
    rep #$30
    lda.w #!save_table_size_local_game_over : sta $06
    
    ; Init or load the save based on carry status
    bcs .empty
.not_empty:
    jsr load_file
    bra .return
.empty:
    jsr init_data

.return:
    plp : ply : plx : plb
    rtl

;=====================================
; load_file routine
;=====================================
load_file:
    ; Setup data transfer routine
    sep #$20
    %setup_data_transfer()

    ; Write source bank parameter in data transfer routine
    lda.b #!sram_bank : sta.b data_transfer_src_bank

    ; Get starting sram address
    jsr get_file_sram_addr

    ; Check the magic number in the save file (-4 from the sram addr returned)
    ; Also set the code bank on the stack
-   %set_dbr(!sram_addr)
    sec : sbc #$0004 : sta $02
    lda ($02) : cmp.w #!sram_magic_number : bne .fail
    ldy #$0002
    lda ($02),y : cmp.w #!sram_magic_number>>16 : bne .fail
    lda $02 : clc : adc #$0004 : sta $02
    ; Now $02 and the DBR is set up correctly
    plb

    ; Load the data from sram
    ldx #$0000
    jsr load_data
    rts

.fail:
    ; Go to the fail handler
    plb
    jmp fail_sram

;=====================================
; init_file routine
;=====================================
init_file:
    phb : phx : phy : php

    ; Call the custom load routine.
    phb
    sep #$30
    jsl extra_load_new_file
    plb

    ; $06 = save table ending index
    rep #$30
    lda.w #!save_table_size_local : sta $06
    jsr init_data

    plp : ply : plx : plb
    jml $009D22|!bank

; Helper routine for init_file operations
; - $06 = ending index in the table_save
init_data:
    ; Setup data transfer routine
    sep #$20
    %setup_data_transfer()

    ; Write source bank parameter in data transfer routine
    lda.b #!sram_defaults_bank : sta.b data_transfer_src_bank

    ; $02 = starting sram defaults address
    rep #$30
    lda.w #tables_sram_defaults : sta $02

    ; Load the data from rom (sram defaults table)
    ldx #$0000
    jsr load_data

    ; Initialize the intro level checkpoint.
    jsr shared_get_intro_sublevel
    sta !ram_checkpoint

    ; Align checkpoint table with the initial OW flags
    jsr shared_set_checkpoints_from_initial_ow_flags
    rts

; Helper routine for save_game operations
; Inputs:
; - A,X,Y 16 bit
; - X = starting index in the table_save
; - $02 = starting address to save to
; - $06 = ending index in the table_save
; - data_transfer mvn, rts and dst_bank set up
save_data:
    phb
.loop:
    phx

    ; $00 = source address
    lda.l tables_save,x : sta $00
    
    ; $04 = transfer size
    lda.l tables_save+3,x : sta $04

    ; Push MVN accumulator parameter on the stack (size - 1)
    dec : pha

    ; Write source bank parameter in data transfer routine
    sep #$20
    lda.l tables_save+2,x : sta.b data_transfer_src_bank
    rep #$20

    ; Call the data transfer routine with parameters:
    ; - X = $00 = source address
    ; - Y = $02 = destination address
    ; - A = transfer size - 1
    ldx $00
    ldy $02
    pla
    jsr.w data_transfer

    ; Loop the entire save table
    %next_iteration()

.end:
    plb
    rts

; Helper routine for load_file and init_file operations
; Inputs:
; - A,X,Y 16 bit
; - X = starting index in the table_save
; - $02 = starting address to load from
; - $06 = ending index in the table_save
; - data_transfer mvn, rts and src_bank set up
load_data:
    phb
.loop:
    phx

    ; Y = destination address
    lda.l tables_save,x : tay
    
    ; $04 = transfer size
    lda.l tables_save+3,x : sta $04

    ; Push MVN accumulator parameter on the stack (size - 1)
    dec : pha
    
    ; Write destination bank parameter in data transfer routine
    sep #$20
    lda.l tables_save+2,x : sta.b data_transfer_dst_bank
    rep #$20

    ; Call the data transfer routine with parameters:
    ; - X = $02 = source address
    ; - Y = destination address (loaded earlier)
    ; - A = transfer size - 1
    ldx $02
    pla
    jsr.w data_transfer
    
    ; Loop the entire save table
    %next_iteration()

.end:
    plb
    rts

;=====================================
; get_file_sram_addr routine
;=====================================
get_file_sram_addr:
    rep #$30
    lda $010A|!addr : and #$00FF : asl : tax
    lda.l .sram_addr,x
    rts    

.sram_addr:
    dw !sram_addr+4
    dw !sram_addr+4+!file_size
    dw !sram_addr+4+(2*!file_size)

;=====================================
; get_global_sram_addr routine
;=====================================
get_global_sram_addr:
    lda.w #!sram_addr_global+4
    rts

elseif not(!sram_plus) && not(!bwram_plus) ; && not(!sram_feature)

; Restore code, in case settings are changed.
pushpc

if read1($00FFD8) == !sram_size
org $00FFD8
    db $01
endif ; read1($00FFD8) == !sram_size

if read1($009BCB) == $5C
org $009BCB
    plb
    ldx $010A|!addr
endif ; read1($009BCB) == $5C

if read1($009CF5) == $5C
org $009CF5
    bne $2B
    phx
    stz $0109|!addr
endif ; read1($009CF5) == $5C

pullpc

endif ; !sram_feature
