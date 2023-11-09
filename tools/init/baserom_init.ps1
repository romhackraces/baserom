Clear-Host

# Directory Definitions
$WorkingDir = Get-Location
$ToolsDir = "$WorkingDir\tools"
$DocsDir = "$WorkingDir\docs\tools"
$ResourcesDir = "$WorkingDir\resources"
$ListsDir = "$ToolsDir\init\lists"

# Dot includes
. $ToolsDir\init\tool_defines.ps1

# Hide git-related files
$filePatterns = @("*.gitkeep", "*.gitignore", "*.github")
$filesToHide = Get-ChildItem -Path $WorkingDir -Recurse -Include $filePatterns
foreach ($file in $filesToHide) {$file.Attributes += [System.IO.FileAttributes]::Hidden}

# Function to remove junk files
function Remove-Junk($Directory, $JunkFiles) {
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
    Write-Host "$Name is not set up. `nDownloading..."
    Invoke-WebRequest -Uri $Url -OutFile "$env:temp\$Name.zip"
}

# Generic function to set up a tool
function SetupTool($ToolName, $DownloadUrl, $DestinationDir, $JunkFiles, $DocFiles, $ListFile) {
    if (Test-Path "$DestinationDir.is_setup" -PathType Leaf) {
        Write-Host "-- $ToolName already is set up in: $DestinationDir"
    } else {
        try {
            # Download Tool
            Download-Tool $ToolName $DownloadUrl
            # Expand Archive
            Expand-Archive -Path "$env:temp\$ToolName.zip" -DestinationPath $DestinationDir -Force
            # Move Readme files
            Move-Docs $ToolName $DocFiles $DestinationDir
            # Clean up junk files
            Remove-Junk $DestinationDir $JunkFiles
            # Copy pre-existing list file (if it exists)
            if ($ListFile -ne "") {
                Copy-Item -Path "$ListsDir\$ListFile" -Destination "$DestinationDir\list.txt" -Force
            }
            # Create is_setup checkfile
            CheckFile-Create $DestinationDir
            # Done
            Write-Host "Done. `n"
        } catch {
            Write-Host "An error occurred setting up $ToolName."
        }
    }

    # Lunar Magic
    if ($ToolName -eq "Lunar Magic") {
        # copy usertoolbar files to Lunar Magic directory
        Copy-Item -Path "$ToolsDir\init\usertoolbar\usertoolbar.txt" -Destination $LunarMagic_Dir -Force
        Copy-Item -Path "$ToolsDir\init\usertoolbar\usertoolbar_icons.bmp" -Destination $LunarMagic_Dir -Force
        Copy-Item -Path "$ToolsDir\init\usertoolbar\usertoolbar_wrapper.bat" -Destination $LunarMagic_Dir -Force
    }
}

# Specific function to set AddMusicK
function SetupAMK($ToolName, $DownloadUrl, $DestinationDir, $JunkFiles, $DocFiles) {
    if (Test-Path "$DestinationDir.is_setup" -PathType Leaf) {
        Write-Host "-- $ToolName already is set up in: $DestinationDir"
    } else {
        try {
            # Download Tool
            Download-Tool $ToolName $DownloadUrl
            # AddMusicK specific actions because zip is subfolder >:(
            Expand-Archive -Path $env:temp\$ToolName.zip -DestinationPath $env:temp\ -Force
            Copy-Item "$env:temp\AddmusicK_*\*" -Destination $DestinationDir -Recurse -Force
            # Move Readme files
            Move-Docs $ToolName $DocFiles $DestinationDir
            # Clean up junk files
            Remove-Junk $DestinationDir $JunkFiles
            # Copy AddMusicK list files to tool directory
            Copy-Item -Path "$ListsDir\Addmusic*" -Destination $DestinationDir
            # Create is_setup checkfile
            CheckFile-Create $DestinationDir
            # Done
            Write-Host "Done. `n"
        } catch {
            Write-Host "An error occurred setting up $ToolName."
        }
    }
}

