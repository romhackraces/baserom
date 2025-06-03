; Gamemode 14 - Level
init:
    jsl double_hit_fix_init
    rtl

main:
    jsl double_hit_fix_main
    jsl screen_scrolling_pipes_main
    jsl uberasm_objects_main
    rtl

end:
    jsl uberasm_objects_end
    rtl

