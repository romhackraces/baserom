@echo off
cls
set IS_BUILD_SCRIPT=1

:: Working Directory
setlocal DisableDelayedExpansion
set WORKING_DIR=%~sdp0
set WORKING_DIR=%WORKING_DIR:!=^^!%
setlocal EnableDelayedExpansion

:: Import Common Script Stuff
call %WORKING_DIR%@build_script_common.bat
if errorlevel == 1 goto :EOF

:: Restore locations
set LEVELS_RESTORE=!BACKUP_DIR!Levels\latest\
set ROM_RESTORE=!BACKUP_DIR!ROM\latest_%ROM_NAME%.smc
set MAP16_RESTORE=!BACKUP_DIR!Map16\latest_AllMap16.map16
set PAL_RESTORE=!BACKUP_DIR!Palettes\latest_Shared.pal

:: Menu
:RestoreMenu
echo -----------------------------------
echo Baserom Restore Script
echo -----------------------------------
echo.
echo What would you like to to?
echo.
echo   1. Transfer Global ExAnimation, Overworld, Titlescreen and Credits from backup
echo   2. Import levels from backup
echo   3. Import all of Map16 from backup
echo   4. Import shared palettes from backup
echo   0. Exit
echo.
set /p "Action=Enter the number of your choice: "

:: Check if input was a number
for /F "delims=01234" %%i in ("!Action!") do (
    cls
    echo "%%i" is not a valid option, please try again.
    echo.
    goto RestoreMenu
)
cls

:: Transferr Global ExAnimation, Overworld, Titlescreen and Credits
if "!Action!"=="1" (
    echo Transferring ExAnimation, Overworld, Titlescreen and Credits...
    if not exist !ROM_RESTORE! (
        echo.
        echo Could not find a back-up of your ROM. Run a back-up first before proceeding.
        echo.
        pause
        exit /b
    ) else (
        :: Run Lunar Magic Actions
        !LM! -TransferLevelGlobalExAnim !ROM_FILE! !ROM_RESTORE!
        !LM! -TransferOverworld !ROM_FILE! !ROM_RESTORE!
        !LM! -TransferTitleScreen !ROM_FILE! !ROM_RESTORE!
        !LM! -TransferCredits !ROM_FILE! !ROM_RESTORE!
        echo Done.
        echo.
        goto RestoreMenu
    )
)

:: Import backed up levels
if "!Action!"=="2" (
    echo Importing levels...
    if not exist !LEVELS_RESTORE! (
        echo Could not find a back-up of your levels.
        exit /b
    ) else (
        !LM! -ImportMultLevels !ROM_FILE! !LEVELS_RESTORE!
        echo Done.
        echo.
        goto RestoreMenu
    )
)

:: Import backed up map16
if "!Action!"=="3" (
    echo Importing map16...
    if not exist !MAP16_RESTORE! (
        echo Could not find a back-up of map16.
        exit /b
    ) else (
        !LM! -ImportAllMap16 !ROM_FILE! !MAP16_RESTORE!
        echo Done.
        echo.
        goto RestoreMenu
    )
)

:: Import backed up palettes
if "!Action!"=="4" (
    echo Importing palettes...
    if not exist !PAL_RESTORE! (
        echo Could not find a back-up of palettes.
        exit /b
    ) else (
        !LM! -ImportSharedPalette  !ROM_FILE! !PAL_RESTORE!
        echo Done.
        echo.
        goto RestoreMenu
    )
)

:: Exit
if "!Action!"=="0" (
    echo Have a nice day ^^_^^
    exit /b
)
