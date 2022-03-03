@echo off

set SOURCEROMFILE="%~dp0Backup\latest_RHR4.smc"
set DESTROMFILE="%~dp0RHR4.smc"

copy %DESTROMFILE% "%DESTROMFILE%~"

"%~dp0common\Lunar Magic.exe" -TransferLevelGlobalExAnim %DESTROMFILE% %SOURCEROMFILE%
"%~dp0common\Lunar Magic.exe" -TransferOverworld %DESTROMFILE% %SOURCEROMFILE%
"%~dp0common\Lunar Magic.exe" -TransferTitleScreen %DESTROMFILE% %SOURCEROMFILE%
"%~dp0common\Lunar Magic.exe" -TransferCredits %DESTROMFILE% %SOURCEROMFILE%

"%~dp0common\Lunar Magic.exe" -ImportMultLevels %DESTROMFILE% "%~dp0Levels\latest\"
"%~dp0common\Lunar Magic.exe" -ImportAllMap16 %DESTROMFILE% "%~dp0Map16\AllMap16_latest.map16"
"%~dp0common\Lunar Magic.exe" -ImportSharedPalette  %DESTROMFILE% "%~dp0Palettes\Shared_latest.pal"
