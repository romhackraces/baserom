; Adapted from Lui's "Remove Status Bar" patch

if !remove_vanilla_status_bar

pushpc

org $0081F4
    bra $01 : db $69

org $008275
    jml nmi_hijack : db $69

org $0082E8
    bra $01 : db $69

org $00985A
    bra $01 : db $69

org $00A5A8
    bra $01 : db $69

pullpc

nmi_hijack:
    lda $0D9B|!addr : bne .special
if !sa1
    ldx #$81
else
    lda #$81 : sta $4200
endif
    lda $22 : sta $2111
    lda $23 : sta $2111
    lda $24 : sta $2112
    lda $25 : sta $2112
    lda $3E : sta $2105
    lda $40 : sta $2131
    jml $0082B0|!bank
.special:
    jml $00827A|!bank

else

pushpc

if read1($0081F4+2) == $69
org $0081F4
    jsr $8DAC
endif

if read1($008275+4) == $69
org $008275
    lda $0D9B|!addr
    beq $18
endif

if read1($0082E8+2) == $69
org $0082E8
    jsr $8DAC
endif

if read1($00985A+2) == $69
org $00985A
    jsr $8CFF
endif

if read1($00A5A8+2) == $69
org $00A5A8
    jsr $8CFF
endif

pullpc

endif
