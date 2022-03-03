# Romhack Races Base ROM v4

This is the official BaseROM for creating Super Mario World race levels for [Romhack Races](https://romhackraces.com/). This base ROM is tailor-made for both race level creation as well as general purpose hacking, but a lot of the changes made and patches included are to accommodate Kaizo level design in particular.

## Getting Started

While all the individual resources used in the baserom are readily available, the first thing you are doing to do is patch your copy of unmodified Super Mario World with the `RHR.bps` patch found in the main folder of this base ROM, ensuring it has the name 'RHR4' when completed. This patch contains all of the changes already made so you can get going straightaway.

If you change the filename of your ROM be sure to rename the ancillary files included in this base ROM and change all instances of 'RHR4' found in the scripts (specified usually by `set ROMFILE="RHR4.smc"`) otherwise they will not work as intended.

### The 'common' Folder

This base ROM comes with a folder that collates all commonly used tools, resources you need, patches to apply to your ROM, etc. in the  `common` folder to keep the main directory of your project neat and tidy. See The [README in that folder](common) for further instructions, before proceeding further.

### Helpful Scripts

To make life easier for your as a hack, this base ROM comes some helpful scripts to automate the process of applying additional custom assets to your ROM as well as for backing things up and creating a patch for distribution.

- `@build_baserom.bat` Does a lot of the work for you when it comes to inserting custom assets into your ROM by present a list the options corresponding to each of the tools. Additionally will create a BPS patch for distribution.
- `@backup_baserom.bat` Gives you the option to exports all modified levels, edited map16 and/or shared palettes from your ROM using Lunar Magic, as well as create a time-stamped backup of your ROM if you desire.
- `@restore_from_backup.bat` Restores global assets your ROM from a time-stamped based backup and imports previously-exported levels, map16 and palettes into your ROM. Requires Lunar Magic and the backup scripts to be run first.

## More Information

For more information about the creating levels for Romhack Races or for additional documentation about the base ROM check out the items in the `Help` folder or visit the [baserom Wiki](https://github.com/ampersam-smw/rhr-baserom/wiki). If you have feedback or would like additional support with the baserom please visit the `#baserom-support` in the Romhack Races Discord server.

### Credits

It is good practice to keep track of all resources used in your hacks if you can help it, see the included [CREDITS.txt](CREDITS.txt) file for information about the resources included out-of-the-box or visit the [wiki page](https://github.com/ampersam-smw/rhr-baserom/wiki/Resources-Used-in-the-Baserom).

### Contributing

If you have suggestions or improvements for this base ROM feel free to open issues or contribute to it on [GitHub](https://github.com/ampersam-smw/rhr-baserom). Important: this project has no license nor do the authors claim any rights to the resources included within, those remain the rights of their respective authors.