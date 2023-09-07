; Fixes how NMI is turned on, which can make HDMAs malfunction for a frame after e.g. level loading.
; by spooonsss

; When NMI is re-enabled during vblank, NMI fires immediately. If this happens on a late scanline,
; we may run org $0082B9: STA $420C after the next frame has already started.

if read1($00FFD5) == $23        ; check if the rom is sa-1
    !bank = $000000
else
    !bank = $800000
endif

org $0093F7
autoclean JML hijack

freecode

hijack:
    LDA $4210                   ; "If one does disable and re-enable NMIs, then an old NMI may be executed again; acknowledging avoids that effect."
    LDA.b #$81                  ;$0093F7    |\ Enable NMI and auto-joypad reading.
    STA.w $4200                 ;$0093F9    |/
    JML $0093FC|!bank
    ;RTS                       ;$0093FC    |
