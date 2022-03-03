@echo off
cls
:start

:: Variables
set ROMFILE="RHR4.smc"

setlocal
for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set DateTime=%%a

set Year=%DateTime:~0,4%
set Month=%DateTime:~4,2%
set Day=%DateTime:~6,2%
set Hour=%DateTime:~8,2%
set Minute=%DateTime:~10,2%

set TIMESTAMP="%Year%%Month%%Day%_%Hour%%Minute%"

:: Options
echo Backup Actions
echo.
echo   1. Export all modified levels to files
echo   2. Export all of Map16
echo   3. Export shared palettes
echo   4. Create time-stamped backup of your ROM
echo   0. Exit
echo.
set /p Action=Enter the number of your choice: 


:: Export MWL level files
if "%Action%"=="1" (
    echo Exporting Levels...
    mkdir "Levels\%TIMESTAMP%"
    mkdir "Levels\latest"
    ".\common\Lunar Magic.exe" -ExportMultLevels "%ROMFILE%" "Levels\%TIMESTAMP%\level" 
    ".\common\Lunar Magic.exe" -ExportMultLevels "%ROMFILE%" "Levels\latest\level"  
    echo Done.
)
:: Export Map16
if "%Action%"=="2" (
    echo Exporting Map16...
    mkdir "Map16"
    ".\common\Lunar Magic.exe" -ExportAllMap16 "%ROMFILE%" "Map16\AllMap16_%TIMESTAMP%.map16" 
    ".\common\Lunar Magic.exe" -ExportAllMap16 "%ROMFILE%" "Map16\AllMap16_latest.map16" 
    echo Done.
)
:: Export Palettes
if "%Action%"=="3" (
    echo Exporting Palettes...
    mkdir "Palettes"
    ".\common\Lunar Magic.exe" -ExportSharedPalette "%ROMFILE%" "Palettes\%TIMESTAMP%_Shared.pal"
    ".\common\Lunar Magic.exe" -ExportSharedPalette "%ROMFILE%" "Palettes\Shared_latest.pal"
    echo Done.
)
:: Create time-stamped backup of your ROM
if "%Action%"=="4" (
    echo Creating time-stamped copy of your ROM...
    copy %ROMFILE% "Backup\%TIMESTAMP%_%BASEROM_NAME%.smc"
    copy %ROMFILE% "Backup\latest_%BASEROM_NAME%.smc"
    echo Done.
)
if "%Action%"=="0" (
    exit
)
if '%Action%'=='' echo %choice%" is not valid please try again.
