;;
;;;
;;; Capespin-in-Flight fix
;;;   by Beta Logic
;;;
;;
;;  This patch guarantees that you will flip directions if you capespin mid-flight.
;;    It requires freespace and 1 RAM address to function properly.
;;

; SA-1 compatibility
!dp = $0000
!addr = $0000
!sa1 = 0
if read1($00FFD5) == $23
    sa1rom
    !dp = $3000
    !addr = $6000
    !sa1 = 1
endif

;;
;; RAM address, for ease of understanding
  !powerUp    = $19
  !MarioDir   = $76
  !hasFlight  = $1407|!addr
  !capeSpin   = $14A6|!addr
; This is the (normally) unused RAM address used for this patch
; Be sure that this is an unused address for your ROM!!
  !flightDir  = $140B|!addr

;;
;; Hijacking rountines
org $00D076                   ; Here, we are hijacking the cape-spin setting routine
    NOP #5                    ;
org $00D076                   ;
    autoclean JSL CapeSpinFix ;

org $00CF3D                 ; Here, we are hijacking part of the spinning animation routine
    NOP #4                  ;     that deals with assigning mario's direction
org $00CF3D                 ;
    autoclean JSL SpinCheck ;

freecode
;;
;; Modified routines below

; This is called when you first press X/Y to capespin
CapeSpinFix:     ;;; Stores Mario's flipped direction for flight
LDA !MarioDir      ; > Load marios facing direction
LDY !capeSpin      ; \ If Mario is already spinning,
BEQ +              ; |
    LDA !flightDir ; |> Load the current flight direction
+                  ; /    instead
EOR #$01           ; \ Set the flight direction to be
STA !flightDir     ; /   opposite the loaded value
LDA #$12           ; \ Set the capespin timer to be 18
STA !capeSpin      ; /   (Restores overwritten code)
RTL                ; Return


; This next routine is called if Mario is spinning
; When called, A register contains Mario's direction for spinning based on a table
SpinCheck:       ;;; Sets Mario's direction if finished with a capespin mid-flight
LDY !hasFlight     ; \
BEQ +              ; | If Mario is in flight,
LDY !capeSpin      ; |
CPY #$01           ; |
BNE +              ; | And if the capespin timer is at 1,
    STZ !capeSpin  ; | Clear the capespin timer
    LDA !flightDir ; / And load the saved flight direction
+   STA !MarioDir  ; > Set Mario's direction to the loaded value
LDY !powerUp       ; (Restores overwritten code)
RTL                ; Return