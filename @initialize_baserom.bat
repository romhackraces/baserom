@echo off
cls
:start

:: Working Directory 
setlocal DisableDelayedExpansion
set WORKING_DIR=%~sdp0
set WORKING_DIR=%WORKING_DIR:!=^^!%
setlocal EnableDelayedExpansion

:: Directory definitions
set TOOLS_DIR=%WORKING_DIR%Tools\
set LISTS_DIR=%WORKING_DIR%Backup\Lists\
set BACKUP_DIR=%WORKING_DIR%Backup\

:: Import Definitions
call %WORKING_DIR%Shared\@tool_defines.bat

:: Options
echo Commands to Initialize Baserom
echo.
echo   1. Download and Setup all Baserom tools
echo   0. Exit
echo.
set /p Action=Enter the number of your choice: 

:: Download Baserom Tools
if "!Action!"=="1" (

    :: AddMusicK
    set AMK_DIR=!TOOLS_DIR!AddMusicK_1.0.8\
    :: Check if AMK exists and download if not
    if not exist "!AMK_DIR!AddmusicK.exe" (
        echo AddmusicK not found, downloading...
        powershell Invoke-WebRequest !AMK_DL! -OutFile !AMK_ZIP! >NUL
        powershell Expand-Archive !AMK_ZIP! -DestinationPath !TOOLS_DIR! >NUL
        :: Delete junk files
        for %%a in (!AMK_JUNK!) do (del !AMK_DIR!%%a)
        for %%a in (!AMK_JUNK_DIR!) do (rmdir /S /Q !AMK_DIR!%%a)
        :: Copy in existing list file(s)
        for %%a in (!AMK_LISTS!) do (copy /y !LISTS_DIR!%%a !AMK_DIR!)
        :: Delete Zip
        del !AMK_ZIP!
        echo Done.
    ) else (
        echo -- AddmusicK already setup.
    )

    :: Asar
    set ASAR_DIR=!TOOLS_DIR!Asar\
    :: Check if Asar exists and download if not
    if not exist "!ASAR_DIR!asar.exe" (
        echo Asar not found, downloading...
        powershell Invoke-WebRequest !ASAR_DL! -OutFile !ASAR_ZIP! >NUL
        powershell Expand-Archive !ASAR_ZIP! -DestinationPath !ASAR_DIR! >NUL
        :: Delete junk files
        for %%a in (!ASAR_JUNK!) do (del !ASAR_DIR!%%a)
        for %%a in (!ASAR_JUNK_DIR!) do (rmdir /S /Q !ASAR_DIR!%%a)
        :: Delete Zip
        del !ASAR_ZIP!
        echo Done.
    ) else (
        echo -- Asar already setup.
    )


    :: Flips
    set FLIPS_DIR=!TOOLS_DIR!Flips\
    :: Check if Flips exists and download if not
    if not exist "!FLIPS_DIR!flips.exe" (
        echo Flips not found, downloading...
        powershell Invoke-WebRequest !FLIPS_DL! -OutFile !FLIPS_ZIP! >NUL
        powershell Expand-Archive !FLIPS_ZIP! -DestinationPath !FLIPS_DIR! >NUL
        :: Delete junk files
        for %%a in (!FLIPS_JUNK!) do (del !FLIPS_DIR!%%a)
        :: Delete Zip
        del !FLIPS_ZIP!
        echo Done.
    ) else (
        echo -- Flips already setup.
    )


    :: GPS
    set GPS_DIR=!TOOLS_DIR!GPS\
    :: Check if GPS exists and download if not
    if not exist "!GPS_DIR!" (
        echo GPS not found, downloading...
        powershell Invoke-WebRequest !GPS_DL! -OutFile !GPS_ZIP! >NUL
        powershell Expand-Archive !GPS_ZIP! -DestinationPath !GPS_DIR! >NUL
        :: Delete junk files
        for %%a in (!GPS_JUNK!) do (del !GPS_DIR!%%a)
        :: Delete Zip
        del !GPS_ZIP!
        echo Done.
    ) else (
        echo -- GPS already setup.
    )

    :: Human Readable Map16 CLI
    set HRM_DIR=!TOOLS_DIR!HumanReadableMap16\
    :: Check if HRM exists and download if not
    if not exist "!HRM_DIR!" (
        echo Human Readable Map16 CLI not found, downloading...
        powershell Invoke-WebRequest !HRM_DL! -OutFile !HRM_ZIP! >NUL
        powershell Expand-Archive !HRM_ZIP! -DestinationPath !HRM_DIR! >NUL
        :: Delete junk files
        for %%a in (!HRM_JUNK!) do (del !HRM_DIR!%%a)
        :: Delete Zip
        del !HRM_ZIP!
        echo Done.
    ) else (
        echo -- Human Readable Map16 CLI already setup.
    )

    :: Lunar Magic
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
    ) else (
        echo -- Lunar Magic already setup.
    )

    :: Lunar Helper
    set LUN_HLP_DIR=%WORKING_DIR%LunarHelper\
    :: Check if Lunar Helper exists and download if not
    if not exist "!LUN_HLP_DIR!LunarHelper.exe" (
        echo Lunar Helper not found, downloading...
        powershell Invoke-WebRequest !LUN_HLP_DL! -OutFile !LUN_HLP_ZIP! >NUL
        powershell Expand-Archive !LUN_HLP_ZIP! -DestinationPath !LUN_HLP_DIR! >NUL
        :: Delete junk files
        for %%a in (!LUN_HLP_JUNK!) do (del !LUN_HLP_DIR!%%a)
        for %%a in (!LUN_HLP_JUNK_DIR!) do (rmdir /S /Q !LUN_HLP_DIR!%%a)
        :: Delete Zip
        del !LUN_HLP_ZIP!
        echo Done.
    ) else (
        echo -- Lunar Helper already setup.
    )

    :: Lunar Monitor
    set LUN_MON_DIR=!TOOLS_DIR!LunarMagic\
    :: Check if Lunar Monitor exists and download if not
    if not exist "!LUN_MON_DIR!lunar-monitor.dll" (
        echo Lunar Monitor not found, downloading...
        powershell Invoke-WebRequest !LUN_MON_DL! -OutFile !LUN_MON_ZIP! >NUL
        powershell Expand-Archive !LUN_MON_ZIP! -DestinationPath !LUN_MON_DIR! >NUL
        :: Move files
        echo Moving files to relevant locations...
        move !LUN_MON_DIR!lunar-monitor-config.txt %WORKING_DIR%
        move !LUN_MON_DIR!LM3.31\lunar-monitor.dll !LUN_MON_DIR!
        :: Delete junk files
        for %%a in (!LUN_MON_JUNK!) do (del !LUN_MON_DIR!%%a)
        for %%a in (!LUN_MON_JUNK_DIR!) do (rmdir /S /Q !LUN_MON_DIR!%%a)
        :: Copy in existing config file
        copy /y !BACKUP_DIR!lunar-monitor-config.txt %WORKING_DIR%
        :: Delete Zip
        del !LUN_MON_ZIP!
        echo Done.
    ) else (
        echo -- Lunar Monitor already setup.
    )

    :: PIXI
    set PIXI_DIR=!TOOLS_DIR!PIXI\
    :: Check if PIXI exists and download if not
    if not exist "!PIXI_DIR!pixi.exe" (
        echo PIXI not found, downloading...
        powershell Invoke-WebRequest !PIXI_DL! -OutFile !PIXI_ZIP! >NUL
        powershell Expand-Archive !PIXI_ZIP! -DestinationPath !PIXI_DIR! >NUL
        :: Delete junk files
        for %%a in (!PIXI_JUNK!) do (del !PIXI_DIR!%%a)
        :: Delete Zip
        del !PIXI_ZIP!
        echo Done.
    ) else (
        echo -- PIXI already setup.
    )

    :: UberASM Tool
    set UBER_DIR=!TOOLS_DIR!UberASMTool\
    :: Check if UberASM exists and download if not
    if not exist "!UBER_DIR!UberASMTool.exe" (
        echo UberASMTool not found, downloading...
        powershell Invoke-WebRequest !UBER_DL! -OutFile !UBER_ZIP! >NUL
        powershell Expand-Archive !UBER_ZIP! -DestinationPath !UBER_DIR! >NUL
        :: Make null files in empty folders
        copy /y NUL !UBER_DIR!gamemode\_gitkeep
        copy /y NUL !UBER_DIR!overworld\_gitkeep
        copy /y NUL !UBER_DIR!level\_gitkeep
        echo ; > !UBER_DIR!library\_gitkeep
        :: Delete junk files
        for %%a in (!UBER_JUNK!) do (del !UBER_DIR!%%a)
        :: Delete Zip
        del !UBER_ZIP!
        echo Done.
    ) else (
        echo -- UberASMTool already setup.
    )
)

if "!Action!"=="0" (
    echo Have a nice day ^^_^^
    exit /b
)

if '!Action!'=='' echo Nothing is not valid option, please try again.
