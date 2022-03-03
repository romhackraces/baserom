@echo off
cls
:start

:: Variables
set ROMFILE="%~dp0RHR4.smc"
setlocal
for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set DateTime=%%a

set Year=%DateTime:~0,4%
set Month=%DateTime:~4,2%
set Day=%DateTime:~6,2%
set Hour=%DateTime:~8,2%
set Minute=%DateTime:~10,2%

set TIMESTAMP="%Year%%Month%%Day%_%Hour%%Minute%"

:: Options
echo Backup Actions
echo.
echo   1. Export all modified levels to files
echo   2. Export all of Map16
echo   3. Export shared palettes
echo   4. Create time-stamped backup of your ROM
echo   0. Exit
echo.
set /p Action=Enter the number of your choice: 


:: Export MWL level files
if "%Action%"=="1" (
    echo Exporting Levels...
	if not exist %~dp0Levels\%TIMESTAMP% (
		mkdir "%~dp0Levels\%TIMESTAMP%"
	)

	if not exist %~dp0Levels\latest (
		mkdir "%~dp0Levels\latest"
	)

    "%~dp0common\Lunar Magic.exe" -ExportMultLevels "%ROMFILE%" "%~dp0Levels\%TIMESTAMP%\level" 
    "%~dp0common\Lunar Magic.exe" -ExportMultLevels "%ROMFILE%" "%~dp0Levels\latest\level"  
    echo Done.
)
:: Export Map16
if "%Action%"=="2" (
    echo Exporting Map16...
	echo %~dp0
	if not exist %~dp0Map16 (
		mkdir "%~dp0Map16"
	)
    "%~dp0common\Lunar Magic.exe" -ExportAllMap16 "%ROMFILE%" "%~dp0Map16\AllMap16_%TIMESTAMP%.map16" 
    "%~dp0common\Lunar Magic.exe" -ExportAllMap16 "%ROMFILE%" "%~dp0Map16\AllMap16_latest.map16" 
    echo Done.
)
:: Export Palettes
if "%Action%"=="3" (
    echo Exporting Palettes...
	if not exist %~dp0Palettes (
		mkdir "%~dp0Palettes"
	)
    "%~dp0common\Lunar Magic.exe" -ExportSharedPalette "%ROMFILE%" "%~dp0Palettes\%TIMESTAMP%_Shared.pal"
    "%~dp0common\Lunar Magic.exe" -ExportSharedPalette "%ROMFILE%" "%~dp0Palettes\Shared_latest.pal"
    echo Done.
)
:: Create time-stamped backup of your ROM
if "%Action%"=="4" (
	if not exist %~dp0Backup (
		mkdir %~dp0Backup
	)
    echo Creating time-stamped copy of your ROM...
    copy %ROMFILE% "%~dp0Backup\%TIMESTAMP%_RHR4.smc"
    copy %ROMFILE% "%~dp0Backup\latest_RHR4.smc"
    echo Done.
)
if "%Action%"=="0" (
    exit /b
)
if '%Action%'=='' echo Nothing is not valid option, please try again.
