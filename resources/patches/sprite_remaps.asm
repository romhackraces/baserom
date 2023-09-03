;;;;;;;;;;;;;;;;;;;
;; Sprite Remaps ;;
;;;;;;;;;;;;;;;;;;;

; Note block bounce sprite
org $0291F2 : db $4A : org $02878A : db $02
; Side turn block bounce sprite
org $0291F4 : db $40 : org $02878C : db $00
; ON/OFF bounce sprite
org $0291F6 : db $0A : org $02878E : db $06

; Yoshi's tongue, end
org $01F48C : db $7E : org $01F494 : db $08
; Yoshi's tongue, middle
org $01F488 : db $7F : org $01F494 : db $08
; Yoshi's throat
org $01F08B : db $38 : org $01F097 : db $00
; Yoshi egg fragment
org $028EB2 : db $2F : org $028EBC : db $03

; Coin Game coin, use normal coin sprite
org $029D4B : db $E8 : org $029D50 : db $34

; Cheep cheep, horizontal
org $019C0D : db $66 : org $07F413 : db $45
org $019C0E : db $68 : org $07F413 : db $45
; Cheep cheep, vertical
org $019C0D : db $66 : org $07F414 : db $45
org $019C0E : db $68 : org $07F414 : db $45
; Cheep cheep, flying
org $019C0D : db $66 : org $07F415 : db $85
org $019C0E : db $68 : org $07F415 : db $85
; Cheep cheep, jumping
org $019C0D : db $66 : org $07F416 : db $85
org $019C0E : db $68 : org $07F416 : db $85
; Cheep cheep, flopping
org $019C0F : db $6C
org $019C10 : db $6A
; Cheep cheep, in bubble
org $02D8A3 : db $66 : org $02D8AB : db $05
org $02D8A7 : db $68 : org $02D8AB : db $05
; Force flopping cheep-cheep onto 2nd page
org $01B10A : BRA +
org $01B11C : +

; Hammer Brother Hammer, second frame
org $02A2E0 : db $6E
org $02A2E1 : db $6E
org $02A2E4 : db $6E
org $02A2E5 : db $6E

; Blue Koopa Sliding, second frame
org $019B92 : db $88
; Blue Koopa Sliding, 8th frame
org $0189ED : db $86

; Lava splashes
org $029E82 : db $5F,$4F,$5E,$4E
org $029ED5 : db $04

; Podoboo lava trail
org $028F2B : db $5F,$4F,$5E,$4E
org $028F76 : db $04
org $028F82 : db $00
