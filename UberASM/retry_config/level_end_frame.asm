;=====================================
; This routines are called at the end of every frame of the corresponding sublevel (level000 called in sublevel 0, etc.).
; You can see them as another label in UberASM level files (basically "main" but it runs at the end of the frame instead of the beginning).
; This can be useful to do stuff that requires to run after everything else: OAM manipulation, intercept music/sfx commands before they're sent to the SPC, drawing sprite tiles without using hardcoded slots, ...
; Note that these will run right after the "gm14_end" routine in "extra.asm".
; Like UberASM level code, all these routines are called in 8-bit A/X/Y mode and DBR is already set.
; Don't worry about overwriting registers, they'll be restored afterwards (except for direct page :P).
; Differently from UberASM, all the routines must end with rts.
; NOTE: on SA-1 roms, this runs on the SNES cpu.
;=====================================

level000:
    rts

level001:
    rts

level002:
    rts

level003:
    rts

level004:
    rts

level005:
    rts

level006:
    rts

level007:
    rts

level008:
    rts

level009:
    rts

level00A:
    rts

level00B:
    rts

level00C:
    rts

level00D:
    rts

level00E:
    rts

level00F:
    rts

level010:
    rts

level011:
    rts

level012:
    rts

level013:
    rts

level014:
    rts

level015:
    rts

level016:
    rts

level017:
    rts

level018:
    rts

level019:
    rts

level01A:
    rts

level01B:
    rts

level01C:
    rts

level01D:
    rts

level01E:
    rts

level01F:
    rts

level020:
    rts

level021:
    rts

level022:
    rts

level023:
    rts

level024:
    rts

level025:
    rts

level026:
    rts

level027:
    rts

level028:
    rts

level029:
    rts

level02A:
    rts

level02B:
    rts

level02C:
    rts

level02D:
    rts

level02E:
    rts

level02F:
    rts

level030:
    rts

level031:
    rts

level032:
    rts

level033:
    rts

level034:
    rts

level035:
    rts

level036:
    rts

level037:
    rts

level038:
    rts

level039:
    rts

level03A:
    rts

level03B:
    rts

level03C:
    rts

level03D:
    rts

level03E:
    rts

level03F:
    rts

level040:
    rts

level041:
    rts

level042:
    rts

level043:
    rts

level044:
    rts

level045:
    rts

level046:
    rts

level047:
    rts

level048:
    rts

level049:
    rts

level04A:
    rts

level04B:
    rts

level04C:
    rts

level04D:
    rts

level04E:
    rts

level04F:
    rts

level050:
    rts

level051:
    rts

level052:
    rts

level053:
    rts

level054:
    rts

level055:
    rts

level056:
    rts

level057:
    rts

level058:
    rts

level059:
    rts

level05A:
    rts

level05B:
    rts

level05C:
    rts

level05D:
    rts

level05E:
    rts

level05F:
    rts

level060:
    rts

level061:
    rts

level062:
    rts

level063:
    rts

level064:
    rts

level065:
    rts

level066:
    rts

level067:
    rts

level068:
    rts

level069:
    rts

level06A:
    rts

level06B:
    rts

level06C:
    rts

level06D:
    rts

level06E:
    rts

level06F:
    rts

level070:
    rts

level071:
    rts

level072:
    rts

level073:
    rts

level074:
    rts

level075:
    rts

level076:
    rts

level077:
    rts

level078:
    rts

level079:
    rts

level07A:
    rts

level07B:
    rts

level07C:
    rts

level07D:
    rts

level07E:
    rts

level07F:
    rts

level080:
    rts

level081:
    rts

level082:
    rts

level083:
    rts

level084:
    rts

level085:
    rts

level086:
    rts

level087:
    rts

level088:
    rts

level089:
    rts

level08A:
    rts

level08B:
    rts

level08C:
    rts

level08D:
    rts

level08E:
    rts

level08F:
    rts

level090:
    rts

level091:
    rts

level092:
    rts

level093:
    rts

level094:
    rts

level095:
    rts

level096:
    rts

level097:
    rts

level098:
    rts

level099:
    rts

level09A:
    rts

level09B:
    rts

