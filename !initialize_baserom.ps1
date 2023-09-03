# ---------------------------------------------------------
# Baserom initialization PowerShell script
# ---------------------------------------------------------
Clear-Host

# Directory Definitions
$WorkingDir = Get-Location
$ToolsDir = "$WorkingDir\tools"
$TempDir = "$WorkingDir\temp\"
$ListsDir = "$WorkingDir\resources\initial_lists\"

# Dot includes
. $ToolsDir\common\tool_defines.ps1
# . $ToolsDir\common\build_script_common.ps1

# Make TempDir if it doesn't exist
if (-not (Test-Path -Path $TempDir -PathType Container)) {
    New-Item -Path $TempDir -ItemType Directory | Out-Null
}

# Display a menu
$UserChoice = $null

# Aliases for the menu item actions
$ChoiceAliases = @{
    "0" = "Exit"
    "1" = "InitializeTools"
    "2" = "InitializeListFiles"
    "3" = "SetupUserToolbar"
}

# Start the main menu loop
while ($UserChoice -ne "4") {
    Write-Host "------------------------------"
    Write-Host "Initialize Baserom"
    Write-Host "------------------------------`n"
    Write-Host "What would you like to to?`n"
    Write-Host "1. Download and Setup all Baserom Tools"
    Write-Host "2. Restore Baserom list files."
    Write-Host "3. Setup Baserom's custom Lunar Magic toolbar."
    Write-Host "0. Exit`n"

    $UserChoice = Read-Host "Enter the number of your choice"

    # Check if the input is not in the valid range
    if ($UserChoice -notin $ChoiceAliases.Keys) {
        Write-Host "`n'$UserChoice' is not a valid option, please try again.`n"
        continue
    }

    # Change the alias to the actual option
    $Action = $ChoiceAliases[$UserChoice]
    # Process option input
    switch ($Action) {

        # Initialize Tools
        "InitializeTools" {

            # Check if AddMusicK directory has set-up checkfile
            $ToolName = "AddMusicK"
            if (Test-Path "$AddMusicK_Dir.is_setup" -PathType Leaf) {
                Write-Host "-- $ToolName already is set up in: $AddMusicK_Dir"
            } else {
                try {
                    Write-Host "$ToolName is not set up. `nDownloading..."
                    # Download zip file
                    Invoke-WebRequest -Uri $AddMusicK_Download -OutFile $TempDir$AddMusicK_Archive
                    Expand-Archive -Path $TempDir$AddMusicK_Archive -DestinationPath $TempDir -Force
                    # AddMusicK specific actions because zip is subfolder >:(
                    Copy-Item "$TempDir\AddmusicK_*\*" -Destination $AddMusicK_Dir -Recurse | Out-Null
                    # Delete junk files
                    foreach ($item in $AddMusicK_Junk) {
                        if (Test-Path -Path $AddMusicK_Dir$item) {
                            if (
                                Test-Path -Path $AddMusicK_Dir$item -PathType Leaf) {
                                    Remove-Item -Path $AddMusicK_Dir$item -Force
                                }
                            else {
                                Remove-Item -Path $AddMusicK_Dir$item -Recurse -Force
                            }
                        }
                    }
                    # Create is_setup checkfile
                    New-Item -Path "$AddMusicK_Dir.is_setup" -ItemType File | Out-Null
                    Set-ItemProperty -Path "$AddMusicK_Dir.is_setup" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden) | Out-Null
                    # Done
                    Write-Host "Done. `n"
                } catch {
                    Write-Host "An error occurred setting up $ToolName."
                }
            }

            # Check if Flips directory has set-up checkfile
            $ToolName = "Flips"
            if (Test-Path "$Flips_Dir.is_setup" -PathType Leaf) {
                Write-Host "-- $ToolName already is set up in: $Flips_Dir"
            } else {
                try {
                    Write-Host "$ToolName is not set up. `nDownloading..."
                    # Download zip file
                    Invoke-WebRequest -Uri $Flips_Download -OutFile $TempDir$Flips_Archive
                    Expand-Archive -Path $TempDir$Flips_Archive -DestinationPath $Flips_Dir -Force
                    # Delete junk files
                    foreach ($item in $Flips_Junk) {
                        if (Test-Path -Path $Flips_Dir$item) {
                            if (
                                Test-Path -Path $Flips_Dir$item -PathType Leaf) {
                                    Remove-Item -Path $Flips_Dir$item -Force
                                }
                            else {
                                Remove-Item -Path $Flips_Dir$item -Recurse -Force
                            }
                        }
                    }
                    # Create is_setup checkfile
                    New-Item -Path "$Flips_Dir.is_setup" -ItemType File | Out-Null
                    Set-ItemProperty -Path "$Flips_Dir.is_setup" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden) | Out-Null
                    # Done
                    Write-Host "Done. `n"
                } catch {
                    Write-Host "An error occurred setting up $ToolName."
                }
            }

            # Check if GPS directory has set-up checkfile
            $ToolName = "GPS"
            if (Test-Path "$GPS_Dir.is_setup" -PathType Leaf) {
                Write-Host "-- $ToolName already is set up in: $GPS_Dir"
            } else {
                try {
                    Write-Host "$ToolName is not set up. `nDownloading..."
                    # Download zip file
                    Invoke-WebRequest -Uri $GPS_Download -OutFile $TempDir$GPS_Archive
                    Expand-Archive -Path $TempDir$GPS_Archive -DestinationPath $GPS_Dir -Force
                    # Delete junk files
                    foreach ($item in $GPS_Junk) {
                        if (Test-Path -Path $GPS_Dir$item) {
                            if (
                                Test-Path -Path $GPS_Dir$item -PathType Leaf) {
                                    Remove-Item -Path $GPS_Dir$item -Force
                                }
                            else {
                                Remove-Item -Path $GPS_Dir$item -Recurse -Force
                            }
                        }
                    }
                    # Create is_setup checkfile
                    New-Item -Path "$GPS_Dir.is_setup" -ItemType File | Out-Null
                    Set-ItemProperty -Path "$GPS_Dir.is_setup" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden) | Out-Null
                    # Done
                    Write-Host "Done. `n"
                } catch {
                    Write-Host "An error occurred setting up $ToolName."
                }
            }
            # Check if PIXI directory has set-up checkfile
            $ToolName = "PIXI"
            if (Test-Path "$PIXI_Dir.is_setup" -PathType Leaf) {
                Write-Host "-- $ToolName already is set up in: $PIXI_Dir"
            } else {
                try {
                    Write-Host "$ToolName is not set up. `nDownloading..."
                    # Download zip file
                    Invoke-WebRequest -Uri $PIXI_Download -OutFile $TempDir$PIXI_Archive
                    Expand-Archive -Path $TempDir$PIXI_Archive -DestinationPath $PIXI_Dir -Force
                    # Delete junk files
                    foreach ($item in $PIXI_Junk) {
                        if (Test-Path -Path $PIXI_Dir$item) {
                            if (
                                Test-Path -Path $PIXI_Dir$item -PathType Leaf) {
                                    Remove-Item -Path $PIXI_Dir$item -Force
                                }
                            else {
                                Remove-Item -Path $PIXI_Dir$item -Recurse -Force
                            }
                        }
                    }
                    # Create is_setup checkfile
                    New-Item -Path "$PIXI_Dir.is_setup" -ItemType File | Out-Null
                    Set-ItemProperty -Path "$PIXI_Dir.is_setup" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden) | Out-Null
                    # Done
                    Write-Host "Done. `n"
                } catch {
                    Write-Host "An error occurred setting up $ToolName."
                }
            }

            # Check if Lunar Magic directory has set-up checkfile
            $ToolName = "Lunar Magic"
            if (Test-Path "$LunarMagic_Dir.is_setup" -PathType Leaf) {
                Write-Host "-- $ToolName already is set up in: $LunarMagic_Dir"
            } else {
                try {
                    Write-Host "$ToolName is not set up. `nDownloading..."
                    # Download zip file
                    Invoke-WebRequest -Uri $LunarMagic_Download -OutFile $TempDir$LunarMagic_Archive
                    Expand-Archive -Path $TempDir$LunarMagic_Archive -DestinationPath $LunarMagic_Dir -Force
                    # Delete junk files
                    foreach ($item in $LunarMagic_Junk) {
                        if (Test-Path -Path $LunarMagic_Dir$item) {
                            if (
                                Test-Path -Path $LunarMagic_Dir$item -PathType Leaf) {
                                    Remove-Item -Path $LunarMagic_Dir$item -Force
                                }
                            else {
                                Remove-Item -Path $LunarMagic_Dir$item -Recurse -Force
                            }
                        }
                    }
                    # Create is_setup checkfile
                    New-Item -Path "$LunarMagic_Dir.is_setup" -ItemType File | Out-Null
                    Set-ItemProperty -Path "$LunarMagic_Dir.is_setup" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden) | Out-Null
                    # Done
                    Write-Host "Done. `n"
                } catch {
                    Write-Host "An error occurred setting up $ToolName."
                }
            }

            # Check if UberASMTool directory has set-up checkfile
            $ToolName = "UberASMTool"
            if (Test-Path "$UberASMTool_Dir.is_setup" -PathType Leaf) {
                Write-Host "-- $ToolName already is set up in: $UberASMTool_Dir"
            } else {
                try {
                    Write-Host "$ToolName is not set up. `nDownloading..."
                    # Download zip file
                    Invoke-WebRequest -Uri $UberASMTool_Download -OutFile $TempDir$UberASMTool_Archive
                    Expand-Archive -Path $TempDir$UberASMTool_Archive -DestinationPath $UberASMTool_Dir -Force
                    # Delete junk files
                    foreach ($item in $UberASMTool_Junk) {
                        if (Test-Path -Path $UberASMTool_Dir$item) {
                            if (
                                Test-Path -Path $UberASMTool_Dir$item -PathType Leaf) {
                                    Remove-Item -Path $UberASMTool_Dir$item -Force
                                }
                            else {
                                Remove-Item -Path $UberASMTool_Dir$item -Recurse -Force
                            }
                        }
                    }
                    # Create is_setup checkfile
                    New-Item -Path "$UberASMTool_Dir.is_setup" -ItemType File | Out-Null
                    Set-ItemProperty -Path "$UberASMTool_Dir.is_setup" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden) | Out-Null
                    # Done
                    Write-Host "Done. `n"
                } catch {
                    Write-Host "An error occurred setting up $ToolName."
                }
            }

            # Check if Callisto directory has set-up checkfile
            $ToolName = "Callisto"
            if (Test-Path "$Callisto_Dir.is_setup" -PathType Leaf) {
                Write-Host "-- $ToolName already is set up in: $Callisto_Dir"
            } else {
                try {
                    Write-Host "$ToolName is not set up. `nDownloading..."
                    # Download zip file
                    Invoke-WebRequest -Uri $Callisto_Download -OutFile $TempDir$Callisto_Archive
                    Expand-Archive -Path $TempDir$Callisto_Archive -DestinationPath $Callisto_Dir -Force
                    # Install Callisto's modified asar dll.
                    Copy-Item -Path "$Callisto_Dir\asar\32-bit\asar.dll" -Destination $GPS_Dir
                    Copy-Item -Path "$Callisto_Dir\asar\32-bit\asar.dll" -Destination $AddMusicK_Dir | Remove-Item $AddMusicK_Dir\asar.exe
                    Copy-Item -Path "$Callisto_Dir\asar\32-bit\asar.dll" -Destination $UberASMTool_Dir
                    Copy-Item -Path "$Callisto_Dir\asar\64-bit\asar.dll" -Destination $PIXI_Dir
                    # Delete junk files
                    foreach ($item in $Callisto_Junk) {
                        if (Test-Path -Path $Callisto_Dir$item) {
                            if (
                                Test-Path -Path $Callisto_Dir$item -PathType Leaf) {
                                    Remove-Item -Path $Callisto_Dir$item -Force
                                }
                            else {
                                Remove-Item -Path $Callisto_Dir$item -Recurse -Force
                            }
                        }
                    }
                    # Create is_setup checkfile
                    New-Item -Path "$Callisto_Dir.is_setup" -ItemType File | Out-Null
                    Set-ItemProperty -Path "$Callisto_Dir.is_setup" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden) | Out-Null
                    # Done
                    Write-Host "Done. `n"
                } catch {
                    Write-Host "An error occurred setting up $ToolName."
                }
            }
            # Done
            Write-Host "All done. `n"
            continue

        }

        # Initialize Baserom tool list files
        "InitializeListFiles" {
            try {
                # Copy in existing list file(s) to respective folders
                Write-Host "Copying pre-configured list files to respective Tools folders..."
                Copy-Item -Path "$ListsDir\Addmusic*" -Destination $AddMusicK_Dir
                Copy-Item -Path "$ListsDir\list_gps.txt" -Destination $GPS_Dir\list.txt
                Copy-Item -Path "$ListsDir\list_pixi.txt" -Destination $PIXI_Dir\list.txt
                Copy-Item -Path "$ListsDir\list_uberasm.txt" -Destination $UberASMTool_Dir\list.txt
            } catch {
                Write-Host "An error occurred setting up list files."
            }
            continue
        }

        # Setup Lunar Magic usertoolbar
        "SetupUserToolbar" {
            # copy usertoolbar files to Lunar Magic directory
            Write-Host "Setting up custom Lunar Magic toolbar..."
            Copy-Item -Path "$ToolsDir\usertoolbar\usertoolbar.txt" -Destination $LunarMagic_Dir
            Copy-Item -Path "$ToolsDir\usertoolbar\usertoolbar_icons.bmp" -Destination $LunarMagic_Dir
            Copy-Item -Path "$ToolsDir\usertoolbar\usertoolbar_wrapper.bat" -Destination $LunarMagic_Dir
            # Done
            Write-Host "Done.`n"
            continue
        }

        # Exit
        "Exit" {
            # Remove temporary items
            Remove-Item $TempDir -Recurse
            Clear-Host
            Write-Host "Have a nice day ^_^`n"

            exit 0
        }
    }
}