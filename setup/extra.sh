#!/usr/bin/env bash

# Extra setup functions for baserom tools
extra-steps() {
  local tool="$1"
  shift

  case "$tool" in

    # AddmusicK
    AddmusicK)
      # get all items in the AMK zip subfolder and move them
      if directory-exists "$TOOLSDIR/AddmusicK/AddmusicK_*"; then
        cp -r $TOOLSDIR/AddmusicK/AddmusicK_*/* $TOOLSDIR/AddmusicK/
        rm -r $TOOLSDIR/AddmusicK/AddmusicK_*
        echo "Restructured AddmusicK folder"
      fi

      # copy AddmusicK list files to AMK directory
      cp setup/lists/Addmusic* $TOOLSDIR/AddmusicK/
      echo "Copied baserom AddmusicK list files"
      ;;

    # Callisto
    Callisto)
      # Replace initial patches
      if directory-exists "$TOOLSDIR/Callisto/initial_patches"; then
        msg info "Copying Callisto initial BPS patches..."
        local patches="$TOOLSDIR/Callisto/initial_patches/LunarMagic3.63"

        cp "$patches"/initial_patch_fastrom.bps resources/initial_patches/fastrom.bps
        cp "$patches"/initial_patch_sa1.bps resources/initial_patches/sa1.bps
      fi

      # Replace asar dlls
      if directory-exists "$TOOLSDIR/Callisto/asar"; then
        msg info "Replacing tool-specific Asar DLLs with Callisto versions..."

        # [jneen] TODO: proper 64-bit versions of these tools exist, let's try and use them
        local asar64=$TOOLSDIR/Callisto/asar/v1.91/64-bit/asar.dll
        local asar32=$TOOLSDIR/Callisto/asar/v1.91/32-bit/asar.dll

        cp "$asar64" $TOOLSDIR/GPS/
        cp "$asar32" $TOOLSDIR/UberASMTool/
        cp "$asar32" $TOOLSDIR/AddmusicK/
        cp "$asar64" $TOOLSDIR/PIXI/
      fi
      ;;

    # PIXI
    PIXI)
      # patch an asm conflict in PIXI
      if [ -f "$TOOLSDIR/PIXI/asm/main.asm.orig" ]; then
        echo "ASM conflict in PIXI and UberASM Tool already patched"
      else
        sed -i.bak 's/\r$//' "$TOOLSDIR/PIXI/asm/main.asm"
        patch -bl "$TOOLSDIR/PIXI/asm/main.asm" setup/pixi/main.asm.patch || return 1
        echo "Patched ASM conflict in PIXI and UberASM Tool"
      fi
      ;;

    # Lunar Magic
    LunarMagic)
      # copy over the usertoolbar files
      cp setup/usertoolbar/* $TOOLSDIR/LunarMagic/
      echo "Installed baserom toolbar alongside Lunar Magic"
      ;;

    # Other
    *)
      echo "Invalid step"
      ;;
  esac
}
