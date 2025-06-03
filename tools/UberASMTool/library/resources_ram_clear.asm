incsrc "callisto.asm"
%import_library("freeram.asm")


macro clear_bytes(address,amount)
    ldx #<amount>-1
    lda #$00
    -
    sta <address>,x
    dex
    bpl -
endmacro

init:
    %clear_bytes(!objectool_level_flags_bank, 13)
    %clear_bytes(!toggles_freeram_bank, 8)
    %clear_bytes(!scroll_pipes_freeram_bank, 5)
    %clear_bytes(!scroll_fix_freeram_bank, 8)
    rtl
