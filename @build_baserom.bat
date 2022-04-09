@echo off
Setlocal EnableDelayedExpansion
cls
:start

:: ROM Details
set ROM_NAME=RHR4

:: DO NOT CHANGE THE VARIABLES BELOW

:: Working Directory 
set WORKING_DIR=%~dp0

:: Variables
set ROMFILE="%WORKING_DIR%%ROM_NAME%.smc"
set PATCHNAME="%WORKING_DIR%%ROM_NAME%.bps"

:: List files in common (Do not change!)
set ASAR_LIST=list_asar.txt
set GPS_LIST=list_gps.txt
set PIXI_LIST=list_pixi.txt
set UBER_LIST=list_uberasm.txt

:: Options
echo Build Actions
echo.
echo   1. Apply Asar Patches
echo   2. Insert Custom Blocks
echo   3. Insert Custom Sprites
echo   4. Insert Custom Music
echo   5. Insert Custom UberASM
echo   6. Create BPS Patch
echo   0. Exit
echo.
set /p Action=Enter the number of your choice: 

:: Apply asar patches
if "!Action!"=="1" (
    echo Applying patches...
    pushd "%WORKING_DIR%Asar\"
    for /f "tokens=*" %%a in (%ASAR_LIST%) do (asar.exe -v %%a !ROMFILE!)
    echo Done.
)
:: Insert custom blocks with GPS
if "!Action!"=="2" (
    echo Inserting custom blocks...
    pushd "%WORKING_DIR%GPS\"
    gps.exe -l %GPS_LIST% !ROMFILE!
    echo Done.
)
:: Insert Custom Sprites with PIXI
if "!Action!"=="3" (
    echo Inserting custom sprites...
    pushd "%WORKING_DIR%PIXI\"
    pixi.exe -l "PIXI\%PIXI_LIST%" !ROMFILE!
    echo Done.
)
:: Insert custom music with AddmusicK
if "!Action!"=="4" (
    echo Inserting custom Music...
    pushd "%WORKING_DIR%AddmusicK_1.0.8\"
    AddmusicK.exe !ROMFILE!
    echo Done.
)
:: Insert custom uberASM
if "!Action!"=="5" (
    echo Inserting UberASM...
    pushd "%WORKING_DIR%UberASM\"
    UberASMTool.exe %UBER_LIST% !ROMFILE!
    echo Done.
)
:: Create bps Patch with Flips
if "!Action!"=="6" (
    echo Creating BPS patch...
    set SMWROM=
    if not exist "%WORKING_DIR%sysLMRestore\smwOrig.smc" (
        echo Could not find an unmodified SMW file. Enter the path to an original, unmodified SMW smc: 
        set /p SMWROM=
    ) else (
        set SMWROM="%WORKING_DIR%sysLMRestore\smwOrig.smc"
    )
    "%WORKING_DIR%\flips.exe" --create --bps !SMWROM! !ROMFILE! !PATCHNAME!
)

popd

if "!Action!"=="0" (
    echo Have a nice day ^^_^^
    exit /b
)
if '!Action!'=='' echo Nothing is not valid option, please try again.
