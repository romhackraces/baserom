@echo off
cls
:start

:: Working Directory 
setlocal DisableDelayedExpansion
set WORKING_DIR=%~sdp0
set WORKING_DIR=%WORKING_DIR:!=^^!%
setlocal EnableDelayedExpansion

:: Import Definitions
call %WORKING_DIR%@your_defines.bat
call %WORKING_DIR%@tool_defines.bat

:: DO NOT CHANGE THE VARIABLES BELOW

:: Backup Directory 
set BACKUP_DIR=%~sdp0Backup\

:: Variables
set ROMFILE="%WORKING_DIR%%ROM_NAME%.smc"

:: Backup locations
set MAIN_BACKUP="%BACKUP_DIR%"ROM
set LEVELS_BACKUP="%BACKUP_DIR%"Levels
set MAP16_BACKUP="%BACKUP_DIR%"Map16
set PAL_BACKUP="%BACKUP_DIR%"Palettes

:: Lunar Magic location
set LM="%WORKING_DIR%Lunar Magic.exe"

:: Check if Lunar Magic exists and download if not
if not exist !LM! (
    echo Executable for Lunar Magic not found, downloading...
    powershell Invoke-WebRequest !LM_DL! -OutFile !LM_ZIP! >NUL
    powershell Expand-Archive !LM_ZIP! -DestinationPath %WORKING_DIR% >NUL
    :: Delete junk files
    del %WORKING_DIR%!LM_ZIP!
    pushd %WORKING_DIR%
    for %%a in (!LM_JUNK!) do (del %WORKING_DIR%%%a)
    echo Done.
)

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
        mkdir %LEVELS_BACKUP%\%TIMESTAMP%
    )
    if not exist %LEVELS_BACKUP%\latest (
        mkdir %LEVELS_BACKUP%\latest
    )
    !LM! -ExportMultLevels !ROMFILE! %LEVELS_BACKUP%\%TIMESTAMP%\level
    !LM! -ExportMultLevels !ROMFILE! %LEVELS_BACKUP%\latest\level
    pause
)
:: Export Map16
if "%Action%"=="2" (
    echo Exporting Map16...
    if not exist %MAP16_BACKUP% (
        mkdir %MAP16_BACKUP%
    )
    !LM! -ExportAllMap16 !ROMFILE! %MAP16_BACKUP%\%TIMESTAMP%_AllMap16.map16
    !LM! -ExportAllMap16 !ROMFILE! %MAP16_BACKUP%\AllMap16_latest.map16
    pause
)
:: Export Palettes
if "%Action%"=="3" (
    echo Exporting Palettes...
    if not exist %PAL_BACKUP% (
        mkdir %PAL_BACKUP%
    )
    !LM! -ExportSharedPalette !ROMFILE! %PAL_BACKUP%\%TIMESTAMP%_Shared.pal
    !LM! -ExportSharedPalette !ROMFILE! %PAL_BACKUP%\Shared_latest.pal
    pause
)
:: Create time-stamped backup of your ROM
if "%Action%"=="4" (
    if not exist %MAIN_BACKUP% (
        mkdir %MAIN_BACKUP%
    )
    echo Creating time-stamped copy of your ROM...
    copy !ROMFILE! %MAIN_BACKUP%\%TIMESTAMP%_%ROM_NAME%.smc
    copy !ROMFILE! %MAIN_BACKUP%\latest_%ROM_NAME%.smc
    pause
)
if "%Action%"=="0" (
    echo Have a nice day ^^_^^
    exit /b
)
if '%Action%'=='' echo Nothing is not valid option, please try again.
