# Common Tools and Patches

This `common` folder contains all ASM patches, blocks, sprites, etc. included in the baserom, as well the tools needed to apply them to your hack so everything you need for is in one convenient place.

## The BaseROM Toolkit

For applying custom resources and patches to your baserom there is a basic set of tools one usually needs:

- **AddMusicK**: a tool for inserting custom music into your ROM
- **Asar**: an assembler for applying patches to your BaseROM
- **Floating IPS (Flips)**: creates and applies BPS patches, included for creating patches
- **Gopher Popcorn Stew (GPS)**: a custom block insertion tool
- **Lunar Magic**: the essential level editor for SMW hacking, included for backup and restoring
- **PIXI**: a sprite insertion tool (CFG Editor is a tool included with PIXI for tweaking configuration files of custom sprites.)
- **UberASMTool**: a tool for inserting level, overworld, game mode, status bar, sprite and global ASM without using a patch

All these tools have been provided right in this folder for ease of editing your baserom. Adding custom assets will be as simple as copying additional blocks, sprites, patches, extra folders, etc. into the appropriate locations in this `common` folder, e.g. sprites into the `sprites` folder and so forth, and updating the appropriate list files.

The exception to this is AddMusicK which is more compilated and self-contained in its own folder in the main directory. However you can still use the build scripts for adding music.

## List Files

"Wait how do I keep track of my list files??" Worry not, each of the tool's list files are now specified for each tool and read by the build scripts included with this baserom. You need only update each as you would normally and the build script will take care of the rest.

- `list_asar.txt` the list file where you can list the patches for use with Asar from the `asar` folder.
- `list_gps.txt` the custom block list for GPS where you list blocks by Map16 tile number and references to the block ASM as usual, e.g. '0200 custom_block.asm' etc.
- `list_pixi.txt` the custom sprite list file for PIXI and can be filled in as usual: '00 custom_sprite.cfg/.json' etc.
- `list_uberasm.txt` a copy of the UberASM list file, where you can specific various patches to be applied to your ROM. 
