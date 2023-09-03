

; Format: 5 bytes per music instrument.
; Byte 0: Sample (SCRN) number
; Byte 1: ADSR 1 / GAIN
; Byte 2: ADSR 2
; Byte 3: GAIN
; Byte 4: Tuning
; Byte 5: Subtuning

;org $5F46
;base $5F46
InstrumentTable:
db $00, $FE, $6A, $B8, $06, $00
db $01, $FA, $6A, $B8, $03, $00
db $02, $AE, $2F, $B8, $04, $00
db $03, $FE, $6A, $B8, $03, $00
db $04, $A9, $6A, $B8, $03, $00
db $07, $AE, $26, $B8, $07, $00
db $08, $FA, $6A, $B8, $03, $00
db $09, $9E, $1F, $B8, $03, $00
db $05, $AE, $26, $B8, $1E, $00
db $0A, $EE, $6A, $B8, $02, $00
db $0B, $FE, $6A, $B8, $08, $00
db $01, $F7, $6A, $B8, $03, $00
db $10, $0E, $6A, $7F, $04, $00
db $0C, $FE, $6A, $B8, $03, $00
db $0D, $AE, $26, $B8, $07, $00
db $12, $8E, $E0, $B8, $03, $00
db $0C, $FE, $70, $B8, $03, $00
db $11, $FE, $6A, $B8, $05, $00
db $01, $E9, $6A, $B8, $03, $00
db $0F, $0F, $6A, $7F, $03, $00

; Format: 6 bytes per percussion instrument.
; Byte 0: Sample (SCRN) number
; Byte 1: ADSR 1 / GAIN
; Byte 2: ADSR 2
; Byte 3: GAIN
; Byte 4: Tuning
; Byte 5: Subtuning
; Byte 6: Pitch

;org $5FA5
;base $5FA5
PercussionTable:
db $0F, $0F, $6A, $7F, $03, $00, $A8 
db $06, $0E, $6A, $40, $07, $00, $A4 
db $06, $8C, $E0, $70, $07, $00, $A1 
db $0E, $FE, $6A, $B8, $07, $00, $A4
db $0E, $FE, $6A, $B8, $08, $00, $A4
db $0B, $FE, $6A, $B8, $02, $00, $9C
db $0B, $7E, $6A, $7F, $08, $00, $A6
db $0B, $7E, $6A, $30, $08, $00, $A6
db $0E, $0E, $6A, $7F, $03, $00, $A1

if !noSFX = !false
; Format: 9 bytes per sample instrument.
; Byte 0: Left volume
; Byte 1: Right volume
; Byte 2: Starting pitch 1
; Byte 3: Starting pitch 2
; Byte 4: Sample (SRCN) number
; Byte 5: ADSR 1 / GAIN
; Byte 6: ADSR 2
; Byte 7: GAIN
; Byte 8: Tuning

;org $5570
;base $5570
SFXInstrumentTable:
db $70, $70, $00, $10, $06, $DF, $E0, $B8, $02 
db $70, $70, $00, $10, $00, $FE, $0A, $B8, $03 
db $70, $70, $00, $10, $03, $FE, $11, $B8, $03 
db $70, $70, $00, $10, $04, $FE, $6A, $B8, $03 
db $70, $70, $00, $10, $00, $FE, $11, $B8, $03 
db $70, $70, $00, $10, $08, $FE, $6A, $B8, $03 
db $70, $70, $00, $10, $02, $FE, $6A, $B8, $06 
db $70, $70, $00, $10, $06, $FE, $6A, $B8, $05 
db $70, $70, $00, $10, $00, $CA, $D7, $B8, $03 
db $70, $70, $00, $10, $10, $0E, $6A, $7F, $04 
db $70, $70, $00, $10, $0B, $FE, $6A, $B8, $02 
db $70, $70, $00, $10, $0B, $FF, $E0, $B8, $05 
db $70, $70, $00, $10, $0E, $FE, $00, $7F, $06 
db $70, $70, $00, $10, $00, $B6, $30, $30, $06 
db $70, $70, $00, $10, $12, $0E, $6A, $70, $03 
db $70, $70, $00, $10, $01, $FA, $6A, $70, $03 
db $70, $70, $00, $10, $02, $FE, $16, $70, $03 
db $70, $70, $00, $10, $13, $0E, $16, $7F, $03 
db $70, $70, $00, $10, $02, $FE, $33, $7F, $03 
endif