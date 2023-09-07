; Unused Vanilla sprite number to use
!num = $12

; Tweaker $1656
org $07F26C+!num : db $00

; Tweaker $1662
org $07F335+!num : db $00

; Tweaker $166E
org $07F3FE+!num : db $F0

; Tweaker $167A
org $07F4C7+!num : db $82

; Tweaker $1686
org $07F590+!num : db $B9

; Tweaker $190F
org $07F659+!num : db $46

; Sprite init
org $01817D+(!num*2) : dw $9AD0

; Sprite main
org $0185CC+(!num*2) : dw $9A52
