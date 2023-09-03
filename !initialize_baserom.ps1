# ---------------------------------------------------------
# Baserom initialization PowerShell script
# ---------------------------------------------------------
Clear-Host

# Directory Definitions
$WorkingDir = Get-Location
$ToolsDir = "$WorkingDir\tools"
$TempDir = "$WorkingDir\temp"

# Dot includes
. $ToolsDir\common\tool_defines.ps1
# . $ToolsDir\common\build_script_common.ps1

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
            if (Test-Path "$AddMusicK_Dir.is_setup" -PathType Leaf) {
                Write-Host "-- AddMusicK is set up in: $AddMusicK_Dir."
            } else {
                Write-Host "AddMusicK is not set up. `nDownloading..."
                # Download zip file
                Invoke-WebRequest -Uri $AddMusicK_Download -OutFile $TempDir$AddMusicK_Archive >NUL
                Expand-Archive -Path $TempDir$AddMusicK_Archive -DestinationPath $ToolsDir >NUL
                # Delete junk files
                foreach ($item in $AddMusicK_Junk) {
                    if (Test-Path $item -PathType Leaf) {
                        Remove-Item $item -Force -Recurse
                        Write-Host "Deleted file: $file"
                    } else {
                        Write-Host "File not found: $file"
                    }
                }
                # Delete Zip
                Remove-Item $AddMusicK_Archive
                # Create is_setup checkfile
                New-Item -Path "$AddMusicK_Dir.is_setup" -ItemType File
                Set-ItemProperty -Path "$AddMusicK_Dir.is_setup" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
                Write-Host "Done. `n"
            }

            # Check if Flips directory has set-up checkfile
            if (Test-Path "$Flips_Dir.is_setup" -PathType Leaf) {
                Write-Host "-- Flips is set up in: $Flips_Dir."
            } else {
                Write-Host "Flips is not set up. `nDownloading..."
                # Download zip file
                Invoke-WebRequest -Uri $Flips_Download -OutFile $TempDir$Flips_Archive >NUL
                Expand-Archive -Path $TempDir$Flips_Archive -DestinationPath $ToolsDir >NUL
                # Delete junk files
                foreach ($item in $Flips_Junk) {
                    if (Test-Path $item -PathType Leaf) {
                        Remove-Item $item -Force -Recurse
                        Write-Host "Deleted file: $file"
                    } else {
                        Write-Host "File not found: $file"
                    }
                }
                # Delete Zip
                Remove-Item $Flips_Archive
                # Create is_setup checkfile
                New-Item -Path "$Flips_Dir.is_setup" -ItemType File
                Set-ItemProperty -Path "$Flips_Dir.is_setup" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
                Write-Host "Done. `n"
            }

            # Check if GPS directory has set-up checkfile
            if (Test-Path "$GPS_Dir.is_setup" -PathType Leaf) {
                Write-Host "-- GPS is set up in:  $GPS_Dir."
            } else {
                Write-Host "GPS is not set up. `nDownloading..."
                # Download zip file
                Invoke-WebRequest -Uri $GPS_Download -OutFile $TempDir$GPS_Archive >NUL
                Expand-Archive -Path $TempDir$GPS_Archive -DestinationPath $ToolsDir >NUL
                # Delete junk files
                foreach ($item in $GPS_Junk) {
                    if (Test-Path $item -PathType Leaf) {
                        Remove-Item $item -Force -Recurse
                        Write-Host "Deleted file: $file"
                    } else {
                        Write-Host "File not found: $file"
                    }
                }
                # Delete Zip
                Remove-Item $GPS_Archive
                # Create is_setup checkfile
                New-Item -Path "$GPS_Dir.is_setup" -ItemType File
                Set-ItemProperty -Path "$GPS_Dir.is_setup" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
                Write-Host "Done. `n"
            }

            # Check if Lunar Magic directory has set-up checkfile
            if (Test-Path "$LunarMagic_Dir.is_setup" -PathType Leaf) {
                Write-Host "-- Lunar Magic is set up in: $LunarMagic_Dir."
            } else {
                Write-Host "Lunar Magic is not set up. `nDownloading..."
                # Download zip file
                Invoke-WebRequest -Uri $LunarMagic_Download -OutFile $TempDir$LunarMagic_Archive >NUL
                Expand-Archive -Path $TempDir$LunarMagic_Archive -DestinationPath $ToolsDir >NUL
                # Delete junk files
                foreach ($item in $LunarMagic_Junk) {
                    if (Test-Path $item -PathType Leaf) {
                        Remove-Item $item -Force -Recurse
                        Write-Host "Deleted file: $file"
                    } else {
                        Write-Host "File not found: $file"
                    }
                }
                # Delete Zip
                Remove-Item $LunarMagic_Archive
                # Create is_setup checkfile
                New-Item -Path "$LunarMagic_Dir.is_setup" -ItemType File
                Set-ItemProperty -Path "$LunarMagic_Dir.is_setup" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
                Write-Host "Done. `n"
            }

            # Check if UberASMTool directory has set-up checkfile
            if (Test-Path "$UberASMTool_Dir.is_setup" -PathType Leaf) {
                Write-Host "-- UberASMTool is set up in: $UberASMTool_Dir."
            } else {
                Write-Host "UberASMTool is not set up. `nDownloading..."
                # Download zip file
                Invoke-WebRequest -Uri $UberASMTool_Download -OutFile $TempDir$UberASMTool_Archive >NUL
                Expand-Archive -Path $TempDir$UberASMTool_Archive -DestinationPath $ToolsDir >NUL
                # Delete junk files
                foreach ($item in $UberASMTool_Junk) {
                    if (Test-Path $item -PathType Leaf) {
                        Remove-Item $item -Force -Recurse
                        Write-Host "Deleted file: $file"
                    } else {
                        Write-Host "File not found: $file"
                    }
                }
                # Delete Zip
                Remove-Item $UberASMTool_Archive
                # Create is_setup checkfile
                New-Item -Path "$UberASMTool_Dir.is_setup" -ItemType File
                Set-ItemProperty -Path "$UberASMTool_Dir.is_setup" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
                Write-Host "Done. `n"
            }

            # Check if Callisto directory has set-up checkfile
            if (Test-Path "$Callisto_Dir.is_setup" -PathType Leaf) {
                Write-Host "-- Callisto is set up in: $Callisto_Dir."
            } else {
                Write-Host "Callisto is not set up. `nDownloading..."
                # Download zip file
                Invoke-WebRequest -Uri $Callisto_Download -OutFile $TempDir$Callisto_Archive >NUL
                Expand-Archive -Path $TempDir$Callisto_Archive -DestinationPath $Callisto_Dir >NUL
                # Install Callisto's modified asar dll.
                Copy-Item -Path "$Callisto_Dir\asar\32-bit\asar.dll" -Destination $GPS_Dir
                Copy-Item -Path "$Callisto_Dir\asar\32-bit\asar.dll" -Destination $AddMusicK_Dir
                Copy-Item -Path "$Callisto_Dir\asar\32-bit\asar.dll" -Destination $UberASMTool_Dir
                Copy-Item -Path "$Callisto_Dir\asar\64-bit\asar.dll" -Destination $PIXI_Dir
                # Delete junk files
                foreach ($item in $Callisto_Junk) {
                    if (Test-Path $item -PathType Leaf) {
                        Remove-Item $item -Force -Recurse
                        Write-Host "Deleted file: $file"
                    } else {
                        Write-Host "File not found: $file"
                    }
                }
                # Delete Zip
                Remove-Item $Callisto_Archive
                # Create is_setup checkfile
                New-Item -Path "$Callisto_Dir.is_setup" -ItemType File
                Set-ItemProperty -Path "$Callisto_Dir.is_setup" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
                Write-Host "Done. `n"
            }
            # Done
            Write-Host "All done. `n"
            continue
        }

        # Initialize Baserom tool list files
        "InitializeListFiles" {
            Write-Host "You selected Option 2"
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
            Clear-Host
            Write-Host "Have a nice day ^_^`n"
            exit 0
        }
    }
}