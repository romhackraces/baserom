@echo off
cls
:start

:: Working Directory
setlocal DisableDelayedExpansion
set WORKING_DIR=%~sdp0
set WORKING_DIR=%WORKING_DIR:!=^^!%
setlocal EnableDelayedExpansion

:: DO NOT CHANGE THE VARIABLES BELOW

:: ROM Definitions
set ROM_NAME_FILE=%WORKING_DIR%Other\rom-name.txt
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

:: Import Definitions
call %WORKING_DIR%Tools\@tool_defines.bat

:: Directory Definitiions
set BACKUP_DIR=%WORKING_DIR%Backup\
set TOOLS_DIR=%WORKING_DIR%Tools\

:: Variables
set ROM_FILE="%WORKING_DIR%%ROM_NAME%.smc"
set PATCH_FILE="%WORKING_DIR%%ROM_NAME%.bps"

:: Restore locations
set LEVELS_BACKUP="%BACKUP_DIR%Levels\latest\"
set RESTORE_FILE="%BACKUP_DIR%ROM\latest_%ROM_NAME%.smc"
set MAP16_BACKUP="%BACKUP_DIR%Map16\latest_AllMap16.map16"
set PAL_BACKUP="%BACKUP_DIR%Palettes\latest_Shared.pal"

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
    goto RestoreMenuMenu
)
cls

:: Transferr Global ExAnimation, Overworld, Titlescreen and Credits
if "!Action!"=="1" (
    echo Transferring ExAnimation, Overworld, Titlescreen and Credits...
    if not exist !RESTORE_FILE! (
        echo.
        echo Could not find a back-up of your ROM. Run a back-up first before proceeding.
        echo.
        pause
        exit /b
    ) else (
        :: Run Lunar Magic Actions
        !LM! -TransferLevelGlobalExAnim !ROM_FILE! !RESTORE_FILE!
        !LM! -TransferOverworld !ROM_FILE! !RESTORE_FILE!
        !LM! -TransferTitleScreen !ROM_FILE! !RESTORE_FILE!
        !LM! -TransferCredits !ROM_FILE! !RESTORE_FILE!
        echo Done.
        echo.
        goto RestoreMenuMenu
    )
)

:: Import backed up levels
if "!Action!"=="2" (
    echo Importing levels...
    if not exist !LEVELS_BACKUP! (
        echo Could not find a back-up of your levels.
        exit /b
    ) else (
        !LM! -ImportMultLevels !ROM_FILE! !LEVELS_BACKUP!
        echo Done.
        echo.
        goto RestoreMenuMenu
    )
)

:: Import backed up map16
if "!Action!"=="3" (
    echo Importing map16...
    if not exist !MAP16_BACKUP! (
        echo Could not find a back-up of map16.
        exit /b
    ) else (
        !LM! -ImportAllMap16 !ROM_FILE! !MAP16_BACKUP!
        echo Done.
        echo.
        goto RestoreMenuMenu
    )
)

:: Import backed up palettes
if "!Action!"=="4" (
    echo Importing palettes...
    if not exist !PAL_BACKUP! (
        echo Could not find a back-up of palettes.
        exit /b
    ) else (
        !LM! -ImportSharedPalette  !ROM_FILE! !PAL_BACKUP!
        echo Done.
        echo.
        goto RestoreMenuMenu
    )
)

if "!Action!"=="0" (
    echo Have a nice day ^^_^^
    exit /b
)

popd
pause
endlocal
exit /b