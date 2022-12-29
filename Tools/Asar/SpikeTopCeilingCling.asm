if read1($00FFD5) == $23
	sa1rom
	!SA1 = 1
	!addr = $6000
	!long = $000000
else
	lorom
	!SA1 = 0
	!addr = $0000
	!long = $800000
endif

macro define_sprite_table(name, addr, addr_sa1)
	if !SA1 == 0
		!<name> = <addr>
	else
		!<name> = <addr_sa1>
	endif
endmacro

%define_sprite_table("164A", $164A, $75BA)
%define_sprite_table("151C", $151C, $3284)
%define_sprite_table("D8", $D8, $3216)
%define_sprite_table("AA", $AA, $9E)
%define_sprite_table("B6", $B6, $B6)
%define_sprite_table("C2", $C2, $D8)
%define_sprite_table("14D4", $14D4, $3258)
%define_sprite_table("1588", $1588, $334A)

org $0183FF
autoclean JML SpikeTopInit

freecode
reset bytes

SpikeTopInit:

PHB
PHK
PLB

STZ !164A,x
LDA !151C,x
EOR #$10
STA !151C,x

LDA !D8,x
STA $14B0|!addr
CLC
ADC #$03
STA !D8,x
LDA !14D4,x
STA $14B2|!addr
ADC #$00
STA !14D4,x

LDA !AA,x
STA $14B4|!addr
LDA !B6,x
STA $14B5|!addr

LDA #$08
STA !AA,x
JSL $019138|!long
LDA !1588,x
AND #$04
BEQ .NoGround
LDA !C2,x
AND #$FC
STA !C2,x
JMP .End2
.NoGround
LDA $14B0|!addr
SEC
SBC #$03
STA !D8,x
LDA $14B2|!addr
SBC #$00
STA !14D4,x
LDA #$F8
STA !AA,x
JSL $019138|!long
LDA !1588,x
AND #$08
BEQ .NoCeiling
LDA !C2,x
AND #$FC
ORA #$02
STA !C2,x
JMP .End2
.NoCeiling
.End
LDA $14B0|!addr
STA !D8,x
LDA $14B2|!addr
STA !14D4,x
.End2
LDA $14B4|!addr
STA !AA,x
LDA $14B5|!addr
STA !B6,x
PLB
JML $01841A|!long

print "Freespace used: ",bytes," bytes."
print "Next address: $",pc