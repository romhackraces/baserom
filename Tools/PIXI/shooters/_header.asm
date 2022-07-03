@include

macro LDE()
	LDA !shoot_num,x
	AND #$40
endmacro