level09C:
    rts

level09D:
    rts

level09E:
    rts

level09F:
    rts

level0A0:
    rts

level0A1:
    rts

level0A2:
    rts

level0A3:
    rts

level0A4:
    rts

level0A5:
    rts

level0A6:
    rts

level0A7:
    rts

level0A8:
    rts

level0A9:
    rts

level0AA:
    rts

level0AB:
    rts

level0AC:
    rts

level0AD:
    rts

level0AE:
    rts

level0AF:
    rts

level0B0:
    rts

level0B1:
    rts

level0B2:
    rts

level0B3:
    rts

level0B4:
    rts

level0B5:
    rts

level0B6:
    rts

level0B7:
    rts

level0B8:
    rts

level0B9:
    rts

level0BA:
    rts

level0BB:
    rts

level0BC:
    rts

level0BD:
    rts

level0BE:
    rts

level0BF:
    rts

level0C0:
    rts

level0C1:
    rts

level0C2:
    rts

level0C3:
    rts

level0C4:
    rts

level0C5:
    rts

level0C6:
    rts

level0C7:
    rts

level0C8:
    rts

level0C9:
    rts

level0CA:
    rts

level0CB:
    rts

level0CC:
    rts

level0CD:
    rts

level0CE:
    rts

level0CF:
    rts

level0D0:
    rts

level0D1:
    rts

level0D2:
    rts

level0D3:
    rts

level0D4:
    rts

level0D5:
    rts

level0D6:
    rts

level0D7:
    rts

level0D8:
    rts

level0D9:
    rts

level0DA:
    rts

level0DB:
    rts

level0DC:
    rts

level0DD:
    rts

level0DE:
    rts

level0DF:
    rts

level0E0:
    rts

level0E1:
    rts

level0E2:
    rts

level0E3:
    rts

level0E4:
    rts

level0E5:
    rts

level0E6:
    rts

level0E7:
    rts

level0E8:
    rts

level0E9:
    rts

level0EA:
    rts

level0EB:
    rts

level0EC:
    rts

level0ED:
    rts

level0EE:
    rts

level0EF:
    rts

level0F0:
    rts

level0F1:
    rts

level0F2:
    rts

level0F3:
    rts

level0F4:
    rts

level0F5:
    rts

level0F6:
    rts

level0F7:
    rts

level0F8:
    rts

level0F9:
    rts

level0FA:
    rts

level0FB:
    rts

level0FC:
    rts

level0FD:
    rts

level0FE:
    rts

level0FF:
    rts

level100:
    rts

level101:
    rts

level102:
    rts

level103:
    rts

level104:
    rts

level105:
    rts

level106:
    rts

level107:
    rts

level108:
    rts

level109:
    rts

level10A:
    rts

level10B:
    rts

level10C:
    rts

level10D:
    rts

level10E:
    rts

level10F:
    rts

level110:
    rts

level111:
    rts

level112:
    rts

level113:
    rts

level114:
    rts

level115:
    rts

level116:
    rts

level117:
    rts

level118:
    rts

level119:
    rts

level11A:
    rts

level11B:
    rts

level11C:
    rts

level11D:
    rts

level11E:
    rts

level11F:
    rts

level120:
    rts

level121:
    rts

level122:
    rts

level123:
    rts

level124:
    rts

level125:
    rts

level126:
    rts

level127:
    rts

level128:
    rts

level129:
    rts

level12A:
    rts

level12B:
    rts

level12C:
    rts

level12D:
    rts

level12E:
    rts

level12F:
    rts

level130:
    rts

level131:
    rts

level132:
    rts

level133:
    rts

level134:
    rts

level135:
    rts

level136:
    rts

level137:
    rts

level138:
    rts

level139:
    rts

level13A:
    rts

level13B:
    rts

level13C:
    rts

level13D:
    rts

level13E:
    rts

level13F:
    rts

level140:
    rts

level141:
    rts

level142:
    rts

level143:
    rts

level144:
    rts

level145:
    rts

level146:
    rts

level147:
    rts

level148:
    rts

level149:
    rts

level14A:
    rts

level14B:
    rts

level14C:
    rts

level14D:
    rts

