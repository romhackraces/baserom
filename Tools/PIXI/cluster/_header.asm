@include

macro LDE()
	LDA !cluster_num,y
	AND #$80
endmacro

macro SetupCoords()	
    lda !cluster_x_low,x
    sta $04
    lda !cluster_x_high,x
    sta $05
    lda !cluster_y_low,x
    sta $06
    lda !cluster_y_high,x
    sta $07
endmacro

macro SpawnExtendedAlt()
    xba
    %SetupCoords()
	%SpawnExtendedGeneric()
endmacro

macro SpawnSmokeAlt()
    xba
    %SetupCoords()
	%SpawnSmokeGeneric()
endmacro

macro SpawnCluster()
    xba
    %SetupCoords()
	%SpawnClusterGeneric()
endmacro

macro SpawnMinorExtended()
    xba
    %SetupCoords()
	%SpawnMinorExtendedGeneric()
endmacro

macro SpawnSpinningCoin()
    xba
    %SetupCoords()
	%SpawnSpinningCoinGeneric()
endmacro

macro SpawnScore()
    xba
    %SetupCoords()
	%SpawnScoreGeneric()
endmacro