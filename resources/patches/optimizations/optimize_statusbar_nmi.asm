if read1($00FFD5) == $23
    sa1rom
    !addr = $6000
else
    lorom
    !addr = $0000
endif

; Read these from ROM to account for DMA remap
!dma_reg #= read2($00A53F+1)
!dma_en  #= read1($00A55F+1)

; Hijack here to make it work with "RAM Toggled Status Bar"
; Code size: 50 bytes (leaves 18 free bytes at $008DE9)
; Code speed: about 0.78 scanlines faster (0.6 with FastROM enabled)
org $008DB1
    rep #$10
    ldx.w #$5042 : stx.w $2116
    ldx.w #$1800 : stx.w !dma_reg+0
    ldx.w #$0EF9|!addr : stx.w !dma_reg+2
    stz.w !dma_reg+4
    ldy.w #$001C : sty.w !dma_reg+5
    lda.b #!dma_en : sta.w $420B
    ldx.w #$5063 : stx.w $2116
    dey : sty.w !dma_reg+5
    sta.w $420B
    sep #$10
    rts

warnpc $008DF5
