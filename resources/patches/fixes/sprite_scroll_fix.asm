incsrc "callisto.asm"
%import_library("freeram.asm")

!Displacement = 0
;^Set this  to 1 if you wanted to use a number that is the amount of pixels
;the screen has been moved.

!Freeram_PrevPos = !scroll_fix_freeram_bank
;^[4 bytes], determines direction from its previous position. The first
;two bytes are for X position, and the last two are for the Y. When working
;with ASM to control the screen (by changing $7E1462 and $7E1464), DO NOT
;modify this value, you'll end up with sprites not spawning during the
;frame its modified. Note that this freeram is NOT auto-converted to SA-1
;(in case you wanted to use freeram addresses created by SA-1).

!Freeram_ScrnDisplace = !scroll_fix_freeram_bank+4
;[4 bytes], this ram is used if !Displacement is set to 1. This ram address
;holds the amount of pixels the screen has moved. Format:
;-First 2 bytes = moved horizontally
;-Last 2 = vertical.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SA1 detector:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if read1($00FFD5) == $23
    !SA1 = 1
    sa1rom
else
    !SA1 = 0
endif

; Example usage
if !SA1
    ; SA-1 base addresses
    !Base1 = $3000      ;>$0000-$00FF -> $3000-$30FF
    !Base2 = $6000      ;>$0100-$0FFF -> $6100-$6FFF and $1000-$1FFF -> $7000-$7FFF
    !FastROM = $000000
else
    ; Non SA-1 base addresses
    !Base1 = $0000
    !Base2 = $0000
    !FastROM = $800000
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Hijack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
org $00F728             ;>Routine that depends on mario's x pos on-screen that sets $55/$56.
    bra +
    nop #2
+

org $00F80C             ;>Routine that depends on mario's y pos on-screen that sets $55/$56.
    bra +
    nop #2
+

org $00F713             ;>Where mario scrolls the screen horizontally
    autoclean JML BetterScrollX
    nop #1

org $00F7F4             ;>Where mario scrolls the screen vertically.
    autoclean JML BetterScrollY ;>(they left out $13F1, I think...)
    nop #1

freedata
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;code to be inserted to freespace
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BetterScrollX:
    LDX #$00
    JSR ScrollSub

    LDY $1411+!Base2     ;\Restore code.
    BEQ +                ;|
    JML $00F718|!FastROM ;|
+   JML $00F79D|!FastROM ;/

BetterScrollY:
    LDX #$02             ;\Use routine
    JSR ScrollSub        ;/

    LDX $1412+!Base2        ;\restore code
    BNE +                   ;|
    JML $00F7F9|!FastROM    ;>You cannot RTS on freespace if JML (must end on correct bank).
+   JML $00F7FA|!FastROM    ;/

ScrollSub:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Input:
;X=#$00 for x position
;X=#$02 for y position
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    PHA                             ;>Save A
    LDA $1462+!Base2,x              ;>Load final position
    if !Displacement == 0
        CMP !Freeram_PrevPos,x               ;>Compare (CMP actually subtracts without effecting A) with inital pos.
    else
        SEC                         ;\Subtract by previous to find the amount of change in position
        SBC !Freeram_PrevPos,x               ;/(the delta symbol in math)
        STA !Freeram_ScrnDisplace,x ;>Store displacement into RAM
    endif
    BEQ .DidntScroll                ;>If result is zero, the screen didn't scroll and leave $55/$56 as is.
    BPL .ScrollRightDown            ;>if positive (right and/or down), set $55/$56 to #$02
;.ScrollLeftUp                       ;>Otherwise, if negative (left and/or up), set $55/$56 to #$00
    LDA #$0000                      ;>load #$00 (up/left value)
    BRA +

.ScrollRightDown
    LDA #$0202                      ;>Load #$02 (right/down value)
+
    STA $55                         ;>Store on $55 and $56
    LDA $1462+!Base2,x              ;\Update so that in case if the
    STA !Freeram_PrevPos,x          ;/screen scroll again on the 3rd frame.
.DidntScroll
    PLA                             ;>Restore A
    RTS

if read1($0FFFE6) == $FF || read1($0FFFE6) == $00
    error "You need to insert Lunar Magic's VRAM patch before inserting this patch!"
endif
