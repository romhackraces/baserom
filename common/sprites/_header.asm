@include

macro LDE()
	LDA !extra_bits,x
	AND #$04
endmacro
