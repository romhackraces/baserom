@include

macro SetupCoords()
    lda !smoke_x_low,x
    sta $04
    lda !smoke_x_high,x
    sta $05
    lda !smoke_y_low,x
    sta $06
    lda !smoke_y_high,x
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