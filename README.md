# Romhack Races BaseROM v4

## Getting Started

Patch your copy of unmodified Super Mario World using the `RHR.bps` patch found in the main folder of this BaseROM ensuring it has the name 'RHR4'. If you change the name be sure to change all instances of 'RHR4' found in all scripts.

## The 'common' Folder

This BaseROM comes with a 'common' folder that collates all commonly used tools and resources you need to apply patches and code to your ROM in one place.

See The [README](common/README.md) in that folder for further instructions, before proceeding further.

## Helpful Scripts

To make life easier, this BaseROM comes with several scripts to automate the process of applying additional custom assets to your ROM:

    @apply_patches.bat
    - runs Asar to apply global patches to your ROM. 

    @insert_blocks.bat
    - runs GPS to apply custom blocks to your ROM.
    
    @insert_sprites.bat
    - runs PIXI to insert custom sprites to your ROM.

    @insert_music.bat
    - runs AddKMusic to insert custom music to your ROM.
    
    @insert_uberasm.bat
    - runs UberASM to insert its patches to your ROM.

If all is setup correctly you can run these scripts on-demand to quickly apply new assets to 
your ROM or perform a quick backup.


## Backing Up Things

Once you are all set up and have been working on your ROM is it convenient to be able to back 
up various aspects of your game, there are a few scripts for exporting your levels, all 
of Map16 and your global shared palette from your ROM:

    @export_levels.bat
    - exports all modified levels from your ROM using Lunar Magic to a timestamped 'Levels' directory.

    @export_map16.bat
    - exports all of Map16 (the entire tile map for custom tiles) from your ROM using Lunar Magic

    @export_palettes.bat
    - exports the shared palette from your ROM using Lunar Magic and a timestamps it.
 
Also included are basic set of script for creating time-stamped backups of your ROM, plus 
a script for restoring your ROM from those backup and importing exported assets as well.

    @perform_backup.bat
    - performs a time-stamped based backup that will create a snapshot of your ROM and restore file in the 'Backup' folder. Requires Flips and the Lunar Magic restore system to be set up.
    
    @restore_from_backup.bat
    - restores global assets your ROM from a time-stamped based backup and imports previously-exported levels, map16 and palettes into your ROM. Requires Lunar Magic.
    
If you need to quickly generate a BPS patch for your hack for distribution `@create_bps.bat` will quickly create a patch of your ROM using Floating IPS (Flips).

## More Information

For more information about the creating levels for Romhack Races or for additional documentation about the baserom check out the items in the `Help` folder or visit the [baserom Wiki](https://github.com/ampersam-smw/rhr-baserom/wiki)