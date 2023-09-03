pushpc

; Change initial life counter.
org $009E25
    db !initial_lives-1

; Fix for old initial sprite facing fix.
if read1($01AD33) == $94
org $01AD33
    db $D1
endif

if read1($01AD3A) == $95
org $01AD3A
    db $D2
endif

; Fix Message Box erasing some sprite tiles when closing.
org $05B31B
    rts : db $69

pullpc