level14E:
    rts

level14F:
    rts

level150:
    rts

level151:
    rts

level152:
    rts

level153:
    rts

level154:
    rts

level155:
    rts

level156:
    rts

level157:
    rts

level158:
    rts

level159:
    rts

level15A:
    rts

level15B:
    rts

level15C:
    rts

level15D:
    rts

level15E:
    rts

level15F:
    rts

level160:
    rts

level161:
    rts

level162:
    rts

level163:
    rts

level164:
    rts

level165:
    rts

level166:
    rts

level167:
    rts

level168:
    rts

level169:
    rts

level16A:
    rts

level16B:
    rts

level16C:
    rts

level16D:
    rts

level16E:
    rts

level16F:
    rts

level170:
    rts

level171:
    rts

level172:
    rts

level173:
    rts

level174:
    rts

level175:
    rts

level176:
    rts

level177:
    rts

level178:
    rts

level179:
    rts

level17A:
    rts

level17B:
    rts

level17C:
    rts

level17D:
    rts

level17E:
    rts

level17F:
    rts

level180:
    rts

level181:
    rts

level182:
    rts

level183:
    rts

level184:
    rts

level185:
    rts

level186:
    rts

level187:
    rts

level188:
    rts

level189:
    rts

level18A:
    rts

level18B:
    rts

level18C:
    rts

level18D:
    rts

level18E:
    rts

level18F:
    rts

level190:
    rts

level191:
    rts

level192:
    rts

level193:
    rts

level194:
    rts

level195:
    rts

level196:
    rts

level197:
    rts

level198:
    rts

level199:
    rts

level19A:
    rts

level19B:
    rts

level19C:
    rts

level19D:
    rts

level19E:
    rts

level19F:
    rts

level1A0:
    rts

level1A1:
    rts

level1A2:
    rts

level1A3:
    rts

level1A4:
    rts

level1A5:
    rts

level1A6:
    rts

level1A7:
    rts

level1A8:
    rts

level1A9:
    rts

level1AA:
    rts

level1AB:
    rts

level1AC:
    rts

level1AD:
    rts

level1AE:
    rts

level1AF:
    rts

level1B0:
    rts

level1B1:
    rts

level1B2:
    rts

level1B3:
    rts

level1B4:
    rts

level1B5:
    rts

level1B6:
    rts

level1B7:
    rts

level1B8:
    rts

level1B9:
    rts

level1BA:
    rts

level1BB:
    rts

level1BC:
    rts

level1BD:
    rts

level1BE:
    rts

level1BF:
    rts

level1C0:
    rts

level1C1:
    rts

level1C2:
    rts

level1C3:
    rts

level1C4:
    rts

level1C5:
    rts

level1C6:
    rts

level1C7:
    rts

level1C8:
    rts

level1C9:
    rts

level1CA:
    rts

level1CB:
    rts

level1CC:
    rts

level1CD:
    rts

level1CE:
    rts

level1CF:
    rts

level1D0:
    rts

level1D1:
    rts

level1D2:
    rts

level1D3:
    rts

level1D4:
    rts

level1D5:
    rts

level1D6:
    rts

level1D7:
    rts

level1D8:
    rts

level1D9:
    rts

level1DA:
    rts

level1DB:
    rts

level1DC:
    rts

level1DD:
    rts

level1DE:
    rts

level1DF:
    rts

level1E0:
    rts

level1E1:
    rts

level1E2:
    rts

level1E3:
    rts

level1E4:
    rts

level1E5:
    rts

level1E6:
    rts

level1E7:
    rts

level1E8:
    rts

level1E9:
    rts

level1EA:
    rts

level1EB:
    rts

level1EC:
    rts

level1ED:
    rts

level1EE:
    rts

level1EF:
    rts

level1F0:
    rts

level1F1:
    rts

level1F2:
    rts

level1F3:
    rts

level1F4:
    rts

level1F5:
    rts

level1F6:
    rts

level1F7:
    rts

level1F8:
    rts

level1F9:
    rts

level1FA:
    rts

level1FB:
    rts

level1FC:
    rts

level1FD:
    rts

level1FE:
    rts

level1FF:
    rts
