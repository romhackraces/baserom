@include

macro Speed()
    LDA #$00
    %ExtendedSpeed()
endmacro

macro SpeedNoGrav()
    LDA #$01
    %ExtendedSpeed()
endmacro

macro SpeedX()
    LDA #$02
    %ExtendedSpeed()
endmacro

macro SpeedY()
    LDA #$03
    %ExtendedSpeed()
endmacro

macro SetupCoords()
    lda !extended_x_low,x
    sta $04
    lda !extended_x_high,x
    sta $05
    lda !extended_y_low,x
    sta $06
    lda !extended_y_high,x
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