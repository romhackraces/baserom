@echo off
Setlocal EnableDelayedExpansion
cls
:start

:: Name of your ROM
set ROMNAME=RHR4

:: Variables
set SMW_ORIG=%~dp0sysLMRestore\smwOrig.smc
set BACKUP=%~dp0Backup\latest_%ROMNAME%.smc
set ROMFILE=%~dp0%ROMNAME%.smc
set PATCHFILE=%~dp0%ROMNAME%.bps

:: Restore locations
set LEVELS_BACKUP=%~dp0Levels\latest\
set MAP16_BACKUP=%~dp0Map16\AllMap16_latest.map16
set PAL_BACKUP=%~dp0Palettes\Shared_latest.pal

:: Lunar Magic location
set LM="%~dp0common\Lunar Magic.exe"

:: Options
echo Restore Actions -- Only use this with a fresh ROM
echo.
echo   1. Create fresh ROM out of baserom patch.
echo   2. Transfer Global ExAnimation, Overworld, Titlescreen and Credits from backup
echo   3. Import levels from backup
echo   4. Import all of Map16 from backup
echo   5. Import shared palettes from backup
echo   0. Exit
echo.
set /p Action=Enter the number of your choice: 

:: Create fresh baserom from patch.
if "!Action!"=="1" (
    echo Creating fresh baserom...
    if not exist %PATCHFILE% (
        echo Could not find baserom patch. Please try again.
        exit /b
    ) else (
        if exist %ROMFILE% (
            echo Hack already exists, making temporary backup.
            :: Make backup of ROM just in case of error
            copy %ROMFILE% "%ROMFILE%~"
        )
        :: Apply baserom patch with Flips
        echo Patching fresh baserom...
        %~dp0common\flips.exe --apply %PATCHFILE% !SMW_ORIG! %ROMFILE%
        echo Done.
    )
)
:: Transferr Global ExAnimation, Overworld, Titlescreen and Credits
if "!Action!"=="2" (
    echo Transferring ExAnimation, Overworld, Titlescreen and Credits...
    if not exist !BACKUP! (
        echo Could not a back-up of your ROM. Run a back-up first before proceeding.
        exit /b
    ) else (
        :: Run Lunar Magic Actions
        !LM! -TransferLevelGlobalExAnim %ROMFILE% !BACKUP!
        !LM! -TransferOverworld %ROMFILE% !BACKUP!
        !LM! -TransferTitleScreen %ROMFILE% !BACKUP!
        !LM! -TransferCredits %ROMFILE% !BACKUP!
        echo Done.
    )
)
:: Import backed up levels
if "!Action!"=="3" (
    echo Importing levels...
    if not exist !LEVELS_BACKUP! (
        echo Could not find a back-up of your levels.
        exit /b
    ) else (
        !LM! -ImportMultLevels %ROMFILE% !LEVELS_BACKUP!
        echo Done.
    )
)
:: Import backed up map16
if "!Action!"=="4" (
    echo Importing map16...
    if not exist !MAP16_BACKUP! (
        echo Could not find a back-up of map16.
        exit /b
    ) else (
        !LM! -ImportAllMap16 %ROMFILE% !MAP16_BACKUP!
        echo Done.
    )
)
:: Import backed up palettes
if "!Action!"=="5" (
    echo Importing palettes...
    if not exist !PAL_BACKUP! (
        echo Could not find a back-up of palettes.
        exit /b
    ) else (
        !LM! -ImportSharedPalette  %ROMFILE% !PAL_BACKUP!
        echo Done.
    )
)
popd

if "!Action!"=="0" (
    echo Have a nice day ^^_^^
    exit /b
)
if '!Action!'=='' echo Nothing is not valid option, please try again.