# Specific function to set up Callisto
function SetupCallisto($ToolName, $DownloadUrl, $DestinationDir, $JunkFiles, $DocFiles) {
    if (Test-Path "$DestinationDir.is_setup" -PathType Leaf) {
        Write-Host "-- $ToolName already is set up in: $DestinationDir"
    } else {
        try {
            # Download Tool
            Download-Tool $ToolName $DownloadUrl
            # Expand Archive
            Expand-Archive -Path "$env:temp\$ToolName.zip" -DestinationPath $DestinationDir -Force
            # Copy over Callisto's initial BPS patches
            Copy-Item -Path "$Callisto_Dir\initial_patches\initial_patch_fastrom.bps" -Destination "$ResourcesDir\initial_patches\fastrom.bps" -Force
            Copy-Item -Path "$Callisto_Dir\initial_patches\initial_patch_sa1.bps" -Destination "$ResourcesDir\initial_patches\sa1.bps" -Force
            # Install Callisto's modified asar dll.
            Copy-Item -Path "$Callisto_Dir\asar\32-bit\asar.dll" -Destination $GPS_Dir -Force
            Copy-Item -Path "$Callisto_Dir\asar\32-bit\asar.dll" -Destination $AddMusicK_Dir -Force | Remove-Item $AddMusicK_Dir\asar.exe
            Copy-Item -Path "$Callisto_Dir\asar\32-bit\asar.dll" -Destination $UberASMTool_Dir -Force
            Copy-Item -Path "$Callisto_Dir\asar\64-bit\asar.dll" -Destination $PIXI_Dir -Force
            # Move Readme files
            Move-Docs $ToolName $DocFiles $DestinationDir
            # Clean up junk files
            Remove-Junk $DestinationDir $JunkFiles
            # Create is_setup checkfile
            CheckFile-Create $DestinationDir
            # Done
            Write-Host "Done. `n"
        } catch {
            Write-Host "An error occurred setting up $ToolName."
        }
    }
}

# Start the main menu loop
$UserChoice = $null
while ($UserChoice -ne "4") {
    Write-Host "`n-------------------------------"
    Write-Host "RHR Baserom v5 - Initialization"
    Write-Host "-------------------------------`n"
    Write-Host "Welcome! To get started with the baserom, run both of the following steps:`n"
    Write-Host "1. Download and set up all baserom tools"
    Write-Host "2. Run a first build of the baserom in Callisto"
    Write-Host "0. Exit`n"

    $UserChoice = Read-Host "Enter the number of your choice"

    if ($UserChoice -notin ("0", "1", "2")) {
        Write-Host "`n'$UserChoice' is not a valid option, please try again.`n"
        continue
    }

    switch ($UserChoice) {

        # Download and Setup all Baserom Tools
        "1" {
            Clear-Host
            Write-Host "Checking state of tools...`n"
            SetupAMK  "AddMusicK" $AddMusicK_Download $AddMusicK_Dir $AddMusicK_Junk $AddMusicK_Docs ""
            SetupTool "Flips" $Flips_Download $Flips_Dir $Flips_Junk $Flips_Docs ""
            SetupTool "GPS" $GPS_Download $GPS_Dir $GPS_Junk $GPS_Docs "list_gps.txt" # name of list in initial_lists
            SetupTool "PIXI" $PIXI_Download $PIXI_Dir $PIXI_Junk $PIXI_Docs "list_pixi.txt" # name of list in initial_lists
            SetupTool "Lunar Magic" $LunarMagic_Download $LunarMagic_Dir $LunarMagic_Junk $LunarMagic_Docs ""
            SetupTool "UberASMTool" $UberASMTool_Download $UberASMTool_Dir $UberASMTool_Junk $UberASMTool_Docs "list_uberasm.txt" # name of list in initial_lists
            SetupCallisto "Callisto" $Callisto_Download $Callisto_Dir $Callisto_Junk $Callisto_Docs ""
            Write-Host "`nTool setup complete."
        }

        # Ensure user has run first build of Callisto so the baserom exists
        "2" {
            Clear-Host
            # Check if Callisto is setup
            if (Test-Path "$Callisto_Dir.is_setup" -PathType Leaf) {
                # Check if first-build was already done
                if (Test-Path "$Callisto_Dir.first_build_done" -PathType Leaf) {
                    Write-Host "First build already performed.`n`nYou can work on your project by running Callisto from the 'buildtool' folder."
                } else {
                    # Try performing a first-build
                    try {
                        Write-Host "Running a first-build in Callisto...`n"
                        $command = "$Callisto_Dir\callisto.exe"
                        $args = "rebuild"
                        $process = Start-Process -FilePath $command -ArgumentList $args -Wait -PassThru -NoNewWindow
                        $exitCode = $process.ExitCode
                        # If callisto succeeds, create checkfile, if not don't.
                        if ($exitCode -eq 0) {
                            # Create checkfile if all goes well
                            New-Item -Path "$Callisto_Dir.first_build_done" -ItemType File -Force | Out-Null
                            Set-ItemProperty -Path "$Callisto_Dir.first_build_done" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden) | Out-Null
                            Write-Host "First build completed successfully.`n`nYou can get started on your project by running Callisto from the 'buildtool' folder."
                        } else {
                            # Prompt users to run Callisto manually if there was an error
                            Write-Host "Baserom failed to build. Please run Callisto manually from the 'buildtool' folder, and perform a 'Rebuild' to see any errors."
                        }
                    } catch {
                        Write-Host "First build did not complete successfully. Please try again."
                    }
                }
            } else {
                # Prompt to run step 1 if not setup
                Write-Host "`nCallisto is not set up, please run Step 1 first."
            }
        }

        # Exit
        "0" {
            Clear-Host
            Write-Host "Have a nice day ^_^"
            exit 0
        }
    }
}