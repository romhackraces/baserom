@echo off
cls
:start

:: Working Directory
setlocal DisableDelayedExpansion
set WORKING_DIR=%~dp0
set WORKING_DIR=%WORKING_DIR:!=^^!%
setlocal EnableDelayedExpansion

:: get root directory since this script runs from the LM folder
set "ROOT_DIR=%WORKING_DIR:\tools\lunar_magic=%"

:: Other Defines
set TOOLS_DIR=%ROOT_DIR%tools\

:: addmusick
set amk_path=!TOOLS_DIR!addmusick
set amk_list=!amk_path!\Addmusic_list.txt
:: pixi
set pixi_path=!TOOLS_DIR!pixi
set pixi_list=!pixi_path!\list.txt
:: gps
set gps_path=!TOOLS_DIR!gps
set gps_list=!gps_path!\list.txt
:: uberasm
set uber_path=!TOOLS_DIR!uberasmtool
set uber_list=!uber_path!\list.txt

go
set p=%~2
set p=%~3 & set p2=%p:'="%
set p=%~4 & set p3=%p:'="%
set p=%~5 & set p4=%p:'="%
set p=%~6 & set p5=%p:'="%
set p=%~7 & set p6=%p:'="%
set p=%~8 & set p7=%p:'="%
set p=%~9 & set p8=%p:'="%
set p=%~9 & set p9=%p:'="%

start "" %p2% %p3% %p4% %p5% %p6% %p7% %p8% %p9%
exit