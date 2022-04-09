ORG $008E1A
	autoclean JML statusbar_main
	NOP

freecode

	statusbar_main:
		JSR status_bar_main
		LDA $1493|!addr
		ORA $9D
		JML $008E1F|!bank

namespace status_bar
; Note that since status bar code is just a single file, the code below should return with RTS.
; There is no such init or nmi label either.

main:
	RTS

namespace off
