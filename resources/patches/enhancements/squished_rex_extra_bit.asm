; squishyrex.asm by Supermario1313
;
; Makes rexes with extra bit set to 1 to spawn squished.
;
; Thanks to imamelia for his rex disassembly and to the SMWDisC Team for SMWDisC.txt.

; If set to 0, this patch won't hijack the init code of clappin' chucks. This can fix conflict issues with other patches. Needs 16 free bytes in bank $01.
!hijack = 1
; Should point to 16 free bytes in bank $01. The default value ($01FFBF) works for an unmodified SMW rom.
!bank01freespace = $01FFBF

; Taken from PIXI's sa1def.asm
if read1($00FFD5) == $23
	sa1rom
	!bank = $000000
    !miscTable = $D8
	!clipping = $75EA
	!extraBits = $400040
	!spriteNumber = $3200
else
	lorom
	!bank = $800000
	!miscTable = $C2
	!clipping = $1662
	!extraBits = $7FAB10
	!spriteNumber = $9E
endif

; Rex init code
macro rexInit()
		LDA !extraBits,x					; / If the extra bit isn't set,
		AND #$04							; \
		BEQ ?Finalize						; Don't squish the rex.

		INC !miscTable,x					; Set the rex state to squished.
		STZ !clipping,x						; Change the sprite clipping.

	?Finalize:								; Run the FaceMario routine.

	if !hijack
		JML $01857C|!bank
	else
		JMP $857C							; Custom init code is in bank $01 so a JMP is sufficient (saves one byte and one CPU cycle compared to a JML).
	endif
endmacro

if !hijack
	ORG $0182D3								; Rex init function pointer...
		dw $84E9							; ...Replaced by clappin' chuck's init function pointer.

	ORG $0184E9
		AUTOCLEAN JML ClappinChuckHijack	; A JML is 4 bytes large while clappin' chuck's init function is 4 bytes large. Everything adds up.

	FREECODE
	ClappinChuckHijack:
		LDA !spriteNumber,x
		CMP #$AB							; If the sprite is a rex...
		BEQ RexInit							; ...Run the rex init code.

		LDA #$08							; / Clappin' chuck init code
		JML $01851A|!bank					; \
	RexInit:
		%rexInit()

else
	ORG $0182D3								; Rex init function pointer
		dw !bank01freespace					; Replaced by a pointer to my custom code
	ORG !bank01freespace					; We write the custom rex init code in a free area of bank $01.
		%rexInit()
endif
