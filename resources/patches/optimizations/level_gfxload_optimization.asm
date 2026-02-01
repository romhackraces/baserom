; Level graphics loading optimization by freeplay
;
; Replaces main GFX upload with faster DMA alternative.
; Lunar Magic must be used to insert GFX first for 3bpp->4bpp graphics conversion.

if read1($00ffd5) == $23
    sa1rom
    !sa1 = 1
    !bank = $000000
    !dp = $3000
    !addr = $6000
else
    lorom
    !sa1 = 0
    !bank = $800000
    !dp = $0000
    !addr = $0000
endif

; Don't patch if 3bpp code is still there.

!patchSignature = read2($00aacd)
if !patchSignature == $07a2
    error "Found original 3bpp GFX code instead of 4bpp. Insert GFX using Lunar Magic first."
elseif !patchSignature == $10a2
    ; Found expected 4bpp code.
else
    error "Unexpected code found when checking GFX code. Applying this patch could cause bugs."
endif

org $00aa80
    autoclean jml Upload
!rjmlUploadCheck_aa80_return = $00aaff|!bank

freecode

!dmaBase = $4320
!dmaEnable = 1<<((!dmaBase>>4)&$0f)

; This also runs on SNES side when using SA-1 pack.

Upload:
    rep #$10

    ldy.w #$1801
    sty !dmaBase

    ldy $00
    sty.w !dmaBase+2
    lda $02
    sta.w !dmaBase+4

    ldy.w #$1000
    sty.w !dmaBase+5

    lda.b #!dmaEnable
    sta $420b

    sep #$10
    jml !rjmlUploadCheck_aa80_return
