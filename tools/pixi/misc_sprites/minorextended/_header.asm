@include

macro SpeedX()
    lda #$00
    %MinorExtendedSpeed()
endmacro

macro SpeedY()
    lda #$02
    %MinorExtendedSpeed()
endmacro

macro SpeedXFast()
    lda #$01
    %MinorExtendedSpeed()
endmacro

macro SpeedYFast()
    lda #$03
    %MinorExtendedSpeed()
endmacro

macro SetupCoords()
    lda !minor_extended_x_low,x
    sta $04
    lda !minor_extended_x_high,x
    sta $05
    lda !minor_extended_y_low,x
    sta $06
    lda !minor_extended_y_high,x
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