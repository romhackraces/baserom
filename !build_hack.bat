@echo off
cls
:start

:: Working Directory
setlocal DisableDelayedExpansion
set WORKING_DIR=%~sdp0
set WORKING_DIR=%WORKING_DIR:!=^^!%
setlocal EnableDelayedExpansion


:: Clean ROM
set CLEAN_ROM=clean.smc

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

:: Directory definitions
set TOOLS_DIR=%WORKING_DIR%Tools\

:: Import Definitions
call %WORKING_DIR%Tools\tool_defines.bat

:: Variables
set ROMFILE=%WORKING_DIR%%ROM_NAME%.smc
set PATCHNAME=%WORKING_DIR%%ROM_NAME%.bps

:: Lunar Helper Check
set BUILD_PREF=%WORKING_DIR%Other\build-preference.txt
:: Check if build-preference.txt exists
:BuildPref
if not exist !BUILD_PREF! (
    echo Before you begin:
    echo.
    echo The Lunar Helper tool is the recommended method for building the baserom as it can resolve conflicts more readily and insure an issue-free build.
    echo However, if you are comfortable using batch files and resolving issues manually while building your hack, this scriptset will be useful.
    echo.
    set /p Input="Are you sure you want to use the build scripts instead? (Y/N): "
    :: Confirm choice
    if /i "!Input!"=="Y" (
        :: Create preference file
        .>!BUILD_PREF! 2>NUL
        cls
        goto Menu
    ) else if /i "!Input!"=="N" (
        echo.
        echo Have a nice day ^^_^^
        exit /b
    ) else (
        echo.
        echo "!Input!" is not a valid option, please try again.
        echo.
        goto BuildPref
    )
)

:: Build Script Menu and actions
:Menu
echo ------------------------------
echo Baserom Build Script
echo ------------------------------
echo.
echo What would you like to to?
echo.
echo   1. Apply all Asar Patches
echo   2. Insert Blocks with GPS
echo   3. Insert Sprites with PIXI
echo   4. Insert Music with AddMusicK
echo   5. Insert UberASM with UberASMTool
echo   6. Create BPS Patch using FLIPS
echo   0. Exit
echo.
set /p "Action=Enter the number of your choice: "

:: Check if input was a number
for /F "delims=0123456" %%i in ("!Action!") do (
    cls
    echo "%%i" is not a valid option, please try again.
    echo.
    goto Menu
)
cls

:: Apply asar patches
set PATCH_LIST=patchlist.txt
if /i "!Action!"=="1" (
    echo Applying patches...
    if not exist !ASAR_DIR!/!PATCH_LIST! (
        echo The list of patches for Asar is not found.
    ) else (
        pushd !ASAR_DIR!
        for /f "tokens=*" %%a in (%PATCH_LIST%) do (asar.exe -v %%a !ROMFILE!)
        echo.
        goto Menu
    )
)

:: Insert custom blocks with GPS
if /i "!Action!"=="2" (
    echo Inserting custom blocks...
    pushd !GPS_DIR!
    gps.exe !ROMFILE!
    echo.
    goto Menu
)

:: Insert Custom Sprites with PIXI
set PIXI_LIST=!PIXI_DIR!\list.txt
if /i "!Action!"=="3" (
    echo Inserting custom sprites...
    pushd !PIXI_DIR!
    pixi.exe -l "%PIXI_LIST%" !ROMFILE!
    echo.
    goto Menu
)

:: Insert custom music with AddmusicK
if /i "!Action!"=="4" (
    echo Inserting custom Music...
    pushd !AMK_DIR!
    AddmusicK.exe !ROMFILE!
    echo.
    goto Menu
)

:: Insert custom uberASM
set UBER_LIST=!UBER_DIR!\list.txt
if /i "!Action!"=="5" (
    echo Inserting UberASM...
    pushd !UBER_DIR!
    UberASMTool.exe "%UBER_LIST%" !ROMFILE!
    echo.
    echo.
    goto Menu
)

:: Create bps Patch with Flips
if /i "!Action!"=="6" (
    echo Creating BPS patch...
    set SMWROM=
    if not exist "%WORKING_DIR%%CLEAN_ROM%" (
        echo Could not find an unmodified SMW file. Enter the path to an original, unmodified SMW smc:
        set /p SMWROM=
    ) else (
        set SMWROM="%WORKING_DIR%%CLEAN_ROM%"
    )
    pushd !FLIPS_DIR!
    flips.exe --create --bps !SMWROM! !ROMFILE! !PATCHNAME!
    echo.
    goto Menu
)

:: Exit
if /i "!Action!"=="0" (
    echo Have a nice day ^^_^^
    exit /b
)

popd
pause
endlocal
exit /b