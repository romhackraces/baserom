::
:: These are common definitions for all the build scripts.
:: Do not edit unless you know what you are doing.
::

:: Directory definitions
set BACKUP_DIR=%WORKING_DIR%Backup\
set CONFIG_DIR=%WORKING_DIR%Other\Config\
set LISTS_DIR=%WORKING_DIR%Other\Lists\
set TOOLS_DIR=%WORKING_DIR%Tools\

:: Import Tools stuff
call !TOOLS_DIR!\tool_defines.bat

:: ROM Definitions
:RomNameCheck
set ROM_NAME_FILE=!CONFIG_DIR!rom-name.txt
:: Check if rom-name.txt exists
if not exist !ROM_NAME_FILE! (
    :: Ask for ROM name
    set /p "ROM_NAME_INPUT=Enter the filename of your ROM file, e.g. MyHack: "
    echo !ROM_NAME_INPUT!>!ROM_NAME_FILE!
    echo.
    echo  -- ROM name set as: !ROM_NAME_INPUT!
    echo.
    echo You can change this at any time by editing the Other/Config/rom-name.txt file.
    echo.
    :: Set ROM name
    set /p ROM_NAME=<!ROM_NAME_FILE!
    pause
    cls
) else (
    :: Set ROM name
    set /p ROM_NAME=<!ROM_NAME_FILE!
)

set CLEAN_ROM="%WORKING_DIR%/clean.smc"
set ROM_FILE="%WORKING_DIR%%ROM_NAME%.smc"
set PATCH_FILE="%WORKING_DIR%%ROM_NAME%.bps"


if "%IS_BUILD_SCRIPT%" == "1" (
    :: Build Preference Check
    set BUILD_PREF=!CONFIG_DIR!build-preference.txt
    :: Check if build-preference.txt exists
    :BuildPref
    if not exist !BUILD_PREF! (
        echo Before you begin:
        echo.
        echo The Lunar Helper tool is the recommended method for building the baserom as it can resolve conflicts more readily and insure an issue-free build.
        echo.
        echo If you opt to use the batch scripts, anything you do using those may be overwritten by Lunar Helper if you switch to it as it will not be aware of those changes.
        echo.
        echo So, if you are comfortable using batch files and resolving issues manually while building your hack, this script set will be useful.
        echo.
        set /p Input="Proceed with using the build scripts? This will only be asked once. (Y/N): "
        :: Confirm choice
        if /i "!Input!"=="Y" (
            .>!BUILD_PREF! 2>NUL
            cls
            goto CleanRomCheck
        ) else if /i "!Input!"=="N" (
            echo.
            echo Have a nice day ^^_^^
            exit /b 1
        ) else (
            echo.
            echo "!Input!" is not a valid option, please try again.
            echo.
            goto BuildPref
        )
    )

    :: Clean ROM Check
    set IS_CLEAN_ROM=!CONFIG_DIR!using-clean-rom.txt
    :: Check if using-clean-rom.txt exists
    :CleanRomCheck
    if not exist !IS_CLEAN_ROM! (
        echo WARNING!
        echo.
        echo These scripts will fail if you have not created an initial ROM that is either FastROM or SA-1.
        echo If you do not have a fresh initial ROM created, clean initial patches can be found in Other/initial_patches.
        echo.
        set /p Input="Do you have an initial ROM set up? (Y/N): "
        :: Confirm choice
        if /i "!Input!"=="Y" (
            .>!IS_CLEAN_ROM! 2>NUL
            cls
            exit /b 0
        ) else if /i "!Input!"=="N" (
            echo.
            echo Have a nice day ^^_^^
            exit /b 1
        ) else (
            echo.
            echo "!Input!" is not a valid option, please try again.
            echo.
            goto CleanRomCheck
        )
    )
)

:: Lunar Magic Check
:LunarMagicCheck
set LM="!TOOLS_DIR!LunarMagic\Lunar Magic.exe"
:: Check if Lunar Magic exists and download if not
if not exist !LM! (
    echo Lunar Magic not found, downloading...
    powershell Invoke-WebRequest !LM_DL! -OutFile !LM_ZIP! >NUL
    powershell Expand-Archive !LM_ZIP! -DestinationPath !LM_DIR! >NUL
    :: Delete junk files
    for %%a in (!LM_JUNK!) do (del !LM_DIR!%%a)
    :: Delete Zip
    del !LM_ZIP!
    echo Done.
)
