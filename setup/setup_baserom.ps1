Clear-Host

$OutputEncoding = [System.Text.Encoding]::UTF8

# Directory Definitions
$WorkingDir     = Get-Location
$ResourcesDir   = "$WorkingDir\resources"
$SetupDir       = "$WorkingDir\setup"
$ToolsDir       = "$WorkingDir\tools"
$ToolsDocsDir   = "$WorkingDir\tools\Docs"

$ListsDir       = "$SetupDir\lists"
$ConfigDir      = "$SetupDir\config"
$FunctionsDir   = "$SetupDir\functions"
$ToolData       = "$SetupDir\tools.json"

# Include external functions
. $SetupDir\functions\common.ps1

# Start the main menu loop
$UserChoice = $null
while ($UserChoice -ne "3") {
    Write-Host "----------------------"
    Write-Host "RHR Baserom v5 - Setup"
    Write-Host "----------------------`n"
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
            $global:has_errors = "no"
            Clear-Host

            # Process Tools
            $Tools = Get-Content $ToolData | ConvertFrom-Json

            foreach ($Tool in $Tools.tools) {
                # Parse JSON of tool data
                $Name   = $Tool.name
                $URL    = $Tool.url
                $Dir    = $Tool.dir
                $List   = $Tool.list
                # Run Setup function for each tool
                Setup-Tool $Name $URL $Dir $List
            }

            # Run tool-specific extra step functions
            Write-Host "`nRunning extra functions for specific tools..."
            ExtraSteps-AddMusicK
            ExtraSteps-PIXI
            ExtraSteps-LunarMagic
            ExtraSteps-Callisto
            Write-Host "Done. `n"

            # Run Clean-up Functions
            Write-Host "`nRunning functions to move documentation and clean up junk files..."
            foreach ($Tool in $Tools.tools) {
                # Parse JSON of tool data
                $Name   = $Tool.name
                $Dir    = $Tool.dir
                $Junk   = @($Tool.junk)
                $Docs   = @($Tool.docs)
                # Move documentation files
                Move-Docs $Name $Docs $Dir -ErrorAction Stop
                # Clean up junk files
                Remove-Junk $Name $Dir $Junk -ErrorAction Stop
            }
            Write-Host "Done. `n"

            if ($has_errors -eq "yes") {
                Write-Host "One or more set ups ended with an error. If you don't know what went wrong please seek assistance.`n" -ForegroundColor DarkYellow
            } else {
                Write-Host "All tools were setup successfully.`n" -ForegroundColor Green
            }
        }

        # Ensure user has run first build of Callisto so the baserom exists
        "2" {
            Clear-Host
            $Callisto_Dir = "$ToolsDir\Callisto\"
            # Check if Callisto is setup
            if (Test-Path "$Callisto_Dir.is_setup" -PathType Leaf) {
                # Check if first-build was already done
                if (Test-Path "$Callisto_Dir.first_build_done" -PathType Leaf) {
                    Write-Host "Callisto first build already performed.`nYou can work on your project by running Callisto from the 'tools/Callisto' folder.`n"
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
                            Write-Host "First build completed successfully.`nYou can get started on your project by running Callisto from the 'tools/Callisto' folder."
                        } else {
                            # Prompt users to run Callisto manually if there was an error
                            Write-Host "Baserom failed to build." -ForegroundColor Red
                            Write-Host "If you do not see any error messages above, run Callisto manually from the 'tools/Callisto' folder, and perform a 'Rebuild' to get them to appear."
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