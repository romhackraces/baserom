@echo off

set ROMFILE="..\RHR4.smc"
set LISTFILE="common\list_pixi.txt"

cd .\common\
.\pixi.exe -l %LISTFILE% %ROMFILE%
pause