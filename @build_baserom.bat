@echo off
Setlocal EnableDelayedExpansion
cls
:start

:: Variables
set ROMFILE="%~dp0RHR4.smc"
set PATCHNAME=RHR4.bps

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
    pushd .\common\
    for /f "tokens=*" %%a in (%ASAR_LIST%) do (.\asar.exe -v asar\%%a !ROMFILE!)
    echo Done.
)
:: Insert custom blocks with GPS
if "!Action!"=="2" (
    echo Inserting custom blocks...
    pushd .\common\
    .\gps.exe -l %GPS_LIST% !ROMFILE!
    echo Done.
)
:: Insert Custom Sprites with PIXI
if "!Action!"=="3" (
    echo Inserting custom sprites...
    pushd .\common\
    .\pixi.exe -l common\%PIXI_LIST% !ROMFILE!
    echo Done.
)
:: Insert custom music with AddmusicK
if "!Action!"=="4" (
    echo Inserting custom Music...
    pushd .\common\AddmusicK_1.0.8\
    .\AddmusicK.exe !ROMFILE!
    echo Done.
)
:: Insert custom uberASM
if "!Action!"=="5" (
    echo Inserting UberASM...
    pushd .\common\
    .\UberASMTool.exe %UBER_LIST% !ROMFILE!
    echo Done.
)
:: Create bps Patch with Flips
if "!Action!"=="6" (
    echo Creating BPS patch...
	set SMWROM=
	if not exist %~dp0sysLMRestore\smwOrig.smc (
		echo Could not find an unmodified SMW file. Enter the path to an original, unmodified SMW smc: 
		set /p SMWROM=
	) else (
		set SMWROM=%~dp0sysLMRestore\smwOrig.smc
	)
	pushd .\common\
    .\flips.exe --create --bps !SMWROM! !ROMFILE! ..\RHR4.bps
    echo Done.
)

popd

if "!Action!"=="0" (
    exit /b
)
if '!Action!'=='' echo Nothing is not valid option, please try again.
