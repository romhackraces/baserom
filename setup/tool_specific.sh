#!/usr/bin/env bash


#
# Setup functions for baserom tools
#

setup-amk() {
  local TOOLNAME=AddMusicK
  already-setup && return 0

  download-tool $AddMusicK_Download || return 1

  # strip the outer directory from the AMK archive
  extract-archive "$TMP/$TOOLNAME.zip" "$TMP" || return 1
  mkdir -p tools/"$TOOLNAME"
  cp -r "$TMP"/AddmusicK_*/* tools/"$TOOLNAME"/

  install-docs $AddMusicK_Docs
  remove-junk $AddMusicK_Junk
  cp setup/lists/Addmusic* tools/AddMusicK/
  mark-done
}

setup-callisto() {
  local TOOLNAME=Callisto
  already-setup && return 0
  install-tool $Callisto_Download || return 1
  install-docs $Callisto_Docs

  # Replace initial patches
  msg-info "Copying over Callisto's initial BPS patches..."

  local patches=tools/Callisto/initial_patches/LunarMagic3.51

  cp "$patches"/initial_patch_fastrom.bps resources/initial_patches/fastrom.bps
  cp "$patches"/initial_patch_sa1.bps resources/initial_patches/sa1.bps

  # Replace asar
  msg-info "Replacing tool-specific Asar DLLs with Callisto versions..."

  # [jneen] TODO: proper 64-bit versions of these tools exist, let's try and use them
  local asar64=tools/Callisto/asar/v1.91/64-bit/asar.dll
  local asar32=tools/Callisto/asar/v1.91/32-bit/asar.dll

  cp "$asar64" tools/GPS/
  cp "$asar32" tools/UberASMTool/
  cp "$asar32" tools/AddMusicK/
  rm -f tools/AddMusicK/asar.exe
  cp "$asar64" tools/PIXI/

  remove-junk $Callisto_Junk
  mark-done
}

setup-flips() {
  local TOOLNAME=Flips
  already-setup && return 0
  install-tool $Flips_Download || return 1
  remove-junk $Flips_Junk
  mark-done
}

setup-gps() {
  local TOOLNAME=GPS
  already-setup && return 0
  install-tool $GPS_Download || return 1
  install-docs $GPS_Junk
  remove-junk $GPS_Junk
  copy-list list_gps.txt
  mark-done
}

setup-pixi() {
  local TOOLNAME=PIXI
  already-setup && return 0
  install-tool $PIXI_Download || return 1
  install-docs $PIXI_Docs
  remove-junk $PIXI_Junk

  copy-list list_pixi.txt

  # patch an asm conflict in PIXI
  msg-info "Resolving ASM conflict in PIXI and UberASM Tool..."
  sed -i.bak 's/\r$//' "tools/$TOOLNAME/asm/main.asm"
  patch -bl "tools/$TOOLNAME/asm/main.asm" setup/pixi/main.asm.patch || return 1

  mark-done
}

setup-lunarmagic() {
  local TOOLNAME='LunarMagic'
  already-setup && return 0
  install-tool $LunarMagic_Download || return 1
  remove-junk $LunarMagic_Junk

  msg-info "Installing baserom User Toolbar alongside Lunar Magic..."
  cp setup/usertoolbar/* tools/"$TOOLNAME"/
  mark-done
}

setup-uberasm() {
  local TOOLNAME=UberASMTool
  already-setup && return 0
  install-tool $UberASMTool_Download || return 1
  install-docs $UberASMTool_Docs
  remove-junk $UberASMTool_Junk

  copy-list list_uberasm.txt

  mark-done
}
