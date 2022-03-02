# Romhack Races Info 

If you are creating a level for us, or are interested in doing so in the future, please read the following information about our standards, playtesting process and collaboration efforts.

## Disclaimer

By submitting your level to Romhack Races, you are giving us permission to feature your level in our season collaboration hack that is submitted to SMWCentral. You will be credited as the creator of your level in the submission and within the hack/

In order to include the hack within the collaboration, the following guidelines must be followed:
- Global patches are strictly disallowed. If this an issue, please contact the playtesting team.
- No more than 6 Map16 pages per level.
- If you use multiple Map16 pages, please fill one page before creating a new one.

If you do not wish to have your level featured in our collaboration hack, we ask that you create a level that you would be comfortable sharing. Additionally, please refrain from using your hack to explicitly promote upcoming or other creative works outside of the weekly race level.

## Playtestings

If you aren't already in the level testing server on Discord, you will be sent an invitation to join when it is time to start testing your level. When you join, please post the patch for your level. Within 36 hours, our team of playtesters will test your level and provide feedback and suggested changes to be made, either aesthetically or functionally. 

We ask that you, as creator, make the changes the testers present as they are presented. We recognize that this is your level, not ours, and we are not trying to take away your creative freedom through our edits. Please understand that our goal is to make the level its best possible version, and we pride ourselves on maintaining a high standard for the levels we feature. 

Please do not take our feedback personally - we are very grateful you have taken the time and interest in being a creator, and want to help you have the best possible showing at the race!

## Revisions

Once the first round of testing is done, we ask that you have your revisions done within 48 hours of receiving feedback. We know that life doesn't stop for Romhack races, and we are more than willing to accommodate if you need extra time. That said, the sooner you are able to make changes, the sooner you can get further feedback from testers. 

While we are always trying to defer to you as the creator, there may be instances where the playtesters feel that specific revisions are necessary in order to feature the level as a race. In those instances, playtesters may provide edits on their own for you to note. If you refuse to make a revision that a consensus of playtesters feel is necessary, we reserve the right to not feature your level on Romhack Races.

Ideally, we aim to have your level finalized and ready to go at least 24 hours prior to the start of the race so that we aren't scrambling to make last-minute changes before posting the level. If we are late in the week and the playtesting team does not feel comfortable with the state of the level, we reserve the right to delay your race to a later week. 


## Submitting Your Level

When playtesting is complete, please LOCK your level in Lunar Magic before sending it to us for distribution. Beyond your level patch, please take any customizations you have made to your level (music, blocks, sprites, uberASM, etc.) and package them in a ZIP file once the level is finalized. 

If you have any questions about the playtesting process, please ask within the playtesting server. 

---

# BaseROM v4 Info

## Getting Started

Patch your copy of unmodified Super Mario World using the `RHR.bps` patch found in the main folder of this BaseROM ensuring it has the name 'RHR4'. If you change the name be sure to change all instances of 'RHR4' found in all scripts.

## THE 'common' FOLDER

This BaseROM comes with a 'common' folder that collates all commonly used tools and resources 
you need to apply patches and code to your ROM in one place.

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