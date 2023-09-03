; RandomSA1 - same as Random, but for code executing on the sa-1 cpu
; notes: this will only work on sa-1 ROMs that are currently executing on the sa-1 cpu
;        you must have already used %invoke_sa1() or similar before calling
;        this will work with a max of 0, but will wastefully generate a new random number
;
; Input:
;     A  : The maximum possible value
;
; Output:
;     A : a random number in the range [0, A] (inclusive)

?main:
    pha
    inc
    and $01,S
    beq ?.PowOf2                     ; max of the form 2^n - 1, so we can just use a bitwise and instead of a divide

?.Divide:
    lda #$01 : sta $2250            ; select division
    jsl $01ACF9|!bank               ; first byte in both A and $148C, second in $148D
    sta $2251                       ; dividend, low byte
    lda $148D|!addr : lsr           ; workaround for snes9x bug: https://github.com/snes9xgit/snes9x/issues/799
    sta $2252                       ; dividend, high byte
    pla : inc
    sta $2253                       ; divisor, low byte
    stz $2254                       ; divisor, high byte
    nop : bra $00                   ; wait 5 cycles
    lda $2308                       ; remainder, low byte
    rtl

?.PowOf2:
    jsl $01ACF9|!bank
    pla
    and $148C|!addr
    rtl
