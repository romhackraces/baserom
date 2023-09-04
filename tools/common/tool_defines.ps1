# These are files and external links to the tools needed to build
# the baserom, plus lists of files that are deleted since they
# are not relevant to the build process.

$BaseromVersion = "5.0"

# Do Not Change
$ToolList = @("AddMusicK", "Flips", "GPS", "LunarMagic", "PIXI", "UberASMTool", "Callisto")

# AddmusicK
$AddMusicK_Dir = "$ToolsDir\addmusick\"
$AddMusicK_Download = "https://dl.smwcentral.net/31558/AddmusicK%201.0.9.zip"
$AddMusicK_Archive = "AddmusicK 1.0.9.zip"
$AddMusicK_Junk = @("readme_files", "src.zip", "addmusicMRemover.pl", "readme.html", "Makefile")

# Callisto
$Callisto_Dir = "$WorkingDir\buildtool\"
$Callisto_Download = "https://github.com/Underrout/callisto/releases/download/v0.1.0/callisto-v0.1.0.zip"
$Callisto_Archive = "callisto-v0.1.0.zip"
$Callisto_Junk = @("ASAR_LICENSE", "LICENSE", "documentation", "config", "asar", "initial_patches")

# Flips
$Flips_Dir = "$ToolsDir\flips\"
$Flips_Download = "https://dl.smwcentral.net/11474/floating.zip"
$Flips_Archive = "floating.zip"
$Flips_Junk = @("license.txt", "flips-linux", "boring.zip", "src.zip")

# GPS
$GPS_Dir = "$ToolsDir\gps\"
$GPS_Download = "https://dl.smwcentral.net/31515/GPS%20%28V1.4.4%29.zip"
$GPS_Archive = "GPS (V1.4.4).zip"
$GPS_Junk = @("src.zip", "Changes.txt", "README.txt")

# Lunar Magic
$LunarMagic_Dir = "$ToolsDir\lunar_magic\"
$LunarMagic_Download = "https://fusoya.eludevisibility.org/lm/download/lm333.zip"
$LunarMagic_Archive = "lm333.zip"
$LunarMagic_Junk = "readme.txt"

# PIXI
$PIXI_Dir = "$ToolsDir\pixi\"
$PIXI_Download = "https://dl.smwcentral.net/32277/pixi_v1.40.zip"
$PIXI_Archive = "pixi_v1.40.zip"
$PIXI_Junk = @("removedResources.txt", "changelog.txt", "README.html", "CONTRIBUTING.html", "CHANGELOG.html")

# UberASM Tool
$UberASMTool_Dir = "$ToolsDir\uberasmtool\"
$UberASMTool_Download = "https://github.com/Underrout/UberASMTool/releases/download/2.0-beta2/UberASMTool20Beta2Standalone.zip"
$UberASMTool_Archive = "UberASMTool20Beta2Standalone.zip"
$UberASMTool_Junk = @("readme.txt", "readme.html", "changelog.txt", "incompatibilities.txt")
