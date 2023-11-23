@echo off
cls

:: Working Directory
setlocal DisableDelayedExpansion
set WORKING_DIR=%~dp0
set WORKING_DIR=%WORKING_DIR:!=^^!%
setlocal EnableDelayedExpansion

:: get root directory since this script runs from the LM folder
set "ROOT_DIR=!WORKING_DIR:\tools\lunar_magic=!"

:: Other Defines
set "tools_dir=!ROOT_DIR!tools\"

:: readme
set "readme=!ROOT_DIR!README.html"
:: callisto
set "callisto_path=!ROOT_DIR!buildtool\callisto.exe"
:: addmusick
set "amk_path=!tools_dir!addmusick"
set "amk_list=!amk_path!\Addmusic_list.txt"
:: pixi
set "pixi_path=!tools_dir!pixi"
set "pixi_list=!pixi_path!\list.txt"
:: gps
set "gps_path=!tools_dir!gps"
set "gps_list=!gps_path!\list.txt"
:: uberasm
set "uber_path=!tools_dir!uberasmtool"
set "uber_list=!uber_path!\list.txt"
:: asar patches
set "patches_path=!ROOT_DIR!resources\patches"
set "patches_list=!ROOT_DIR!buildtool\resources.toml"


:ParseArgs
if "%~1"=="" goto :EOF

if /i "%~1"=="--file" (
    set file=%~2
    goto :RunEditor
)
if /i "%~1"=="--path" (
    set path=%~2
    goto :OpenDir
)
if /i "%~1"=="--app" (
    set path=%~2
    set app=%~3
    set param=%~4
    goto :OpenApp
)
if /i "%~1"=="--callisto" (
    set param=%~2
    goto :RunCallisto
)
goto :ParseArgs

:RunEditor
start "" /b "%file%"
goto :Exit

:RunCallisto
setlocal enabledelayedexpansion
if "%param%"=="" (
    start "" /i /wait "%callisto_path%"
) else (
    start "" /b /i /wait "%callisto_path%" "%param%"
    pause
)
endlocal
goto :Exit

:OpenDir
start "" /b "%path%"
goto :Exit

:OpenApp
start "" /i /wait "%path%\%app%" %param%
goto :Exit

:Exit
exit