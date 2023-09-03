@include

macro LDE()
	LDA !extra_bits,x
	AND #$04
endmacro

macro SetupCoords()
    lda !sprite_x_low,x
    sta $04
    lda !sprite_x_high,x
    sta $05
    lda !sprite_y_low,x
    sta $06
    lda !sprite_y_high,x
    sta $07
endmacro

macro SpawnMinorExtended()
    xba
    lda !sprite_off_screen_horz,x
    ora !sprite_off_screen_vert,x
    ora !sprite_being_eaten,x
    bne ?ret
    %SetupCoords()
	%SpawnMinorExtendedGeneric()
?ret 
endmacro

macro SpawnCluster()
    xba
    %SetupCoords()
	%SpawnClusterGeneric()
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