; How many frames of cooldown to have ($00-$7F)
!cooldown = $08

; 1 byte of freeram
!freeram = $1DFD|!addr

; ON/OFF switch address
!switch = $14AF|!addr

init:
    ; Initialize the switch state backup
    lda !switch : lsr : ror : sta !freeram
    rtl

main:
    ; If the game is frozen, return
    lda $9D : ora $13D4|!addr : bne .return

    ; If we're in not in cooldown, check if the state changed
    lda !freeram : bit #$7F : beq .check_switched

.cooldown:
    ; Tick the timer
    dec : sta !freeram

    ; Keep the state constant
    asl : lda #$00 : rol : sta $14AF|!addr
    rtl

.check_switched:
    ; If the state is the same as the backup, return
    and #$80 : asl : rol
    cmp !switch : beq .return

.init_cooldown:
    ; Set the new state and the cooldown timer
    eor #$01 : lsr : ror
    ora.b #!cooldown
    sta !freeram

.return:
    rtl
