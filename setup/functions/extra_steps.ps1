# Some tools require additional set up. These functions perform those steps
# as part of their initialization process.

# Extra steps for Lunar Magic
function ExtraLunarMagic {
    Write-Host "Installing baserom User Toolbar alongside Lunar Magic..." -ForegroundColor DarkGray
    # copy usertoolbar files to Lunar Magic directory
    Copy-Item -Path "$SetupDir\usertoolbar\usertoolbar.txt" -Destination $LunarMagic_Dir -Force
    Copy-Item -Path "$SetupDir\usertoolbar\usertoolbar_icons.bmp" -Destination $LunarMagic_Dir -Force
    Copy-Item -Path "$SetupDir\usertoolbar\usertoolbar_wrapper.bat" -Destination $LunarMagic_Dir -Force
}

# Extra steps for PIXI
function ExtraPIXI {
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
function ExtraCallisto {
    # Copy over Callisto's initial BPS patches
    Write-Host "Copying over Callisto's initial BPS patches..." -ForegroundColor DarkGray
    Copy-Item -Path "$Callisto_Dir\initial_patches\initial_patch_fastrom.bps" -Destination "$ResourcesDir\initial_patches\fastrom.bps" -Force
    Copy-Item -Path "$Callisto_Dir\initial_patches\initial_patch_sa1.bps" -Destination "$ResourcesDir\initial_patches\sa1.bps" -Force

    # Install Callisto's modified asar dll.
    Write-Host "Replacing tool-specific Asar DLLs with Callisto versions..." -ForegroundColor DarkGray
    Copy-Item -Path "$Callisto_Dir\asar\v1.81\32-bit\asar.dll" -Destination $GPS_Dir -Force
    Copy-Item -Path "$Callisto_Dir\asar\v1.91\32-bit\asar.dll" -Destination $UberASMTool_Dir -Force
    Copy-Item -Path "$Callisto_Dir\asar\v1.91\32-bit\asar.dll" -Destination $AddMusicK_Dir -Force | Remove-Item $AddMusicK_Dir\asar.exe
    Copy-Item -Path "$Callisto_Dir\asar\v1.91\64-bit\asar.dll" -Destination $PIXI_Dir -Force
}
