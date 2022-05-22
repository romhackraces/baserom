;===============================================================================================;
; Ball and Chain interaction with Yoshi fix by KevinM                                           ;
; This patch will fix the issue where you take damage if you touch the center of rotation of    ;
; the Ball n' Chain sprite while riding Yoshi.                                                  ;
;                                                                                               ;
; This happens because, outside of the sprite's main code, the values stored in the position    ;
; addresses for the Ball n' Chain are actually relative to the position of the center.          ;
; This patch changes it so they contain the ball position instead.                              ;
; This is only an issue with Yoshi since the sprite doesn't interact with any other sprite      ;
; (also it's not an issue in the original game since Yoshi can't enter castles).                ;
;===============================================================================================;

if read1($00FFD5) == $23
    sa1rom
    !sa1  = 1
    !addr = $6000
    !bank = $000000
else
    lorom
    !sa1  = 0
    !addr = $0000
    !bank = $800000
endif

macro define_sprite_table(name, addr, addr_sa1)
    if !sa1 == 0
        !<name> = <addr>
    else
        !<name> = <addr_sa1>
    endif
endmacro

%define_sprite_table("9E", $9E, $3200)
%define_sprite_table("D8", $D8, $3216)
%define_sprite_table("E4", $E4, $322C)
%define_sprite_table("14D4", $14D4, $3258)
%define_sprite_table("14E0", $14E0, $326E)
%define_sprite_table("1504", $1504, $74F4)
%define_sprite_table("1510", $1510, $750A)
%define_sprite_table("151C", $151C, $3284)
%define_sprite_table("1570", $1570, $331E)
%define_sprite_table("1594", $1594, $3360)

; Store center position in sprite's init
org $018396 : autoclean jml StoreCenterPos

; Restore center position at the start of sprite's main
org $02D61C : autoclean jml RestoreCenterPos

; Backup actual position to scratch ram for later use
org $02D713 : autoclean jml StoreActualPos

; Store actual position to position tables
org $02D787 : autoclean jml RestoreActualPos

; Skip over some instructions we're doing earlier (see RestoreActualPos)
org $02D798 : bra $06

freedata

; !1504 = center X lo backup
; !1510 = center X hi backup
; !1570 = center Y lo backup
; !1594 = center Y hi backup

; $45 = actual X lo temp backup
; $46 = actual X hi temp backup
; $47 = actual Y lo temp backup
; $48 = actual Y hi temp backup

StoreCenterPos:
    lda !D8,x           ;\ Store center position to unused tables
    sta !1570,x         ;|
    lda !E4,x           ;|
    sta !1504,x         ;|
    lda !14D4,x         ;|
    sta !1594,x         ;|
    lda !14E0,x         ;|
    sta !1510,x         ;/
    lda #$38            ; Original code
    jml $01839C|!bank

RestoreCenterPos:
    cmp #$9F            ;\ Original code
    bne +               ;|
    jml $02D620|!bank   ;/
+   cmp #$A3            ;\ Skip if rotating platform
    beq +               ;/
    lda !1570,x         ;\ Restore center position
    sta !D8,x           ;|
    lda !1504,x         ;|
    sta !E4,x           ;|
    lda !1594,x         ;|
    sta !14D4,x         ;|
    lda !1510,x         ;|
    sta !14E0,x         ;/
+   jml $02D625|!bank

StoreActualPos:
    adc $01             ;\ Original code
    sta !14D4,x         ;/
    sta $48             ;\ Backup actual ball position for later
    lda !14E0,x         ;|
    sta $46             ;|
    lda !D8,x           ;|
    sta $47             ;|
    lda !E4,x           ;|
    sta $45             ;/
    jml $02D718|!bank

RestoreActualPos:
    sbc $1C             ;\ Original code
    sta $01             ;/
    lda !E4,x           ;\ Set scratch ram here instead of later
    sta $0A             ;|
    lda !D8,x           ;|
    sta $0B             ;/
    lda !9E,x           ;\ Skip if rotating platform
    cmp #$A3            ;|
    beq +               ;/
    lda $48             ;\ Store actual ball position to sprite position addresses
    sta !14D4,x         ;|
    lda $46             ;|
    sta !14E0,x         ;|
    lda $47             ;|
    sta !D8,x           ;|
    lda $45             ;|
    sta !E4,x           ;/
+   jml $02D78B|!bank
