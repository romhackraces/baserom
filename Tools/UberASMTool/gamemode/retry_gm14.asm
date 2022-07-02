init:
    REP #$20    ;\
    STZ $0FAE   ;| reset Vanilla boo ring positions
    STZ $0FB0   ;|
    SEP #$20    ;/
    jsl double_hit_fix_init
    rtl

main:
    jsl retry_in_level_main
    jsl double_hit_fix_main
    JSL ScreenScrollingPipes_SSPMaincode
    rtl

nmi:
    jsl retry_nmi_level
    rtl
