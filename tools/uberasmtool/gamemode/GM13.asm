; Gamemode 13 - Level: Fade in
init:
    jsl retry_level_init_3_init
    jsl uberasm_objects_init
    rtl

main:
    jsl retry_indicator_main
    jsl retry_level_init_3_main
    rtl
