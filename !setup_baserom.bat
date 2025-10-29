@echo off
cls
:: Batch script wrapper to run the main PowerShell script with an Execution Policy bypass
powershell.exe -ExecutionPolicy Bypass .\setup\setup_baserom.ps1
pause