# --------------------------------------------------
# Common functions for the initialization script
# --------------------------------------------------

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

    Write-Host "Moving $ToolName documentation..." -ForegroundColor DarkGray

    if (-not (Test-Path -Path "$ToolsDocsDir\$ToolName" -PathType Container)) {
        New-Item -Path "$ToolsDocsDir\$ToolName" -ItemType Directory -Force | Out-Null
    }

    if ($DocFiles -ne $null -and $DocFiles.Count -gt 0) {
        foreach ($file in $DocFiles) {
            $sourcePath = Join-Path -Path $Directory -ChildPath $file
            $destinationPath = Join-Path -Path $ToolsDocsDir -ChildPath $ToolName
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
# Generic Tool Set Up Function
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

# --------------------------------------------------
# These are initialization functions that are specialized for specific tools.
# --------------------------------------------------

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



# --------------------------------------------------
# Some tools require additional set up. These functions
# perform those steps as part of their initialization process.
# --------------------------------------------------


# Extra steps for AddMusicK
function PostSetup-AddMusicK {
    Write-Host "Restructuring AddMusicK folder..." -ForegroundColor DarkGray
    # Copy AddMusicK list files to tool directory
    Copy-Item -Path "$ListsDir\Addmusic*" -Destination $DestinationDir -ErrorAction Stop
}

# Extra steps for Lunar Magic
function PostSetup-LunarMagic {
    Write-Host "Installing baserom User Toolbar alongside Lunar Magic..." -ForegroundColor DarkGray
    # copy usertoolbar files to Lunar Magic directory
    Copy-Item -Path "$SetupDir\usertoolbar\usertoolbar.txt" -Destination $LunarMagic_Dir -Force
    Copy-Item -Path "$SetupDir\usertoolbar\usertoolbar_icons.bmp" -Destination $LunarMagic_Dir -Force
    Copy-Item -Path "$SetupDir\usertoolbar\usertoolbar_wrapper.bat" -Destination $LunarMagic_Dir -Force
}

# Extra steps for PIXI
function PostSetup-PIXI {
    Write-Host "Resolving ASM conflict in PIXI and UberASM Tool..." -ForegroundColor DarkGray

    # Replace part of main.asm to fix conflict with uberasm tool
    $findText = Get-Content "$SetupDir\pixi\main.asm.find" -Raw
    $replaceText = Get-Content "$SetupDir\pixi\main.asm.replace" -Raw

    # Get PIXI file
    $origFile = "$PIXI_Dir\asm\main.asm"
    $tempFile = "$PIXI_Dir\asm\main.asm~"

    # Escape "$0" because powershell is unhappy with it
    $replaceText = $replaceText -replace '\$0', '$0'

    # Read file as a string to process
    $content = Get-Content $origFile -Raw
    $replacedContent = $content.Replace($findText, $replaceText)

    # Write the modified content to a new file
    Set-Content -Path $tempFile -Value $replacedContent

    # Replace the file with the modified version
    Copy-Item $tempFile $origFile -Force
}


# Extra steps for Callisto
function PostSetup-Callisto {
    # Copy over Callisto's initial BPS patches
    Write-Host "Copying over Callisto's initial BPS patches..." -ForegroundColor DarkGray
    Copy-Item -Path "$Callisto_Dir\initial_patches\LunarMagic3.51\initial_patch_fastrom.bps" -Destination "$ResourcesDir\initial_patches\fastrom.bps" -Force
    Copy-Item -Path "$Callisto_Dir\initial_patches\LunarMagic3.51\initial_patch_sa1.bps" -Destination "$ResourcesDir\initial_patches\sa1.bps" -Force

    # Install Callisto's modified asar dll.
    Write-Host "Replacing tool-specific Asar DLLs with Callisto versions..." -ForegroundColor DarkGray
    Copy-Item -Path "$Callisto_Dir\asar\v1.91\64-bit\asar.dll" -Destination $GPS_Dir -Force
    Copy-Item -Path "$Callisto_Dir\asar\v1.91\32-bit\asar.dll" -Destination $UberASMTool_Dir -Force
    Copy-Item -Path "$Callisto_Dir\asar\v1.91\32-bit\asar.dll" -Destination $AddMusicK_Dir -Force | Remove-Item $AddMusicK_Dir\asar.exe
    Copy-Item -Path "$Callisto_Dir\asar\v1.91\64-bit\asar.dll" -Destination $PIXI_Dir -Force
}
