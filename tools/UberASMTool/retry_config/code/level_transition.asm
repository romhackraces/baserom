; Gamemode 10, 11, 16, 19

init:
    ; Disable HDMA.
    stz $0D9F|!addr
    rtl
