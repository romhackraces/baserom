@echo off
cls
set IS_BUILD_SCRIPT=0

:: Working Directory
setlocal DisableDelayedExpansion
set WORKING_DIR=%~sdp0
set WORKING_DIR=%WORKING_DIR:!=^^!%
setlocal EnableDelayedExpansion

:: Time stuff
setlocal
for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set DateTime=%%a

set Year=%DateTime:~0,4%
set Month=%DateTime:~4,2%
set Day=%DateTime:~6,2%
set Hour=%DateTime:~8,2%
set Minute=%DateTime:~10,2%

set TIMESTAMP="%Year%%Month%%Day%_%Hour%%Minute%"


:: Import Common Script Stuff
call %WORKING_DIR%@build_script_common.bat
if errorlevel == 1 goto :EOF

:: Backup locations
set ROM_BACKUP=!BACKUP_DIR!ROM
set LEVELS_BACKUP=!BACKUP_DIR!Levels
set MAP16_BACKUP=!BACKUP_DIR!Map16
set PAL_BACKUP=!BACKUP_DIR!Palettes

:: Menu
:BackupMenu
echo ------------------------------
echo Baserom Backup Script
echo ------------------------------
echo.
echo What would you like to to?
echo.
echo   1. Export any modified levels
echo   2. Save all of Map16
echo   3. Export copy of shared palette
echo   4. Create time-stamped backup of ROM file
echo   0. Exit
echo.
set /p "Action=Enter the number of your choice: "
echo.

:: Check if input was a number
for /F "delims=01234" %%i in ("!Action!") do (
    cls
    echo "%%i" is not a valid option, please try again.
    echo.
    goto BackupMenu
)
cls

:: Export MWL level files
if "!Action!"=="1" (
    echo Exporting modified levels...
    :: timestamped version
    if not exist %LEVELS_BACKUP%\%TIMESTAMP% (
        mkdir %LEVELS_BACKUP%\%TIMESTAMP%
    )
    !LM! -ExportMultLevels !ROM_FILE! %LEVELS_BACKUP%\%TIMESTAMP%\level
    :: latest version
    if not exist %LEVELS_BACKUP%\latest (
        mkdir %LEVELS_BACKUP%\latest
    )
    !LM! -ExportMultLevels !ROM_FILE! %LEVELS_BACKUP%\latest\level
    echo Done.
    echo.
    goto BackupMenu
)
:: Export Map16
if "!Action!"=="2" (
    echo Exporting all of Map16...
    if not exist %MAP16_BACKUP% (
        mkdir %MAP16_BACKUP%
    )
    !LM! -ExportAllMap16 !ROM_FILE! %MAP16_BACKUP%\%TIMESTAMP%_AllMap16.map16
    !LM! -ExportAllMap16 !ROM_FILE! %MAP16_BACKUP%\latest_AllMap16.map16
    echo Done.
    echo.
    goto BackupMenu
)
:: Export Palettes
if "!Action!"=="3" (
    echo Exporting shared palette...
    if not exist %PAL_BACKUP% (
        mkdir %PAL_BACKUP%
    )
    !LM! -ExportSharedPalette !ROM_FILE! %PAL_BACKUP%\%TIMESTAMP%_Shared.pal
    !LM! -ExportSharedPalette !ROM_FILE! %PAL_BACKUP%\latest_Shared.pal
    echo Done.
    echo.
    goto BackupMenu
)
:: Create time-stamped backup of your ROM
if "!Action!"=="4" (
    if not exist %ROM_BACKUP% (
        mkdir %ROM_BACKUP%
    )
    echo Creating time-stamped copy of your ROM...
    copy !ROM_FILE! %ROM_BACKUP%\%TIMESTAMP%_%ROM_NAME%.smc
    copy !ROM_FILE! %ROM_BACKUP%\latest_%ROM_NAME%.smc
    echo Done.
    echo.
    goto BackupMenu
)

:: Exit
if "!Action!"=="0" (
    echo Have a nice day ^^_^^
    exit /b
)
endlocal
