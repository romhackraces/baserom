@echo off
cls

set "cleanRom=%CD%\resources\clean.smc"

if exist "%cleanRom%" (
    powershell.exe -ExecutionPolicy Bypass .\tools\common\initialize_core.ps1
) else (
    echo -- Cannot Proceed --
    echo.
    echo You have not provided a clean Super Mario World ROM for use with the baserom tools.
    echo Please put a copy of your ROM in ^"resources^" folder renamed to ^"clean.smc^"
    echo.
)

pause
