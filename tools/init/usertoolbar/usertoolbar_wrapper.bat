@echo off
cls

:: Working Directory
setlocal DisableDelayedExpansion
set WORKING_DIR=%~sdp0
set WORKING_DIR=%WORKING_DIR:!=^^!%
setlocal EnableDelayedExpansion

:: get root directory since this script runs from the LM folder
set "ROOT_DIR=%WORKING_DIR:\tools\lunar_magic=%"

:: Other Defines
set tools_dir=%ROOT_DIR%tools\

:: addmusick
set amk_path=!tools_dir!addmusick
set amk_list=!amk_path!\Addmusic_list.txt
:: pixi
set pixi_path=!tools_dir!pixi
set pixi_list=!pixi_path!\list.txt
:: gps
set gps_path=!tools_dir!gps
set gps_list=!gps_path!\list.txt
:: uberasm
set uber_path=!tools_dir!uberasmtool
set uber_list=!uber_path!\list.txt

setlocal enabledelayedexpansion

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
    set app=%~2
    goto :OpenApp
)
goto :ParseArgs

:RunEditor
start "" /b %file%
goto :Exit

:OpenDir
start "" /b %path%
goto :Exit

:OpenApp
start "" /b "%app%"
goto :Exit

:Exit
exit