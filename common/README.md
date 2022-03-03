# Common Tools and Patches

This `common` folder is where you will place any or all ASM patches, blocks, sprites, etc. and the tools needed to apply them so everything you need for your baserom is in one convenient place. Empty folders required by the tools have been pre-made and will be encountered when you add the tools into this folder in later steps.

## The BaseROM Toolkit

For applying custom code and patches to your baserom there is a basic set of tools one usually needs:

- AddMusicK: a tool for inserting custom music into your ROM
- Asar: an assembler for applying patches to your BaseROM
- Floating IPS (Flips): creates and applies BPS patches, included for creating patches
- Gopher Popcorn Stew (GPS): a custom block insertion tool
- Lunar Magic: the essential level editor for SMW hacking, included for backup and restoring
- PIXI: a sprite insertion tool (CFG Editor is a tool included with PIXI for tweaking configuration files of custom sprites.)
- UberASM: a tool for inserting level, overworld, game mode, status bar, sprite and global ASM without using a patch

All these tools have been provided for ease of editing your BaseROM.

## List Files

Adding custom assets will be as simple as copying blocks, sprites, patches, extra folders, etc. into the appropriate locations in this 'common' folder and updating the appropriate list files:

- `list_asar.txt` the list file where you can list the patches for use with Asar from the `asar` folder.
- `list_gps.txt` the custom block list for GPS where you list blocks by Map16 tile number and references to the block ASM as usual, e.g. '0200 custom_block.asm' etc.
- `list_pixi.txt` the custom sprite list file for PIXI and can be filled in as usual: '00 custom_sprite.cfg/.json' etc.
- `list_uberasm.txt` a copy of the UberASM list file, where you can specific various patches to be applied to your ROM. 
