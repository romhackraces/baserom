@echo off
cls
:start

:: Variables
set ROMFILE="..\RHR4.smc"

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
if "%Action%"=="1" (
    echo Applying patches...
    cd .\common\
    for /f "tokens=*" %%a in (list_asar.txt) do (.\asar.exe -v asar\%%a %ROMFILE%)
    echo Done.
)
:: Insert custom blocks with GPS
if "%Action%"=="2" (
    echo Inserting custom blocks...
    cd .\common\
    .\gps.exe -l "list_gps.txt" %ROMFILE%
    echo Done.
)
:: Insert Custom Sprites with PIXI
if "%Action%"=="3" (
    echo Inserting custom sprites...
    cd .\common\
    .\pixi.exe -l "common\list_pixi.txt" %ROMFILE%
    echo Done.
)
:: Insert custom music with AddmusicK
if "%Action%"=="4" (
    echo Inserting custom Music...
    cd .\AddmusicK_1.0.8\
    .\AddmusicK.exe %ROMFILE%
    echo Done.
)
:: Insert custom uberASM
if "%Action%"=="5" (
    echo Inserting UberASM...
    cd .\common\
    .\UberASMTool.exe "list_uberasm.txt"
    echo Done.
)
:: Create bps Patch with Flips
if "%Action%"=="6" (
    echo Creating BPS patch...
    cd .\common\
    .\flips.exe --create --bps ..\sysLMRestore\smwOrig.smc ..\RHR4.smc ..\RHR4.bps
    echo Done.
)
if "%Action%"=="0" (
    exit
)
if '%Action%'=='' echo %choice%" is not valid please try again.
