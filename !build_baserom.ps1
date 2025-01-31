Clear-Host

$OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

# Directory Definitions
$WorkingDir = Get-Location
$BuildDir = "$WorkingDir\build"
$ConfigDir = "$WorkingDir\config"
$DocsDir = "$WorkingDir\docs"
$ModulesDir = "$WorkingDir\modules"
$ToolsDir = "$WorkingDir\tools"

# Include defines
. $ToolsDir\init\tool_defines.ps1
# Include module build scripts
. $BuildDir\setup_module_retry.ps1

# Start the main menu loop
$UserChoice = $null
while ($UserChoice -ne "3") {
    Write-Host "-----------------------------"
    Write-Host "RHR Baserom v5 - Build Script"
    Write-Host "-----------------------------`n"
    Write-Host "1) Build Retry System module"
    Write-Host "0) Exit`n"

    $UserChoice = Read-Host "Enter the number of your choice"

    if ($UserChoice -notin ("0", "1", "2")) {
        Write-Host "`n'$UserChoice' is not a valid option, please try again.`n"
        continue
    }

    switch ($UserChoice) {

        # Download and Setup all Baserom Tools
        "1" {
            Clear-Host
            Setup-Module-Retry "Retry System"
        }

        # Exit
        "0" {
            Clear-Host
            Write-Host "Have a nice day ^_^"
            exit 0
        }
    }
}

