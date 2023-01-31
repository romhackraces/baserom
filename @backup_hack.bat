@echo off
cls
:start

:: Working Directory
setlocal DisableDelayedExpansion
set WORKING_DIR=%~sdp0
set WORKING_DIR=%WORKING_DIR:!=^^!%
setlocal EnableDelayedExpansion

:: Import Definitions
call %WORKING_DIR%Tools\@tool_defines.bat

:: DO NOT CHANGE THE VARIABLES BELOW

:: Directory Definitiions
set BACKUP_DIR=%~sdp0Backup\
set TOOLS_DIR=%WORKING_DIR%Tools\
set CONF_DIR=%WORKING_DIR%Other\Config\

:: ROM Definitions
set ROM_NAME_FILE=!CONF_DIR!rom-name.txt
:: Check if rom-name.txt exists
if not exist !ROM_NAME_FILE! (
    :: Ask for ROM name
    set /p ROM_NAME_INPUT=Enter the filename of your ROM, e.g. "MyHack":
    echo !ROM_NAME_INPUT!>!ROM_NAME_FILE!
    :: Set ROM name
    set /p ROM_NAME=<!ROM_NAME_FILE!
) else (
    :: Set ROM name
    set /p ROM_NAME=<!ROM_NAME_FILE!
)

set ROMFILE="%WORKING_DIR%%ROM_NAME%.smc"

:: Backup locations
set ROM_BACKUP="%BACKUP_DIR%"ROM
set LEVELS_BACKUP="%BACKUP_DIR%"Levels
set MAP16_BACKUP="%BACKUP_DIR%"Map16
set PAL_BACKUP="%BACKUP_DIR%"Palettes

:: Lunar Magic
set LM="!TOOLS_DIR!LunarMagic\Lunar Magic.exe"
set LM_DIR=!TOOLS_DIR!LunarMagic\
:: Check if Lunar Magic exists and download if not
if not exist "!LM_DIR!Lunar Magic.exe" (
    echo Lunar Magic not found, downloading...
    powershell Invoke-WebRequest !LM_DL! -OutFile !LM_ZIP! >NUL
    powershell Expand-Archive !LM_ZIP! -DestinationPath !LM_DIR! >NUL
    :: Delete junk files
    for %%a in (!LM_JUNK!) do (del !LM_DIR!%%a)
    :: Delete Zip
    del !LM_ZIP!
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
echo Backup Actions. ROM name: !ROM_NAME!
echo.
echo This script will create time-stamped backups of the following:
echo.
echo   1. Any modified levels
echo   2. All of Map16
echo   3. Shared palette
echo   4. ROM file
echo   0. Exit
echo.
set /p Action=Enter the number of your choice:
echo.

:: Export MWL level files
if "%Action%"=="1" (
    echo Exporting modified levels...
    if not exist %LEVELS_BACKUP%\%TIMESTAMP% (
        mkdir %LEVELS_BACKUP%\%TIMESTAMP%
    )
    !LM! -ExportMultLevels !ROMFILE! %LEVELS_BACKUP%\%TIMESTAMP%\level
    pause
)
:: Export Map16
if "%Action%"=="2" (
    echo Exporting all of Map16...
    if not exist %MAP16_BACKUP% (
        mkdir %MAP16_BACKUP%
    )
    !LM! -ExportAllMap16 !ROMFILE! %MAP16_BACKUP%\%TIMESTAMP%_AllMap16.map16
    pause
)
:: Export Palettes
if "%Action%"=="3" (
    echo Exporting shared palette...
    if not exist %PAL_BACKUP% (
        mkdir %PAL_BACKUP%
    )
    !LM! -ExportSharedPalette !ROMFILE! %PAL_BACKUP%\%TIMESTAMP%_Shared.pal
    pause
)
:: Create time-stamped backup of your ROM
if "%Action%"=="4" (
    if not exist %ROM_BACKUP% (
        mkdir %ROM_BACKUP%
    )
    echo Creating time-stamped copy of your ROM...
    copy !ROMFILE! %ROM_BACKUP%\%TIMESTAMP%_%ROM_NAME%.smc
    pause
)
if "%Action%"=="0" (
    echo Have a nice day ^^_^^
    exit /b
)
if '%Action%'=='' echo Nothing is not valid option, please try again.

exit /b