
;original extended sprite routine by imamelia
;slight modification and sa-1 compability by JackTheSpades

incsrc "sa1def.asm"
incsrc "pointer_caller.asm"

org $029B1B|!BankB
	JML Main
	dl Ptr      ; org $029B1F, default $176FBC

org $029633|!BankB
	autoclean JML CapeInteract
	dl CapePtr


freecode

CapeInteract:
.sub
	STX.w $15E9|!addr
	LDA $170B|!addr,x		; restore vanilla code
	CMP #!ExtendedOffset
	BCC .NotCustom
	SEC : SBC #!ExtendedOffset
	AND #$7F
	%CallExtCape(CapePtr)
	JML $029656|!BankB
	.NotCustom
	CMP #$02			; restore vanilla code and jml back
	JML $02963B|!BankB		
Main:
.sub
	LDY $9D               ; \
	BNE +                 ; | restore code
	LDY !extended_timer,x ; |
   BEQ +                 ; |
   DEC !extended_timer,x ; /
+
	CMP #!ExtendedOffset  ; check if number higher than #$13
	BCC .NotCustom        ;

	SEC
   SBC #!ExtendedOffset  ; 13 is the first custom one
	AND #$7F              ;	
	%CallSprite(Ptr)      ;
	JML $029B15|!BankB           ; JML back to an RTS
	
.NotCustom
	JML $029B27|!BankB           ; execute vanilla code.

;tool generated pointer table
Ptr:
	incbin "_ExtendedPtr.bin"

CapePtr:
	incbin "_ExtendedCapePtr.bin"