; Level data clearing optimization by freeplay
;
; Replaces original xx:c800-xx:ffff clearing code with faster alternative.
; - DMA used for SA-1.
; - DMA not used for lorom due to rev1 CPU bug and potential use of HDMA outside of force blank.

if read1($00ffd5) == $23
    sa1rom
    !sa1 = 1
    !bank = $000000
    !dp = $3000
    !addr = $6000
    !ram = $400000
else
    lorom
    !sa1 = 0
    !bank = $800000
    !dp = $0000
    !addr = $0000
    !ram = $7e0000
endif

org $058076
    autoclean jml ClearLevel
!rjmlClearLevel_058076 = $058089|!bank

freecode

!levelBase = $c800
!pages = ($10000-$c800)/$100
!clearMap16 = $0025

ClearLevel:

if !sa1

!scratch = $3100
!blockSize = $20
!currentAddress = $3120

    ldx.w #.sa1
    stx $3180
    lda.b #.sa1>>16
    sta $3182
    jsr $1e80

    jml !rjmlClearLevel_058076

.sa1
    sep #$10
    rep #$21

    ldx.b #$40
    stx.w !currentAddress+2

    lda.w #!clearMap16<<8|(!clearMap16&$ff)

.loop
    ldy.b #!blockSize-2

.loopSetup
    sta.w !scratch,y
    dey #2
    bpl .loopSetup

    lda.w #!levelBase
    bra .loopDMAEntry

.loopDMA
    adc.w #!blockSize

.loopDMAEntry
    sta !currentAddress
    sta $2235

    lda.w #!blockSize
    sta $2238    

; I-RAM -> BW-RAM
    ldx.b #$c6
    stx $2230

    lda.w #!scratch
    sta $2232

    ldx.w !currentAddress+2
    stx $2237

.wait
    ldx $318c
    beq .wait

    ldx #$00
    stx $318c
    stx $2230

; Next 32 byte block.
    lda !currentAddress
    bne .loopDMA

; Next bank?
    ldx.w !currentAddress+2
    cpx #$41
    beq .exit

    inx
    stx.w !currentAddress+2
    lda.w #!clearMap16&$ff00|(!clearMap16>>8) 
    bra .loop

.exit
    sep #$20
    rtl

else ; lorom

    rep #$20
    sep #$10

    phb
    ldy.b #!ram>>16
    ldx #$00
    lda.w #!clearMap16<<8|(!clearMap16&$ff)
.loopOuter
    phy
    plb
.loopInner
for i = 0..!pages
    sta.w !levelBase+(!i*$100),x
endfor
    inx #2
    beq +
    jmp .loopInner

+   iny
    bmi +

    lda.w #!clearMap16&$ff00|(!clearMap16>>8)
    jmp .loopOuter

+   plb

    sep #$20
    rep #$10

    jml !rjmlClearLevel_058076

endif
