incsrc "sa1def.asm"
macro revert(hijack, opcode, original)
    if read1(<hijack>) == <opcode>
        org <hijack>
            <original>
    endif
endmacro

%revert($02A963, $22, "AND #$0D : STA !14D4,x")
%revert($018172, $22, "LDA #$08 : STA !14C8,x")

if !sa1 == 0
    %revert($0185C3, $22, "STZ $1491|!addr : LDA !9E,x")
else
    %revert($0185C3, $22, "STZ $1491|!addr : LDA ($B4)")
endif

%revert($07F785, $22, "LDA #$01 : STA !15A0,x")
%revert($018151, $22, "LDA #$FF : STA !161A,x")
%revert($02A94B, $22, "AND #$0D : STA !14E0,x")
%revert($02A866, $5C, "CMP #$E7 : BCC $22")
%revert($02ABA0, $22, "LDA $04 : SEC : SBC #$C8")
%revert($02B395, $5C, "LDY $17AB|!addr : BEQ $0A")
%revert($02AFFE, $22, "LDA $18B9|!addr : BEQ $27")
%revert($0187A7, $5C, "JSL $02DA59|!bank")
%revert($018127, $5C, "LDA !14C8,x : BEQ $25")
%revert($02A9C9, $22, "JSL $07F7D2|!bank")
%revert($02A9A6, $22, "TAX : LDA $07F659|!bank,x")

if read4($01C089) == $7FAB10BF
    org $01C089
        LDA !14D4,x
        STA !187B,x
        AND #$01
        STA !14D4,x
endif

if read4($01D43E) == $6B813320
    org $01D43E
        STZ !14C8,x
        RTS
endif
