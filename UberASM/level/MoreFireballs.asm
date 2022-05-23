; Make sure this is the same as the patch
!fireballs_freeram = $60

; How many fireballs to have in this level
!fireballs_level_amount = $05

init:
    lda.b #!fireballs_level_amount : sta !fireballs_freeram
    rtl
