# --------------------------------------------------
# Common functions for the initialization script
# --------------------------------------------------

# Function to remove junk files
function Remove-Junk($Name, $Dir, $Junk) {
    $toolPath = "$ToolsDir\$Dir"

    Write-Host "Removing junk files for $Name..." -ForegroundColor DarkGray
    # Iterate through list of "junk"
    foreach ($item in $Junk) {
        # Get path of item
        $itemPath = Join-Path -Path $toolPath -ChildPath $item
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
function Move-Docs($Name, $Docs, $Dir) {

    Write-Host "Moving documentation for $Name..." -ForegroundColor DarkGray

    if (-not (Test-Path -Path "$ToolsDocsDir\$Dir" -PathType Container)) {
        New-Item -Path "$ToolsDocsDir\$Dir" -ItemType Directory -Force | Out-Null
    }

    if ($Docs -ne $null -and $Docs.Count -gt 0) {
        foreach ($file in $Docs) {
            $sourcePath = Join-Path -Path "$ToolsDir\$Dir" -ChildPath $file
            $destPath = Join-Path -Path $ToolsDocsDir -ChildPath $Name
            if (Test-Path -Path $sourcePath) {
                if (Test-Path -Path $sourcePath -PathType Container) {
                    # Move directories recursively
                    Copy-Item -Path $sourcePath -Destination $destPath -Force -Recurse
                    Remove-Item -Path $sourcePath -Recurse -Force
                } else {
                    # Move files
                    Move-Item -Path $sourcePath -Destination $destPath -Force
                }
            }
        }
    }
}

# --------------------------------------------------
# Generic Tool Set Up Function
# --------------------------------------------------
# Takes the download URL, output directory, junk files list, documentation list,
# list file name and extra function name as parameters.
# --------------------------------------------------
function Setup-Tool($Name, $URL, $Dir, $List, $Extra) {

    # Set destination based
    $dest = "$ToolsDir\$Dir"

    # Check if already set up
    if (Test-Path "$dest\.is_setup" -PathType Leaf) {
        Write-Host ([char]0x2713) -NoNewline -ForegroundColor Green
        Write-Host " $Name already is set up in: " -NoNewline
        Write-Host "$dest"
    } else {
        $done = $false
        try {
            Write-Host "`n$Name is not set up."
            # Download Tool
            Write-Host "Downloading $Name..." -ForegroundColor DarkGray
            Invoke-WebRequest -Uri $URL -OutFile "$env:temp\$Name.zip"
            # Expand Archive
            Write-Host "Extracting $Name..." -ForegroundColor DarkGray
            Expand-Archive -Path "$env:temp\$Name.zip" -DestinationPath $dest -Force -ErrorAction Stop
            # Copy pre-existing list file (if it exists)
            if ($List) {
                Write-Host "Copying baserom list file(s) for $Name..." -ForegroundColor DarkGray
                if ($List -ne $null -and $List -ne "") {
                    Copy-Item -Path "$ListsDir\$List" -Destination "$dest\list.txt" -Force -ErrorAction Stop
                }
            }
            # Set done
            $done = $true
        } catch {
            $global:has_errors = "yes"
            Write-Host "An error occurred setting up $Name.`n" -ForegroundColor Red
        }
        # Check if successful
        if ($done) {
            # Create is_setup checkfile
            New-Item -Path "$dest\.is_setup" -ItemType File | Out-Null
            # Make it a hidden file
            Set-ItemProperty -Path "$dest\.is_setup" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden) | Out-Null
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
function ExtraSteps-AddMusicK {
    $AddMusicK_Dir = "$ToolsDir\AddMusicK"

    Write-Host "Restructuring AddMusicK folder..." -ForegroundColor DarkGray
    # Get all items in the AMK zip subfolder and move them
    Get-ChildItem "$AddMusicK_Dir\AddmusicK_*" -Recurse -File |
    ForEach-Object {
        Move-Item -LiteralPath $_.FullName -Destination "$AddMusicK_Dir" -Force -Confirm:$false
    }
    # Delete the AMK subfolder
    Remove-Item "$AddMusicK_Dir\AddmusicK_*" -Recurse -Confirm:$false
    # Copy AddMusicK list files to tool directory
    Copy-Item -Path "$ListsDir\Addmusic*" -Destination $AddMusicK_Dir -ErrorAction Stop
}

# Extra steps for Lunar Magic
function ExtraSteps-LunarMagic {
    $LunarMagic_Dir = "$ToolsDir\LunarMagic\"

    # Copy usertoolbar files to Lunar Magic directory
    Write-Host "Installing baserom User Toolbar alongside Lunar Magic..." -ForegroundColor DarkGray
    Copy-Item -Path "$SetupDir\usertoolbar\usertoolbar.txt" -Destination $LunarMagic_Dir -Force
    Copy-Item -Path "$SetupDir\usertoolbar\usertoolbar_icons.bmp" -Destination $LunarMagic_Dir -Force
    Copy-Item -Path "$SetupDir\usertoolbar\usertoolbar_wrapper.bat" -Destination $LunarMagic_Dir -Force
}

# Extra steps for PIXI
function ExtraSteps-PIXI {
    Write-Host "Resolving ASM conflict in PIXI and UberASM Tool..." -ForegroundColor DarkGray

    # Get files
    $origFile = "$ToolsDir\PIXI\asm\main.asm"
    $findFile = "$SetupDir\pixi\main.asm.find"
    $replaceFile = "$SetupDir\pixi\main.asm.replace"

    # Read files
    $origText    = Get-Content $origFile    -Raw
    $findText    = Get-Content $findFile    -Raw
    $replaceText = Get-Content $replaceFile -Raw

    # Normalize text
    $normalize = {
        param($text)
        $text = $text -replace "`r`n", "`n"
        $text = $text -replace '\$0', '$0'
        return $text
    }

    $origNormalized    = & $normalize $origText
    $findNormalized    = & $normalize $findText
    $replaceNormalized = & $normalize $replaceText

    # Ensure the block exists
    if (-not $origNormalized.Contains($findNormalized)) {
        Write-Host "Find block not found in original file." -ForegroundColor Red
    }

    # Replace block
    $replacedContent = $origNormalized.Replace(
        $findNormalized,
        $replaceNormalized
    )

    # Write back
    Set-Content -Path $origFile -Value $replacedContent -NoNewline
}


# Extra steps for Callisto
function ExtraSteps-Callisto {
    $Callisto_Dir = "$ToolsDir\Callisto"
    # Copy over Callisto's initial BPS patches
    Write-Host "Copying over Callisto's initial BPS patches..." -ForegroundColor DarkGray
    Copy-Item -Path "$Callisto_Dir\initial_patches\LunarMagic3.63\initial_patch_fastrom.bps" -Destination "$ResourcesDir\initial_patches\fastrom.bps" -Force
    Copy-Item -Path "$Callisto_Dir\initial_patches\LunarMagic3.63\initial_patch_sa1.bps" -Destination "$ResourcesDir\initial_patches\sa1.bps" -Force

    # Install Callisto's modified asar dll.
    Write-Host "Replacing tool-specific Asar DLLs with Callisto versions..." -ForegroundColor DarkGray
    Copy-Item -Path "$Callisto_Dir\asar\v1.91\64-bit\asar.dll" -Destination "$ToolsDir\GPS\" -Force
    Copy-Item -Path "$Callisto_Dir\asar\v1.91\32-bit\asar.dll" -Destination "$ToolsDir\UberASMTool\" -Force
    Copy-Item -Path "$Callisto_Dir\asar\v1.91\32-bit\asar.dll" -Destination "$ToolsDir\AddMusicK\" -Force | Remove-Item "$ToolsDir\AddMusicK\asar.exe"
    Copy-Item -Path "$Callisto_Dir\asar\v1.91\64-bit\asar.dll" -Destination "$ToolsDir\PIXI\" -Force
}
