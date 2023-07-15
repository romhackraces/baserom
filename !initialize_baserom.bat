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
set TMP_DIR=%WORKING_DIR%temp\
set CONF_DIR=%WORKING_DIR%Other\Config\
set LISTS_DIR=%WORKING_DIR%Other\Lists\

:: Import Definitions
call %WORKING_DIR%Tools\tool_defines.bat

:: Options
:Menu
echo -----------------------------------
echo Baserom Initialization Script
echo -----------------------------------
echo.
echo What would you like to to?
echo.
echo   1. Download and Setup all Baserom tools
echo   2. Restore Baserom list files.
echo   3. Setup Baserom's custom Lunar Magic toolbar.
echo   0. Exit
echo.
set /p "Action=Enter the number of your choice: "
echo.

:: Check if input was a number
for /F "delims=0123" %%i in ("!Action!") do (
    cls
    echo "%%i" is not a valid option, please try again.
    echo.
    goto Menu
)
cls

:: Download Baserom Tools
if "!Action!"=="1" (

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
        echo.
    ) else (
        echo -- AddmusicK already setup.
    )

    :: Check if Asar exists and download if not
    if not exist "!ASAR_DIR!asar.exe" (
        echo Asar not found, downloading...
        powershell Invoke-WebRequest !ASAR_DL! -OutFile !ASAR_ZIP! >NUL
        powershell Expand-Archive !ASAR_ZIP! -DestinationPath !ASAR_DIR! >NUL
        :: replace stock list with baserom list
        copy /y !LISTS_DIR!!ASAR_LIST! !ASAR_DIR!
        :: Delete junk files
        for %%a in (!ASAR_JUNK!) do (del !ASAR_DIR!%%a)
        for %%a in (!ASAR_JUNK_DIR!) do (rmdir /S /Q !ASAR_DIR!%%a)
        :: Delete Zip
        del !ASAR_ZIP!
        echo.
    ) else (
        echo -- Asar already setup.
    )

    :: Check if Flips exists and download if not
    if not exist "!FLIPS_DIR!flips.exe" (
        echo Flips not found, downloading...
        powershell Invoke-WebRequest !FLIPS_DL! -OutFile !FLIPS_ZIP! >NUL
        powershell Expand-Archive !FLIPS_ZIP! -DestinationPath !FLIPS_DIR! >NUL
        :: Delete junk files
        for %%a in (!FLIPS_JUNK!) do (del !FLIPS_DIR!%%a)
        :: Delete Zip
        del !FLIPS_ZIP!
        echo.
    ) else (
        echo -- Flips already setup.
    )

    :: Check if GPS exists and download if not
    if not exist "!GPS_DIR!gps.exe" (
        echo GPS not found, downloading...
        powershell Invoke-WebRequest !GPS_DL! -OutFile !GPS_ZIP! >NUL
        powershell Expand-Archive !GPS_ZIP! -DestinationPath !GPS_DIR! >NUL
        :: replace stock list with baserom list
        copy /y !LISTS_DIR!!GPS_LIST! !GPS_DIR!list.txt
        :: Delete junk files
        for %%a in (!GPS_JUNK!) do (del !GPS_DIR!%%a)
        :: Delete Zip
        del !GPS_ZIP!
        echo.
    ) else (
        echo -- GPS already setup.
    )

    :: Check if Lunar Magic exists and download if not
    if not exist "!LM_DIR!Lunar Magic.exe" (
        echo Lunar Magic not found, downloading...
        powershell Invoke-WebRequest !LM_DL! -OutFile !LM_ZIP! >NUL
        powershell Expand-Archive !LM_ZIP! -DestinationPath !LM_DIR! >NUL
        :: Delete junk files
        for %%a in (!LM_JUNK!) do (del !LM_DIR!%%a)
        :: Delete Zip
        del !LM_ZIP!
        echo.
    ) else (
        echo -- Lunar Magic already setup.
    )

    :: Check if Lunar Helper exists and download if not
    if not exist "!LUN_HLP_DIR!LunarHelper.exe" (
        echo Lunar Helper not found, downloading...
        powershell Invoke-WebRequest !LUN_HLP_DL! -OutFile !LUN_HLP_ZIP! >NUL

        :: Create Temp directory
        if not exist "!TMP_DIR!" (mkdir !TMP_DIR!)
        :: Download Lunar Helper + Lunar Monitor archive
        powershell Expand-Archive !LUN_HLP_ZIP! -DestinationPath !TMP_DIR! >NUL

        :: Move Lunar Helper Files
        copy /y !TMP_DIR!"LunarHelper"\* !LUN_HLP_DIR!
        :: Delete junk files
        for %%a in (!LUN_HLP_JUNK!) do (del !LUN_HLP_DIR!%%a)
        for %%a in (!LUN_HLP_JUNK_DIR!) do (rmdir /S /Q !LUN_HLP_DIR!%%a)

        :: Move Lunar Monitor Files
        copy /y !TMP_DIR!"LunarMonitor"\* !LUN_MON_DIR!
        move /y !TMP_DIR!"LunarMonitor"\lunar_monitor !LUN_MON_DIR!
        :: Delete junk files
        for %%a in (!LUN_MON_JUNK!) do (del !LUN_MON_DIR!%%a)
        for %%a in (!LUN_MON_JUNK_DIR!) do (rmdir /S /Q !LUN_MON_DIR!%%a)

        :: Copy in existing config file
        copy /y !CONF_DIR!\lunar-monitor-config.txt %WORKING_DIR%

        :: Delete Temp directory
        rmdir /S /Q !TMP_DIR!
        :: Delete Zip
        del !LUN_HLP_ZIP!
        echo.
    ) else (
        echo -- Lunar Helper already setup.
    )

    :: Check if PIXI exists and download if not
    if not exist "!PIXI_DIR!pixi.exe" (
        echo PIXI not found, downloading...
        powershell Invoke-WebRequest !PIXI_DL! -OutFile !PIXI_ZIP! >NUL
        powershell Expand-Archive !PIXI_ZIP! -DestinationPath !PIXI_DIR! >NUL
        :: replace stock list with baserom list
        copy /y !LISTS_DIR!!PIXI_LIST! !PIXI_DIR!list.txt
        :: Delete junk files
        for %%a in (!PIXI_JUNK!) do (del !PIXI_DIR!%%a)
        :: Delete Zip
        del !PIXI_ZIP!
        echo.
    ) else (
        echo -- PIXI already setup.
    )

    :: Check if UberASM exists and download if not
    if not exist "!UBER_DIR!UberASMTool.exe" (
        echo UberASMTool not found, downloading...
        powershell Invoke-WebRequest !UBER_DL! -OutFile !UBER_ZIP! >NUL
        powershell Expand-Archive !UBER_ZIP! -DestinationPath !UBER_DIR! >NUL
        :: Make null files in empty folders
        copy /y NUL !UBER_DIR!gamemode\.gitkeep
        copy /y NUL !UBER_DIR!overworld\.gitkeep
        copy /y NUL !UBER_DIR!level\.gitkeep
        echo ; > !UBER_DIR!library\_gitkeep
        :: replace stock list with baserom list
        copy /y !LISTS_DIR!!UBER_LIST! !UBER_DIR!list.txt
        :: Delete junk files
        for %%a in (!UBER_JUNK!) do (del !UBER_DIR!%%a)
        :: Delete Zip
        del !UBER_ZIP!
        echo.
    ) else (
        echo -- UberASMTool already setup.
    )

    goto Menu
)

