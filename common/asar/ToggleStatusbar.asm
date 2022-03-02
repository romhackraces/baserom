;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Toggle Statusbar by dtothefourth
;
; This patch allows the status bar to be hidden 
; but still functional and be toggled by UberASM
; or by setting a RAM flag
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


!Toggle = $1FFA|!base2 ;FreeRAM cleared on level load

lorom

if read1($00FFD5) == $23
	sa1rom
	!sa1 = 1
	!base2 = $6000
    !BankB = $000000
    !Bank  = $00
else
	!sa1 = 0
	!base2 = $0000
    !BankB = $800000
    !Bank  = $80
endif


macro localJSL(dest, rtlop, db)
	PHB			;first save our own DB
	PHK			;first form 24bit return address
	PEA.w ?return-1
	PEA.w <rtlop>-1		;second comes 16bit return address
	PEA.w <db><<8|<db>	;change db to desired value
	PLB
	PLB
	JML <dest>
?return:
	PLB			;restore our own DB
endmacro

org $0081F2			; JSR $008DAC
	autoclean JSL Draw1
    NOP

org $0082E8			; JSR $008DAC
	autoclean JSL Draw2
    NOP #2

org $008275
    autoclean JML IRQ
    NOP

org $008DAC
    autoclean JML DMA
    NOP


org $008CFF
    autoclean JML DMA04
    NOP



freecode


    DMA:
        LDA !Toggle
        BNE +
        JML $008DE6|!BankB
        +
        STZ $2115
        LDA #$42
        JML $008DB1|!BankB

    Draw1:
        BCS +
        LDA !Toggle
        BEQ +

        %localJSL($008DAC|!BankB, $F3B1, $00|!Bank)

        +
        LDA $13C6|!base2
        RTL

    Draw2:
        LDA !Toggle
        BEQ +

        %localJSL($008DAC|!BankB, $F3B1, $00|!Bank)

        +
        %localJSL($00A488|!BankB, $F3B1, $00|!Bank)
        RTL        

    IRQ:
        LDA $0100|!base2
        CMP #$0B
        BEQ +
        CMP #$0F
        BCC ++
        CMP #$15
        BCC +
        ++
        LDA #$01
        STA !Toggle
        +

        LDA !Toggle
        BNE +

        LDY $0DAE|!base2
        STY $2100       
        LDY $0D9F|!base2 
        STY $420C       

        LDA #$A1
        STA $4200
        JML $008394|!BankB

        +

        LDA $0D9B|!base2
        BEQ +

        JML $00827A|!BankB

        +
        JML $008292|!BankB

!HW_INIDISP = $2100
!HW_OBJSEL = $2101
!HW_OAMADD = $2102
!HW_OAMDATA = $2104
!HW_BGMODE = $2105
!HW_MOSAIC = $2106
!HW_BG1SC = $2107
!HW_BG2SC = $2108
!HW_BG3SC = $2109
!HW_BG4SC = $210A
!HW_BG12NBA = $210B
!HW_BG34NBA = $210C
!HW_BG1HOFS = $210D
!HW_BG1VOFS = $210E
!HW_BG2HOFS = $210F
!HW_BG2VOFS = $2110
!HW_BG3HOFS = $2111
!HW_BG3VOFS = $2112
!HW_BG4HOFS = $2113
!HW_BG4VOFS = $2114
!HW_VMAINC = $2115
!HW_VMADD = $2116
!HW_VMDATA = $2118
!HW_M7SEL = $211A
!HW_M7A = $211B
!HW_M7B = $211C
!HW_M7C = $211D
!HW_M7D = $211E
!HW_M7X = $211F
!HW_M7Y = $2120
!HW_CGADD = $2121
!HW_CGDATA = $2122
!HW_W12SEL = $2123
!HW_W34SEL = $2124
!HW_WOBJSEL = $2125
!HW_WH0 = $2126
!HW_WH1 = $2127
!HW_WH2 = $2128
!HW_WH3 = $2129
!HW_WBGLOG = $212A
!HW_WOBJLOG = $212B
!HW_TM = $212C
!HW_TS = $212D
!HW_TMW = $212E
!HW_TSW = $212F
!HW_CGSWSEL = $2130
!HW_CGADSUB = $2131
!HW_COLDATA = $2132
!HW_SETINI = $2133
!HW_MPY = $2134
!HW_SLHV = $2137
!HW_ROAMDATA = $2138
!HW_RVMDATA = $2139
!HW_RCGDATA = $213B
!HW_OPHCT = $213C
!HW_OPVCT = $213D
!HW_STAT77 = $213E
!HW_STAT78 = $213F
!HW_APUIO0 = $2140
!HW_APUIO1 = $2141
!HW_APUIO2 = $2142
!HW_APUIO3 = $2143

