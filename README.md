# Romhack Races BaseROM v4

This is the official BaseROM for creating Super Mario World race levels for [Romhack Races](https://romhackraces.com/). This base ROM is tailor-made for both race level creation as well as general purpose hacking, but a lot of the changes made and patches included are to accommodate Kaizo level design in particular.

## Getting Started

Patch your copy of unmodified Super Mario World using the `RHR.bps` patch found in the main folder of this BaseROM, ensuring it has the name 'RHR4' when completed.

If you change the filename of your ROM be sure to rename the ancillary files included in this base ROM and change all instances of 'RHR4' found in the scripts (specified usually by `set ROMFILE="RHR4.smc"`) otherwise they will not work as intended.

### The 'common' Folder

This BaseROM comes with a 'common' folder that collates all commonly used tools and resources you need to apply patches and code to your ROM in one place.

See The [README](common/README.md) in that folder for further instructions, before proceeding further.

### Helpful Scripts

To make life easier for your as a hack, this base ROM comes some helpful scripts to automate the process of applying additional custom assets to your ROM as well as for backing things up and creating a patch for distribution.

- `@build_baserom.bat` Does a lot of the work for you when it comes to inserting custom assets into your ROM by present a list the options corresponding to each of the tools. Additionally will create a BPS patch for distribution.
- `@backup_baserom.bat` Gives you the option to exports all modified levels, edited map16 and/or shared palettes from your ROM using Lunar Magic, as well as create a time-stamped backup of your ROM if you desire.
- `@restore_from_backup.bat` Restores global assets your ROM from a time-stamped based backup and imports previously-exported levels, map16 and palettes into your ROM. Requires Lunar Magic and the backup scripts to be run first.


## More Information

For more information about the creating levels for Romhack Races or for additional documentation about the baserom check out the items in the `Help` folder or visit the [baserom Wiki](https://github.com/ampersam-smw/rhr-baserom/wiki)