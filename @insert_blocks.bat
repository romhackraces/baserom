@echo off

set ROMFILE="..\RHR4.smc"

cd .\common\
.\gps.exe -l "list_gps.txt" %ROMFILE%
pause