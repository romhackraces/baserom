; Random - gets a random number in a range
; notes: this must not be called if executing on the sa-1 side, otherwise it won't work
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
    jsl $01ACF9|!bank               ; first byte in both A and $148C, second in $148D
    sta $4204                       ; dividend, low byte
    lda $148D|!addr : sta $4205     ; dividend, high byte
    pla : inc
    sta $4206                       ; divisor -- now wait at least 16 cycles
    nop #8
    lda $4216                       ; remainder, low byte (why is there even a high byte when the divisor is max 255 anyway!?)
    rtl

?.PowOf2:
    jsl $01ACF9|!bank
    pla
    and $148C|!addr
    rtl
