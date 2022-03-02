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