!HW_WMDATA = $2180
!HW_WMADD = $2181

!HW_JOY1 = $4016
!HW_JOY2 = $4017

!HW_NMITIMEN = $4200
!HW_WRIO = $4201
!HW_WRMPYA = $4202
!HW_WRMPYB = $4203
!HW_WRDIV = $4204
!HW_WRDIVB = $4206
!HW_HTIME = $4207
!HW_VTIME = $4209
!HW_MDMAEN = $420B
!HW_HDMAEN = $420C
!HW_MEMSEL = $420D
!HW_RDNMI = $4210
!HW_TIMEUP = $4211
!HW_HVBJOY = $4212
!HW_RDIO = $4213
!HW_RDDIV = $4214
!HW_RDMPY = $4216
!HW_CNTRL1 = $4218
!HW_CNTRL2 = $421A
!HW_CNTRL3 = $421C
!HW_CNTRL4 = $421E

!HW_DMAPARAM = $4300
!HW_DMAREG = $4301
!HW_DMAADDR = $4302
!HW_DMACNT = $4305
!HW_HDMABANK = $4307
!HW_DMAIDX = $4308
!HW_HDMALINES = $430A
!StatusBar = $7E0EF9

    DMA04:
        LDA #$80
        STA $2115

        LDA !Toggle
        BEQ +
        JML $008D04|!BankB
        +

        LDA.B #$80                                ;;8C94|8CFF+8CFF/8CFF\8D01; More DMA ; Accum (8 bit) 
        STA.W !HW_VMAINC                          ;;8C96|8D01+8D01/8D01\8D03; Increment when $2119 accessed ; VRAM Address Increment Value
        LDA.B #$2E                                ;;8C99|8D04+8D04/8D04\8D06; \VRAM address = #$502E 
        STA.W !HW_VMADD                           ;;8C9B|8D06+8D06/8D06\8D08;  | ; Address for VRAM Read/Write (Low Byte)
        LDA.B #$50                                ;;8C9E|8D09+8D09/8D09\8D0B;  | 
        STA.W !HW_VMADD+1                         ;;8CA0|8D0B+8D0B/8D0B\8D0D; / ; Address for VRAM Read/Write (High Byte)
        LDX.B #$06                                ;;8CA3|8D0E+8D0E/8D0E\8D10;
        - LDA.L DATA_008D90,X                       ;;8CA5|8D10+8D10/8D10\8D12;
        STA.W !HW_DMAPARAM+$10,X                  ;;8CA8|8D13+8D13/8D13\8D15; Load up the DMA regs 
        DEX                                       ;;8CAB|8D16+8D16/8D16\8D18; DMA Source = 8C:8118 (...) 
        BPL -                                     ;;8CAC|8D17+8D17/8D17\8D19; Dest = $2118, Transfer: #$08 bytes 
        LDA.B #$02                                ;;8CAE|8D19+8D19/8D19\8D1B;
        STA.W !HW_MDMAEN                          ;;8CB0|8D1B+8D1B/8D1B\8D1D; Do the DMA ; Regular DMA Channel Enable
        LDA.B #$80                                ;;8CB3|8D1E+8D1E/8D1E\8D20; \ Set VRAM mode = same as above 
        STA.W !HW_VMAINC                          ;;8CB5|8D20+8D20/8D20\8D22;  |Address = #$5042 ; VRAM Address Increment Value
        LDA.B #$42                                ;;8CB8|8D23+8D23/8D23\8D25;  | 
        STA.W !HW_VMADD                           ;;8CBA|8D25+8D25/8D25\8D27;  | ; Address for VRAM Read/Write (Low Byte)
        LDA.B #$50                                ;;8CBD|8D28+8D28/8D28\8D2A;  | 
        STA.W !HW_VMADD+1                         ;;8CBF|8D2A+8D2A/8D2A\8D2C; /  ; Address for VRAM Read/Write (High Byte)
        LDX.B #$06                                ;;8CC2|8D2D+8D2D/8D2D\8D2F; \ Set up more DMA 
        - LDA.L DATA_008D97,X                       ;;8CC4|8D2F+8D2F/8D2F\8D31;  |Dest = $2100 
        STA.W !HW_DMAPARAM+$10,X                  ;;8CC7|8D32+8D32/8D32\8D34;  |Fixed source address = $89:1801 (Lunar Address: 7E:1801) 
        DEX                                       ;;8CCA|8D35+8D35/8D35\8D37;  |#$808C bytes to transfer 
        BPL -                                     ;;8CCB|8D36+8D36/8D36\8D38; /Type = One reg write once 
        LDA.B #$02                                ;;8CCD|8D38+8D38/8D38\8D3A;
        STA.W !HW_MDMAEN                          ;;8CCF|8D3A+8D3A/8D3A\8D3C; Start DMA ; Regular DMA Channel Enable
        LDA.B #$80                                ;;8CD2|8D3D+8D3D/8D3D\8D3F; \prep VRAM for another write 
        STA.W !HW_VMAINC                          ;;8CD4|8D3F+8D3F/8D3F\8D41;  | ; VRAM Address Increment Value
        LDA.B #$63                                ;;8CD7|8D42+8D42/8D42\8D44;  | 
        STA.W !HW_VMADD                           ;;8CD9|8D44+8D44/8D44\8D46;  | ; Address for VRAM Read/Write (Low Byte)
        LDA.B #$50                                ;;8CDC|8D47+8D47/8D47\8D49;  | 
        STA.W !HW_VMADD+1                         ;;8CDE|8D49+8D49/8D49\8D4B; / ; Address for VRAM Read/Write (High Byte)
        LDX.B #$06                                ;;8CE1|8D4C+8D4C/8D4C\8D4E; \ Load up DMA again 
        - LDA.L DATA_008D9E,X                       ;;8CE3|8D4E+8D4E/8D4E\8D50;  |Dest = $2118 
        STA.W !HW_DMAPARAM+$10,X                  ;;8CE6|8D51+8D51/8D51\8D53;  |Source Address = $39:8CC1 
        DEX                                       ;;8CE9|8D54+8D54/8D54\8D56;  |Size = #$0100 bytes 
        BPL -                                     ;;8CEA|8D55+8D55/8D55\8D57; /Type = Two reg write once 
        LDA.B #$02                                ;;8CEC|8D57+8D57/8D57\8D59; \Start Transfer 
        STA.W !HW_MDMAEN                          ;;8CEE|8D59+8D59/8D59\8D5B; / ; Regular DMA Channel Enable
        LDA.B #$80                                ;;8CF1|8D5C+8D5C/8D5C\8D5E; \ 
        STA.W !HW_VMAINC                          ;;8CF3|8D5E+8D5E/8D5E\8D60;  |Set up VRAM once more ; VRAM Address Increment Value
        LDA.B #$8E                                ;;8CF6|8D61+8D61/8D61\8D63;  | 
        STA.W !HW_VMADD                           ;;8CF8|8D63+8D63/8D63\8D65;  | ; Address for VRAM Read/Write (Low Byte)
        LDA.B #$50                                ;;8CFB|8D66+8D66/8D66\8D68;  | 
        STA.W !HW_VMADD+1                         ;;8CFD|8D68+8D68/8D68\8D6A; / ; Address for VRAM Read/Write (High Byte)
        LDX.B #$06                                ;;8D00|8D6B+8D6B/8D6B\8D6D; \Last DMA... 
        - LDA.L DATA_008DA5,X                       ;;8D02|8D6D+8D6D/8D6D\8D6F;  |Reg = $2118 Type = Two reg write once 
        STA.W !HW_DMAPARAM+$10,X                  ;;8D05|8D70+8D70/8D70\8D72;  |Source Address = $08:8CF7 
        DEX                                       ;;8D08|8D73+8D73/8D73\8D75;  |Size = #$9C00 bytes (o_o) 
        BPL -                                     ;;8D09|8D74+8D74/8D74\8D76; / 
        LDA.B #$02                                ;;8D0B|8D76+8D76/8D76\8D78; \Transfer 
        STA.W !HW_MDMAEN                          ;;8D0D|8D78+8D78/8D78\8D7A; / ; Regular DMA Channel Enable
        LDX.B #$36                                ;;8D10|8D7B+8D7B/8D7B\8D7D; \Copy some data into RAM 
        LDY.B #$6C                                ;;8D12|8D7D+8D7D/8D7D\8D7F;  | 
        -
        PHX
        TYX
        LDA.L StatusBarRow2,X                     ;;8D14|8D7F+8D7F/8D7F\8D81;  |
        PLX 
        STA.W !StatusBar,X                        ;;8D17|8D82+8D82/8D82\8D84;  | 59
        DEY                                       ;;8D1A|8D85+8D85/8D85\8D87;  | 
        DEY                                       ;;8D1B|8D86+8D86/8D86\8D88;  | 
        DEX                                       ;;8D1C|8D87+8D87/8D87\8D89;  | 
        BPL -                                     ;;8D1D|8D88+8D88/8D88\8D8A; / 
        JML $008D8A|!BankB

