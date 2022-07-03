ORG $008E1A
	autoclean JML statusbar_main
	NOP

freecode

	statusbar_main:
		JSR status_bar_main
		LDA $1493|!addr
		ORA $9D
		JML $008E1F|!bank
