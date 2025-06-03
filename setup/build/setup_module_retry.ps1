#
# Retry Module Set Up Function
#
function Setup-Module-Retry($Name) {
    $is_done = $false
    $has_errors = $false

    # source files for module
    $RetryDir = "$IncludesDir\retry-system"

    # baserom config files for module
    $RetryConfDir = "$ConfigDir\retry_config"

    try {
        Write-Host "`n$Name is not set up."
        # Remove old installation of retry
        Write-Host "Removing older version of $Name from baserom..." -ForegroundColor DarkGray
        # Remove retry_config to purge files
        if (Test-Path -Path "$UberASMTool_Dir\retry_config" -PathType Container) {
            Remove-Item -Path "$UberASMTool_Dir\retry_config" -Recurse -Force
        }
        # Remove gamemode files in case there is a change
        $gamemode_files = Get-ChildItem "$UberASMTool_Dir\gamemode\retry_gm*"
        if ($gamemode_files) {
            Remove-Item -Path "$UberASMTool_Dir\gamemode\retry_gm*" -Force
        }
        # Install Retry by copy
        Write-Host "Copying Baserom configuration for $Name..." -ForegroundColor DarkGray
        # Move directories recursively
        Copy-Item -Path "$RetryDir\src\retry_config" -Destination $UberASMTool_Dir -Force -Recurse
        Copy-Item -Path "$RetryDir\src\gamemode" -Destination $UberASMTool_Dir -Force -Recurse
        Copy-Item -Path "$RetryDir\src\library" -Destination $UberASMTool_Dir -Force -Recurse
        # Copy Baserom Config Files
        Copy-Item -Path $RetryConfDir -Destination $UberASMTool_Dir -Force -Recurse
        # Move Readme files
        Copy-Item -Path "$RetryDir\docs\*" -Destination "$DocsDir\retry-system" -Force -Recurse
        # Set done
        $is_done = $true
    } catch {
        $has_errors = $true
        Write-Host "An error occurred setting up $Name.`n" -ForegroundColor Red
    }
    # Done
    if ($is_done) {
        Write-Host "Done."
    }
    if ($has_errors) {
        Write-Host "$Name module failed to be setup correctly.`n" -ForegroundColor DarkYellow
    } else {
        Write-Host "$Name module was setup successfully.`n" -ForegroundColor Green
    }
}