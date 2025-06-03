# These are initialization functions that are specialized for specific tools.

# Specific function to set up AddMusicK
function SetupAMK($ToolName, $DownloadUrl, $DestinationDir, $JunkFiles, $DocFiles) {
    if (Test-Path "$DestinationDir.is_setup" -PathType Leaf) {
        Write-Host ([char]0x2713) -NoNewline -ForegroundColor Green
        Write-Host " $ToolName already is set up in: " -NoNewline
        Write-Host "$DestinationDir"
    } else {
        $done = $false
        try {
            Write-Host "`n$ToolName is not set up."
            # Download Tool
            Download-Tool $ToolName $DownloadUrl -ErrorAction Stop
            # AddMusicK specific actions because zip is subfolder >:(
            Write-Host "Installing $ToolName..." -ForegroundColor DarkGray
            Expand-Archive -Path $env:temp\$ToolName.zip -DestinationPath $env:temp\ -Force -ErrorAction Stop
            Copy-Item "$env:temp\AddmusicK_*\*" -Destination $DestinationDir -Recurse -Force -ErrorAction Stop
            # Move Readme files
            Write-Host "Copying documentation..." -ForegroundColor DarkGray
            Move-Docs $ToolName $DocFiles $DestinationDir -ErrorAction Stop
            # Clean up junk files
            Remove-Junk $DestinationDir $JunkFiles -ErrorAction Stop
            # Copy AddMusicK list files to tool directory
            Copy-Item -Path "$ListsDir\Addmusic*" -Destination $DestinationDir -ErrorAction Stop
            # Set done
            $done = $true
        } catch {
            $global:has_errors = "yes"
            Write-Host "An error occurred setting up $ToolName.`n" -ForegroundColor Red
        }
        # Check if successful
        if ($done) {
            # Create is_setup checkfile
            CheckFile-Create $DestinationDir
            # Done
            Write-Host "Done. `n"
        }
    }
}
