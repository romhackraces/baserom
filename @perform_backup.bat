@echo off

setlocal
for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set DateTime=%%a

set Year=%DateTime:~0,4%
set Month=%DateTime:~4,2%
set Day=%DateTime:~6,2%
set Hour=%DateTime:~8,2%
set Minute=%DateTime:~10,2%

set BASEROM_NAME="RHR4"

set TIMESTAMP="%Year%%Month%%Day%_%Hour%%Minute%"

set ROM_FILE="%BASEROM_NAME%.smc"

copy %ROM_FILE% "Backup\%TIMESTAMP%_%BASEROM_NAME%.smc"
copy %ROM_FILE% "Backup\latest_%BASEROM_NAME%.smc"

call @export_levels.bat
call @export_map16.bat
call @export_palette.bat

goto :EOF