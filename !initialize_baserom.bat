@echo off
cls

set "cleanRom=%CD%\resources\clean.smc"

:: Check if clean rom exists as it is required by Callisto
if exist "%cleanRom%" (
    :: run the main PowerShell script with an Execution Policy bypass
    powershell.exe -ExecutionPolicy Bypass .\tools\init\baserom_init.ps1
) else (
    :: Give warning message about missing clean rom
    echo -- Cannot Proceed --
    echo.
    echo You have not provided a clean Super Mario World ROM for use with the baserom tools.
    echo Please put a copy of your ROM in ^"resources^" folder renamed to ^"clean.smc^"
    echo.
)
pause