@echo off
cls
:start

:: ROM Details
set ROM_NAME=RHR4

:: DO NOT CHANGE THE VARIABLES BELOW

:: Working Directory 
setlocal DisableDelayedExpansion
set WORKING_DIR=%~dp0
set WORKING_DIR=%WORKING_DIR:!=^^!%
setlocal EnableDelayedExpansion

:: Variables
set ROMFILE="%WORKING_DIR%%ROM_NAME%.smc"
set PATCHNAME="%WORKING_DIR%%ROM_NAME%.bps"

:: Tools
call %WORKING_DIR%@baserom_tools.bat

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
    :: Asar Defines
    set ASAR_DIR=%WORKING_DIR%Asar\
    set ASAR_LIST=list_asar.txt
    :: Check if Asar exists and download if not
    if not exist !ASAR_DIR!asar.exe (
        echo Executable for Asar not found, downloading...
        powershell Invoke-WebRequest !ASAR_DL! -OutFile %ASAR_ZIP% >NUL
        powershell Expand-Archive !ASAR_ZIP! -DestinationPath !ASAR_DIR! >NUL
        :: Delete junk files
        del %WORKING_DIR%%ASAR_ZIP%
        pushd !ASAR_DIR!
        for %%a in (!ASAR_JUNK!) do (del !ASAR_DIR!%%a)
        for %%a in (!ASAR_JUNK_DIR!) do (rmdir /S /Q !ASAR_DIR!%%a)
        echo Done.
    )
    echo Applying Asar patches...
    pushd !ASAR_DIR!
    for /f "tokens=*" %%a in (!ASAR_LIST!) do (asar.exe -v %%a !ROMFILE!)
    pause
)
:: Insert custom blocks with GPS
if "!Action!"=="2" (
    :: GPS Defines
    set GPS_DIR=%WORKING_DIR%GPS\
    set GPS_LIST=list_gps.txt
    :: Check if GPS exists and download if not
    if not exist "!GPS_DIR!gps.exe" (
        echo Executable for GPS not found, downloading...
        powershell Invoke-WebRequest !GPS_DL! -OutFile !GPS_ZIP! >NUL
        powershell Expand-Archive !GPS_ZIP! -DestinationPath !GPS_DIR! >NUL
        :: Delete junk files
        del %WORKING_DIR%!GPS_ZIP!
        pushd !GPS_DIR!
        for %%a in (!GPS_JUNK!) do (del !GPS_DIR!%%a)
        echo Done.
    )
    echo Inserting custom blocks...
    pushd !GPS_DIR!
    gps.exe -l !GPS_LIST! !ROMFILE!
    pause
)
:: Insert Custom Sprites with PIXI
if "!Action!"=="3" (
    :: PIXI Defines
    set PIXI_DIR=%WORKING_DIR%PIXI\
    set PIXI_LIST=!PIXI_DIR!list_pixi.txt
    :: Check if PIXI exists and download if not
    if not exist !PIXI_DIR!pixi.exe (
        echo Executable for PIXI not found, downloading...
        powershell Invoke-WebRequest !PIXI_DL! -OutFile !PIXI_ZIP! >NUL
        powershell Expand-Archive !PIXI_ZIP! -DestinationPath !PIXI_DIR! >NUL
        :: Delete junk files
        del %WORKING_DIR%!PIXI_ZIP!
        pushd !PIXI_DIR!
        for %%a in (!PIXI_JUNK!) do (del !PIXI_DIR!%%a)
        echo Done.
    )
    echo Inserting custom sprites...
    pushd !PIXI_DIR!
    pixi.exe -l !PIXI_LIST! !ROMFILE!
    pause
)
:: Insert custom music with AddmusicK
if "!Action!"=="4" (
    :: AddmusicK Defines
    set AMK_DIR=%WORKING_DIR%AddmusicK_1.0.8\
    :: Check if AMK exists and download if not
    if not exist !AMK_DIR!AddmusicK.exe (
        echo Executable for AddmusicK not found, downloading...
        powershell Invoke-WebRequest !AMK_DL! -OutFile !AMK_ZIP! >NUL
        powershell Expand-Archive !AMK_ZIP! -DestinationPath %WORKING_DIR%\ >NUL
        :: Delete junk files
        del %WORKING_DIR%!AMK_ZIP!
        pushd !AMK_DIR!
        for %%a in (!AMK_JUNK!) do (del !AMK_DIR!%%a)
        for %%a in (!AMK_JUNK_DIR!) do (rmdir /S /Q !AMK_DIR!%%a)
        echo Done.
    )
    echo Inserting custom Music...
    pushd !AMK_DIR!
    AddmusicK.exe !ROMFILE!
    pause
)
:: Insert custom uberASM
if "!Action!"=="5" (
    :: UberASM Defines
    set UBER_DIR=%WORKING_DIR%UberASM\
    set UBER_LIST=list_uberasm.txt
    :: Check if UberASM exists and download if not
    if not exist "!UBER_DIR!UberASMTool.exe" (
        echo Executable for UberASMTool not found, downloading...
        powershell Invoke-WebRequest !UBER_DL! -OutFile !UBER_ZIP! >NUL
        powershell Expand-Archive !UBER_ZIP! -DestinationPath !UBER_DIR! >NUL
        :: Delete junk files
        del %WORKING_DIR%!UBER_ZIP!
        for %%a in (!UBER_JUNK!) do (del !UBER_DIR!%%a)
        echo Done.
    )
    echo Inserting UberASM...
    pushd !UBER_DIR!
    UberASMTool.exe !UBER_LIST! !ROMFILE!
    pause
)
:: Create bps Patch with Flips
if "!Action!"=="6" (
    :: Check if Flips exists and download if not
    if not exist "%WORKING_DIR%\flips.exe" (
        echo Executable for Flips not found, downloading...
        powershell Invoke-WebRequest !FLIPS_DL! -OutFile !FLIPS_ZIP! >NUL
        powershell Expand-Archive !FLIPS_ZIP! -DestinationPath %WORKING_DIR%\ >NUL
        :: Delete junk files
        del %WORKING_DIR%\!FLIPS_ZIP!
        pushd %WORKING_DIR%\
        for %%a in (!FLIPS_JUNK!) do (del !FLIPS_DIR!%%a)
        echo Done.
    )
    echo Creating BPS patch...
    set SMWROM=
    if not exist "%WORKING_DIR%sysLMRestore\smwOrig.smc" (
        echo Could not find an unmodified SMW file. Enter the path to an original, unmodified SMW smc: 
        set /p SMWROM=
    ) else (
        set SMWROM="%WORKING_DIR%sysLMRestore\smwOrig.smc"
    )
    "%WORKING_DIR%\flips.exe" --create --bps !SMWROM! !ROMFILE! !PATCHNAME!
    pause
)

popd

if "!Action!"=="0" (
    echo Have a nice day ^^_^^
    exit /b
)
if '!Action!'=='' echo Nothing is not valid option, please try again.
