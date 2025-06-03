Clear-Host

$OutputEncoding = [System.Text.Encoding]::UTF8

# Directory Definitions
$WorkingDir     = Get-Location
$ModulesDir     = "$WorkingDir\modules"
$ResourcesDir   = "$WorkingDir\resources"
$InitDir        = "$WorkingDir\init"
$ToolsDir       = "$WorkingDir\tools"
$ToolsDocsDir   = "$WorkingDir\tools\Docs"

$ListsDir       = "$InitDir\lists"
$ConfigDir      = "$InitDir\config"
$FunctionsDir   = "$InitDir\functions"

# Include defines
. $InitDir\tool_defines.ps1
# Include functions
. $InitDir\functions\common.ps1
. $InitDir\functions\tool_specific.ps1
. $InitDir\functions\extra_steps.ps1

# Start the main menu loop
$UserChoice = $null
while ($UserChoice -ne "3") {
    Write-Host "-------------------------------"
    Write-Host "RHR Baserom v5 - Initialization"
    Write-Host "-------------------------------`n"
    Write-Host "Welcome! To get started with the baserom, run both of the following steps:`n"
    Write-Host "1) Download and set up all baserom tools"
    Write-Host "2) Run a first build of the baserom in Callisto"
    Write-Host "0) Exit`n"

    $UserChoice = Read-Host "Enter the number of your choice"

    if ($UserChoice -notin ("0", "1", "2")) {
        Write-Host "`n'$UserChoice' is not a valid option, please try again.`n"
        continue
    }

    switch ($UserChoice) {

        # Download and Setup all Baserom Tools
        "1" {
            Clear-Host
            # Specialized tool initialization processes
            SetupAMK "AddMusicK" $AddMusicK_Download $AddMusicK_Dir $AddMusicK_Junk $AddMusicK_Docs "" ""
            # Generic tool initialization
            Setup-Tool "Flips" $Flips_Download $Flips_Dir $Flips_Junk $Flips_Docs "" ""
            Setup-Tool "GPS" $GPS_Download $GPS_Dir $GPS_Junk $GPS_Docs "list_gps.txt" ""
            Setup-Tool "PIXI" $PIXI_Download $PIXI_Dir $PIXI_Junk $PIXI_Docs "list_pixi.txt" "ExtraPIXI"
            Setup-Tool "Lunar Magic" $LunarMagic_Download $LunarMagic_Dir $LunarMagic_Junk $LunarMagic_Docs "" "ExtraLunarMagic"
            Setup-Tool "UberASMTool" $UberASMTool_Download $UberASMTool_Dir $UberASMTool_Junk $UberASMTool_Docs "list_uberasm.txt" ""
            # Callisto must be initialized last
            Setup-Tool "Callisto" $Callisto_Download $Callisto_Dir $Callisto_Junk $Callisto_Docs "" "ExtraCallisto"
            if ($has_errors -eq "yes") {
                Write-Host "One or more set ups ended with an error. If you don't know what went wrong please seek assistance.`n" -ForegroundColor DarkYellow
            } else {
                Write-Host "All tools were setup successfully.`n" -ForegroundColor Green
            }
        }

        # Ensure user has run first build of Callisto so the baserom exists
        "2" {
            Clear-Host
            # Check if Callisto is setup
            if (Test-Path "$Callisto_Dir.is_setup" -PathType Leaf) {
                # Check if first-build was already done
                if (Test-Path "$Callisto_Dir.first_build_done" -PathType Leaf) {
                    Write-Host "Callisto first build already performed.`nYou can work on your project by running Callisto from the 'buildtool' folder.`n"
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
                            Write-Host "First build completed successfully.`nYou can get started on your project by running Callisto from the 'buildtool' folder."
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
                Write-Host "`nCallisto is not set up. Please run Step 1 first."
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