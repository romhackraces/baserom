@echo off

set SOURCEROMFILE="%~dp0\Backup\latest_RHR4.smc"
set DESTROMFILE="RHR4.smc"

copy %DESTROMFILE% "%DESTROMFILE%~"

".\common\Lunar Magic.exe" -TransferLevelGlobalExAnim %DESTROMFILE% %SOURCEROMFILE%
".\common\Lunar Magic.exe" -TransferOverworld %DESTROMFILE% %SOURCEROMFILE%
".\common\Lunar Magic.exe" -TransferTitleScreen %DESTROMFILE% %SOURCEROMFILE%
".\common\Lunar Magic.exe" -TransferCredits %DESTROMFILE% %SOURCEROMFILE%

".\common\Lunar Magic.exe" -ImportMultLevels %DESTROMFILE% ".\Levels\latest\"
".\common\Lunar Magic.exe" -ImportAllMap16 %DESTROMFILE% ".\Map16\AllMap16_latest.map16"
".\common\Lunar Magic.exe" -ImportSharedPalette  %DESTROMFILE% ".\Palettes\Shared_latest.pal"
