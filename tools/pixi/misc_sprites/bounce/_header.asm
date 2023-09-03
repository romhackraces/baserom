@include

macro RevertMap16()
    lda !bounce_map16_tile,x
    sta $9C
    %BounceSetupMap16()
    phx
    jsl $00BEB0|!BankB
    plx
endmacro

macro InvisibleMap16()
    lda #$09
    sta $9C
    %BounceSetupMap16()
    phx
    jsl $00BEB0|!BankB
    plx
endmacro

macro SetSpeed() 
    %BounceSetSpeed()
endmacro

macro SetMarioSpeed()
    %BounceSetMarioSpeed()
endmacro

macro UpdatePos()
    %BounceUpdatePos()
endmacro

macro EraseCoinAbove()
    phk
    pea.w ?label-1
    pea.w $B888
    jml $029265|!BankB
?label
endmacro

macro SetupCoords()
    lda !bounce_x_low,x
    sta $04
    lda !bounce_x_high,x
    sta $05
    lda !bounce_y_low,x
    sta $06
    lda !bounce_y_high,x
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