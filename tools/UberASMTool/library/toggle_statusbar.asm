incsrc "callisto.asm"
%import_library("freeram.asm")

init:
    lda #$01 : sta !toggle_statusbar_freeram
    rtl