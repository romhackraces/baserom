; Gamemode 14 - Level
init:
    jsl double_hit_fix_init
    rtl

main:
    jsl retry_in_level_main
    jsl double_hit_fix_main
    jsl ScreenScrollingPipes_main
    jsl uberasm_objects_main
    rtl

nmi:
    jsl retry_nmi_level
    rtl
