# These are common definitions for all the build scripts.
# Do not edit unless you know what you are doing.

# Directory definitions
$Backup_Dir=$WorkingDirectory\Backup\
$ConfigDir=$WorkingDirectory\Other\Config\
$ListsDir=$WorkingDirectory\Other\Lists\
$ToolsDir=$WorkingDirectory\Tools\
$TemporaryDir=$WorkingDirectory\temp\

# ROM Definitions
$RomFileName=$ConfigDir\rom-name.txt
# Check if rom-name.txt exists
if not exist $RomFileName!
    # Ask for ROM name
    $/p "ROM_NAME_INPUT=Enter the filename of your ROM file, e.g. MyHack: "
    Write-Host "$RomNameInput>$RomFileName"
    Write-Host ""
    Write-Host " -- ROM name $as: $RomNameInput"
    Write-Host ""
    Write-Host "You can change this at any time by editing the Other/Config/rom-name.txt file."
    Write-Host ""
    # Set ROM name
    $/p ROM_NAME=<$RomFileName
    pause
    cls
) else (
    # Set ROM name
    $/p ROM_NAME=<$RomFileName
)

$CLEAN_ROM="$WorkingDirectory\/clean.smc"
$ROM_FILE="$WorkingDirectory\%ROM_NAME%.smc"
$PATCH_FILE="$WorkingDirectory\%ROM_NAME%.bps"


if "%IS_BUILD_SCRIPT%" == "1" (
    # Build Preference Check
    $BUILD_PREF=$ConfigDir\build-preference.txt
    # Check if build-preference.txt exists
    :BuildPref
    if not exist !BUILD_PREF! (
        Write-Host "Before you begin:"
        Write-Host ""
        Write-Host "The Lunar Helper tool is the recommended method for building the baserom as it can resolve conflicts more readily and insure an issue-free build."
        Write-Host ""
        Write-Host "If you opt to use the batch scripts, anything you do using those may be overwritten by Lunar Helper if you switch to it as it will not be aware of those changes."
        Write-Host ""
        Write-Host "So, if you are comfortable using batch files and resolving issues manually while building your hack, this script $will be useful."
        Write-Host ""
        $/p Input="Proceed with using the build scripts? This will only be asked once. (Y/N): "
        # Confirm choice
        if /i "!Input!"=="Y" (
            .>!BUILD_PREF! 2>NUL
            cls
            goto CleanRomCheck
        ) else if /i "!Input!"=="N" (
            Write-Host ""
            Write-Host "Have a nice day ^^_^^"
            exit /b 1
        ) else (
            Write-Host ""
            Write-Host ""!Input!" is not a valid option, please try again."
            Write-Host ""
            goto BuildPref
        )
    )

    # Clean ROM Check
    $IS_CLEAN_ROM=$ConfigDir\using-clean-rom.txt
    # Check if using-clean-rom.txt exists
    :CleanRomCheck
    if not exist !IS_CLEAN_ROM! (
        Write-Host "WARNING!"
        Write-Host ""
        Write-Host "These scripts will fail if you have not created an initial ROM that is either FastROM or SA-1."
        Write-Host "If you do not have a fresh initial ROM created, clean initial patches can be found in Other/initial_patches."
        Write-Host ""
        $/p Input="Do you have an initial ROM $up? (Y/N): "
        # Confirm choice
        if /i "!Input!"=="Y" (
            .>!IS_CLEAN_ROM! 2>NUL
            cls
            exit /b 0
        ) else if /i "!Input!"=="N" (
            Write-Host ""
            Write-Host "Have a nice day ^^_^^"
            exit /b 1
        ) else (
            Write-Host ""
            Write-Host ""!Input!" is not a valid option, please try again."
            Write-Host ""
            goto CleanRomCheck
        )
    )
)

# Lunar Magic Check
:LunarMagicCheck
$LM="$ToolsDirLunarMagic\Lunar Magic.exe"
# Check if Lunar Magic exists and download if not
if not exist !LM! (
    Write-Host "Lunar Magic not found, downloading..."
    powershell Invoke-WebRequest !LM_DL! -OutFile !LM_ZIP! >NUL
    powershell Expand-Archive !LM_ZIP! -DestinationPath !LM_DIR! >NUL
    # Delete junk files
    for %%a in (!LM_JUNK!) do (del !LM_DIR!%%a)
    # Delete Zip
    del !LM_ZIP!
    Write-Host "Done."
)
