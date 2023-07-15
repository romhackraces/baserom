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

:: Menu
:BuildMenu
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
echo   6. Create BPS Patch using Flips
echo   0. Exit
echo.
set /p "Action=Enter the number of your choice: "

:: Check if input was a number
for /F "delims=0123456" %%i in ("!Action!") do (
    cls
    echo "%%i" is not a valid option, please try again.
    echo.
    goto BuildMenu
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
        for /f "tokens=*" %%a in (%PATCH_LIST%) do (asar.exe -v %%a !ROM_FILE!)
        echo.
        goto BuildMenu
    )
)

:: Insert custom blocks with GPS
if /i "!Action!"=="2" (
    echo Inserting custom blocks...
    pushd !GPS_DIR!
    gps.exe !ROM_FILE!
    echo.
    goto BuildMenu
)

:: Insert Custom Sprites with PIXI
set PIXI_LIST=!PIXI_DIR!list.txt
if /i "!Action!"=="3" (
    echo Inserting custom sprites...
    pushd !PIXI_DIR!
    pixi.exe -l "%PIXI_LIST%" !ROM_FILE!
    echo.
    goto BuildMenu
)

:: Insert custom music with AddmusicK
if /i "!Action!"=="4" (
    echo Inserting custom Music...
    pushd !AMK_DIR!
    AddmusicK.exe !ROM_FILE!
    echo.
    goto BuildMenu
)

:: Insert custom uberASM
set UBER_LIST=!UBER_DIR!list.txt
if /i "!Action!"=="5" (
    echo Inserting UberASM...
    pushd !UBER_DIR!
    UberASMTool.exe "%UBER_LIST%" !ROM_FILE!
    echo.
    goto BuildMenu
)

:: Create bps Patch with Flips
if /i "!Action!"=="6" (
    echo Creating BPS patch...
    set SMWROM=
    if not exist !CLEAN_ROM! (
        echo Could not find an unmodified SMW file. Enter the path to an original, unmodified SMW smc:
        set /p SMWROM=
    ) else (
        set SMWROM=!CLEAN_ROM!
    )
    if errorlevel == 1 goto :EOF
    pushd !FLIPS_DIR!
    flips.exe --create --bps !SMWROM! !ROM_FILE! !PATCH_FILE!
    echo.
    goto BuildMenu
)

:: Exit
if /i "!Action!"=="0" (
    echo Have a nice day ^^_^^
    exit /b
)
popd