DATA_008D90:          db $01,$18                                ;;8D25|8D90+8D90/8D90\8D92;
                      dl StatusBarRow1                          ;;8D27|8D92+8D92/8D92\8D94;
                      dw $0008                                  ;;8D2A|8D95+8D95/8D95\8D97;
                                                                ;;                        ;
DATA_008D97:          db $01,$18                                ;;8D2C|8D97+8D97/8D97\8D99;
                      dl StatusBarRow2                          ;;8D2E|8D99+8D99/8D99\8D9B;
                      dw $0038                                  ;;8D31|8D9C+8D9C/8D9C\8D9E;
                                                                ;;                        ;
DATA_008D9E:          db $01,$18                                ;;8D33|8D9E+8D9E/8D9E\8DA0;
                      dl StatusBarRow3                          ;;8D35|8DA0+8DA0/8DA0\8DA2;
                      dw $0036                                  ;;8D38|8DA3+8DA3/8DA3\8DA5;
                                                                ;;                        ;
DATA_008DA5:          db $01,$18                                ;;8D3A|8DA5+8DA5/8DA5\8DA7;
                      dl StatusBarRow4                          ;;8D3C|8DA7+8DA7/8DA7\8DA9;
                      dw $0008                                  ;;8D3F|8DAA+8DAA/8DAA\8DAC;        

