@include

macro LDE()
	LDA !cluster_num,y
	AND #$80
endmacro
