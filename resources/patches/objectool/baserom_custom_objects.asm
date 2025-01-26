
incsrc "callisto.asm"
%import_library("freeram.asm")

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; code for extended objects 98-CF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; See tools/uberasmtool/library/uberasm_objects.asm for how these are used
CustExObj98:
CustExObj99:
CustExObj9A:
CustExObj9B:
CustExObj9C:
CustExObj9D:
CustExObj9E:
CustExObj9F:
CustExObjA0:
CustExObjA1:
CustExObjA2:
CustExObjA3:
CustExObjA4:
CustExObjA5:
CustExObjA6:
CustExObjA7:
CustExObjA8:
CustExObjA9:
CustExObjAA:
CustExObjAB:
CustExObjAC:
CustExObjAD:
CustExObjAE:
CustExObjAF:
CustExObjB0:
CustExObjB1:
CustExObjB2:
CustExObjB3:
CustExObjB4:
CustExObjB5:
CustExObjB6:
CustExObjB7:
CustExObjB8:
CustExObjB9:
CustExObjBA:
CustExObjBB:
CustExObjBC:
CustExObjBD:
CustExObjBE:
CustExObjBF:
CustExObjC0:
CustExObjC1:
CustExObjC2:
CustExObjC3:
CustExObjC4:
CustExObjC5:
CustExObjC6:
CustExObjC7:
CustExObjC8:
CustExObjC9:
CustExObjCA:
CustExObjCB:
CustExObjCC:
CustExObjCD:
CustExObjCE:
CustExObjCF:
CustExObjD0:
CustExObjD1:
CustExObjD2:
CustExObjD3:
CustExObjD4:
CustExObjD5:
CustExObjD6:
CustExObjD7:
CustExObjD8:
CustExObjD9:
CustExObjDA:
CustExObjDB:
CustExObjDC:
CustExObjDD:
CustExObjDE:
CustExObjDF:
.set_object_flag
    TXA             ; get 2 * object number from X
    LSR             ; divide by 2 since X was a word index
    TAY             ; cache in Y
    LSR #3          ; divide by 8 since we have 8 bits/flags per byte
    TAX             ; use as index into the FreeRAM later
    TYA             ; restore object number from Y
    AND #$07        ; modulo 8 since we have 8 bits/flags per byte
    TAY             ; use result as loop variable
    LDA ..masks,y   ; load correct bit mask for corresponding bit
    ORA !objectool_level_flags_bank,x   ; account for previously set flags
    STA !objectool_level_flags_bank,x   ; store flag byte
    RTS

..masks
    db 1,2,4,8,16,32,64,128