:: Restore Baserom list files
if "!Action!"=="2" (
    :: Copy in existing list file(s) to respective folders
    for %%a in (!AMK_LISTS!) do (copy /y !LISTS_DIR!%%a !AMK_DIR!)
    copy /y !LISTS_DIR!!GPS_LIST! !GPS_DIR!list.txt
    copy /y !LISTS_DIR!!PIXI_LIST! !PIXI_DIR!list.txt
    copy /y !LISTS_DIR!!UBER_LIST! !UBER_DIR!list.txt
    echo Done.
    echo.
    goto Menu
)

:: Setup Custom Baserom user toolbar
if "!Action!"=="3" (
    :: Setup Usertoolbar things
    echo Setting up custom Lunar Magic toolbar...
    copy /y !CONF_DIR!usertoolbar\usertoolbar.txt !LM_DIR!
    copy /y !CONF_DIR!usertoolbar\usertoolbar_icons.bmp !LM_DIR!
    copy /y !CONF_DIR!usertoolbar\usertoolbar_wrapper.bat !LM_DIR!
    echo Done.
    echo.
    goto Menu
)


if "!Action!"=="0" (
    echo Have a nice day ^^_^^
    exit /b
)

if '!Action!'=='' echo Nothing is not valid option, please try again.

echo.
echo All done. Have a nice day ^^_^^
echo.
pause
exit /b