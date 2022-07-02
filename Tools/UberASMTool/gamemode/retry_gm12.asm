; Make sure this is the same as the patch
!fireballs_freeram = $60

; How many fireballs to have globally
!fireballs_global_amount = $02

init:
    lda.b #!fireballs_global_amount : sta !fireballs_freeram
    jsl retry_level_init_2_init
    rtl