StatusBarRow1:        db $FC,$38,$FC,$38,$FC,$38,$FC,$38        ;;8C16|8C81+8C81/8C81\8C83;
                                                                ;;                        ;
StatusBarRow2:        db $FC,$38,$FC,$38,$FC,$38,$FC,$38        ;;8C1E|8C89+8C89/8C89\8C8B;
                      db $FC,$38,$FC,$38,$FC,$38,$FC,$38        ;;8C26|8C91+8C91/8C91\8C93;
                      db $FC,$38,$FC,$38,$FC,$38,$FC,$38        ;;8C2E|8C99+8C99/8C99\8C9B;
                      db $FC,$38,$FC,$38,$FC,$38,$FC,$38        ;;8C36|8CA1+8CA1/8CA1\8CA3;
                      db $FC,$38,$FC,$38,$FC,$38,$FC,$38        ;;8C3E|8CA9+8CA9/8CA9\8CAB;
                      db $FC,$38,$FC,$38,$FC,$38,$FC,$38        ;;8C46|8CB1+8CB1/8CB1\8CB3;
                      db $FC,$38,$FC,$38,$FC,$38,$FC,$38        ;;8C4E|8CB9+8CB9/8CB9\8CBB;
                                                                ;;                        ;
StatusBarRow3:        db $FC,$38,$FC,$38,$FC,$38,$FC,$38        ;;8C56|8CC1+8CC1/8CC1\8CC3;
                      db $FC,$38,$FC,$38,$FC,$38,$FC,$38        ;;8C5E|8CC9+8CC9/8CC9\8CCB;
                      db $FC,$38,$FC,$38,$FC,$38,$FC,$38        ;;8C66|8CD1+8CD1/8CD1\8CD3;
                      db $FC,$38,$FC,$38,$FC,$38,$FC,$38        ;;8C6E|8CD9+8CD9/8CD9\8CDB;
                      db $FC,$38,$FC,$38,$FC,$38,$FC,$38        ;;8C76|8CE1+8CE1/8CE1\8CE3;
                      db $FC,$38,$FC,$38,$FC,$38,$FC,$38        ;;8C7E|8CE9+8CE9/8CE9\8CEB;
                      db $FC,$38,$FC,$38,$FC,$38                ;;8C86|8CF1+8CF1/8CF1\8CF3;
                                                                ;;                        ;
StatusBarRow4:        db $FC,$38,$FC,$38,$FC,$38,$FC,$38        ;;8C8C|8CF7+8CF7/8CF7\8CF9;