#!/usr/bin/env bash


#
# Extra setup functions for baserom tools
#

extra-amk() {
  if compgen -G "tools/AddmusicK/AddmusicK_*" > /dev/null; then
    # get all items in the AMK zip subfolder and move them
    cp -r tools/AddmusicK/AddmusicK_*/* ./tools/AddmusicK/
    # remove the subfolder
    rm -r tools/AddmusicK/AddmusicK_*
  fi

  # copy AddmusicK list files to AMK directory
  cp setup/lists/Addmusic* tools/AddmusicK/
}

extra-callisto() {
  # Replace initial patches
  if compgen -G "tools/Callisto/initial_patches" > /dev/null; then
    echo "Copying over Callisto's initial BPS patches..."

    local patches=tools/Callisto/initial_patches/LunarMagic3.63

    cp "$patches"/initial_patch_fastrom.bps resources/initial_patches/fastrom.bps
    cp "$patches"/initial_patch_sa1.bps resources/initial_patches/sa1.bps
  fi

  # Replace asar dlls
  if compgen -G "tools/Callisto/asar" > /dev/null; then
    echo "Replacing tool-specific Asar DLLs with Callisto versions..."

    # [jneen] TODO: proper 64-bit versions of these tools exist, let's try and use them
    local asar64=tools/Callisto/asar/v1.91/64-bit/asar.dll
    local asar32=tools/Callisto/asar/v1.91/32-bit/asar.dll

    cp "$asar64" tools/GPS/
    cp "$asar32" tools/UberASMTool/
    cp "$asar32" tools/AddmusicK/
    cp "$asar64" tools/PIXI/
  fi
}

extra-pixi() {
  # patch an asm conflict in PIXI
  echo "Resolving ASM conflict in PIXI and UberASM Tool..."
  sed -i.bak 's/\r$//' "tools/PIXI/asm/main.asm"
  patch -bl "tools/PIXI/asm/main.asm" setup/pixi/main.asm.patch || return 1
}

extra-lunarmagic() {
  echo "Installing baserom User Toolbar alongside Lunar Magic..."
  cp setup/usertoolbar/* tools/LunarMagic/
}