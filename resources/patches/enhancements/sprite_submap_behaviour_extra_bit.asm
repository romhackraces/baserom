; This patch will remove the submap/level specific behavior of a few
; vanilla sprites and make them depend on the extra bit instead.
; Note that you need to have used PIXI on the ROM in order for it to work.
; These are the sprites affected:
; - Monty Moles (sprites 4D,4E)
;    Extra bit = 0: fast digging
;    Extra bit = 1: slow digging
; - Hammer Bro (sprite 9B)
;    Extra bit = 0: unfrequent throwing
;    Extra bit = 1: frequent throwing
; - Dry Bones, stay on ledge (sprite 32)
;    Extra bit = 0: throws bones
;    Extra bit = 1: doesn't throw bones

if read1($00FFD5) == $23
    sa1rom
    !extra_bits = $400040
else
    lorom
    !extra_bits = $7FAB10
endif

; Monty Moles
org $01E2F3
    lda.l !extra_bits,x
    lsr #2

; Hammer Bro
org $02DA79
    lda.l !extra_bits,x
    lsr #2

; Dry bones
org $01E526
    autoclean jsl dry_bone
    nop

org $01E5A0
    autoclean jsl dry_bone
    nop

freedata

dry_bone:
    lda !extra_bits,x : and #$04
    rtl
