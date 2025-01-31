# Common functions for the initialization script

# Function to remove junk files
function Remove-Junk($Directory, $JunkFiles) {
    Write-Host "Removing junk files..." -ForegroundColor DarkGray
    # Iterate through list of "junk"
    foreach ($item in $JunkFiles) {
        # Get path of item
        $itemPath = Join-Path -Path $Directory -ChildPath $item
        if (Test-Path -Path $itemPath) {
            # Check if file or directory and delete accordingly
            if (Test-Path -Path $itemPath -PathType Leaf) {
                Remove-Item -Path $itemPath -Force
            } else {
                Remove-Item -Path $itemPath -Recurse -Force
            }
        }
    }
}

# Function to move documentation files
function Move-Docs($ToolName, $DocFiles, $Directory) {

    Write-Host "Copying $ToolName documentation to 'docs' folder..." -ForegroundColor DarkGray

    if (-not (Test-Path -Path "$DocsDir\$ToolName" -PathType Container)) {
        New-Item -Path "$DocsDir\$ToolName" -ItemType Directory -Force | Out-Null
    }

    if ($DocFiles -ne $null -and $DocFiles.Count -gt 0) {
        foreach ($file in $DocFiles) {
            $sourcePath = Join-Path -Path $Directory -ChildPath $file
            $destinationPath = Join-Path -Path $DocsDir -ChildPath $ToolName
            if (Test-Path -Path $sourcePath) {
                if (Test-Path -Path $sourcePath -PathType Container) {
                    # Move directories recursively
                    Copy-Item -Path $sourcePath -Destination $destinationPath -Force -Recurse
                    Remove-Item -Path $sourcePath -Recurse -Force
                } else {
                    # Move files
                    Move-Item -Path $sourcePath -Destination $destinationPath -Force
                }
            }
        }
    }
}

# Function to create .is_setup check file
function CheckFile-Create($Directory) {
    # Create is_setup checkfile
    New-Item -Path "$Directory.is_setup" -ItemType File | Out-Null
    # Make it a hidden file
    Set-ItemProperty -Path "$Directory.is_setup" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden) | Out-Null
}

# Function to Download tool
function Download-Tool($Name, $Url) {
    Write-Host "Downloading $Name..." -ForegroundColor DarkGray
    Invoke-WebRequest -Uri $Url -OutFile "$env:temp\$Name.zip"
}

# Function to copy pre-filled list file
function Copy-List($Name, $Directory, $List) {
    Write-Host "Copying baserom list file(s) for $Name..." -ForegroundColor DarkGray
    if ($List -ne $null -and $List -ne "") {
        Copy-Item -Path "$ListsDir\$List" -Destination "$Directory\list.txt" -Force -ErrorAction Stop
    }
}

#
# Generic Set Up Function
#
# Takes the download URL, output directory, junk files list, documentation list,
# list file name and extra function name as parameters.
#
function Setup-Tool($ToolName, $DownloadUrl, $DestinationDir, $JunkFiles, $DocFiles, $ListFile, $ExtraFunction) {
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
            # Expand Archive
            Write-Host "Installing $ToolName..." -ForegroundColor DarkGray
            Expand-Archive -Path "$env:temp\$ToolName.zip" -DestinationPath $DestinationDir -Force -ErrorAction Stop
            # Run Extra Step if set
            if ($ExtraFunction -ne $null -and $ExtraFunction -ne "") {
                Write-Host "Running additional steps for $ToolName..."
                & $ExtraFunction
            }
            # Move Readme files
            Move-Docs $ToolName $DocFiles $DestinationDir -ErrorAction Stop
            # Clean up junk files
            Remove-Junk $DestinationDir $JunkFiles -ErrorAction Stop
            # Copy pre-existing list file (if it exists)
            Copy-List $ToolName $DestinationDir $ListFile -ErrorAction Stop
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