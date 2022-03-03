@echo off
Setlocal EnableDelayedExpansion
cls
:start

:: Name of your ROM
set ROMNAME=RHR4

:: Variables
set ROMFILE="%~dp0%ROMNAME%.smc"

:: Backup locations
set MAIN_BACKUP=%~dp0Backup
set LEVELS_BACKUP=%~dp0Levels
set MAP16_BACKUP=%~dp0Map16
set PAL_BACKUP=%~dp0Palettes

:: Lunar Magic location
set LM="%~dp0common\Lunar Magic.exe"

:: Time stuff
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
    if not exist %LEVELS_BACKUP%\%TIMESTAMP% (
        mkdir "%LEVELS_BACKUP%\%TIMESTAMP%"
    )

    if not exist %LEVELS_BACKUP%\latest (
        mkdir "%LEVELS_BACKUP%\latest"
    )

    %LM% -ExportMultLevels "%ROMFILE%" "%LEVELS_BACKUP%\%TIMESTAMP%\level"
    %LM% -ExportMultLevels "%ROMFILE%" "%LEVELS_BACKUP%\latest\level"
    echo Done.
)
:: Export Map16
if "%Action%"=="2" (
    echo Exporting Map16...
    echo %~dp0
    if not exist %MAP16_BACKUP% (
        mkdir "%MAP16_BACKUP%"
    )
    %LM% -ExportAllMap16 "%ROMFILE%" "%MAP16_BACKUP%\AllMap16_%TIMESTAMP%.map16"
    %LM% -ExportAllMap16 "%ROMFILE%" "%MAP16_BACKUP%\AllMap16_latest.map16"
    echo Done.
)
:: Export Palettes
if "%Action%"=="3" (
    echo Exporting Palettes...
    if not exist %PAL_BACKUP% (
        mkdir "%PAL_BACKUP%"
    )
    %LM% -ExportSharedPalette "%ROMFILE%" "%PAL_BACKUP%\%TIMESTAMP%_Shared.pal"
    %LM% -ExportSharedPalette "%ROMFILE%" "%PAL_BACKUP%\Shared_latest.pal"
    echo Done.
)
:: Create time-stamped backup of your ROM
if "%Action%"=="4" (
    if not exist %MAIN_BACKUP% (
        mkdir %MAIN_BACKUP%
    )
    echo Creating time-stamped copy of your ROM...
    copy "%ROMFILE%" "%MAIN_BACKUP%\%TIMESTAMP%_%ROMNAME%.smc"
    copy "%ROMFILE%" "%MAIN_BACKUP%\latest_%ROMNAME%.smc"
    echo Done.
)
if "%Action%"=="0" (
    echo Have a nice day ^^_^^
    exit /b
)
if '%Action%'=='' echo Nothing is not valid option, please try again.
