# Romhack Races Baserom

This is the official baserom for creating Super Mario World race levels for [Romhack Races](https://romhackraces.com/). This baserom is tailor-made for both race level creation as well as general purpose hacking, but a lot of the changes made and patches included are to accommodate Kaizo level design in particular.

## Getting Started

The first thing you are going to do is patch your copy of unmodified Super Mario World with the `RHR.bps` patch found in the main folder of this baserom, ensuring it has the name 'RHR4' when completed. This patch contains all of the changes already made so you can get going straightaway on building your Romhack Race level.

If you change the filename of your ROM be sure to rename the ancillary files included in this baserom and change all instances of `RHR4` found in the build scripts (specified usually by `set ROMFILE="RHR4.smc"`) otherwise they will not work as intended.

### The 'common' Folder

This baserom comes with a folder that compiles all commonly used tools, resources you need, patches to apply to your ROM, etc. in one place to keep the main directory of your project neat and tidy and streamline your workflow. See The [README in that folder](common) for further instructions, before proceeding further.

### Helpful Scripts

To make life easier for your as a hack, this baserom comes some helpful scripts to automate the process of applying additional custom assets to your ROM as well as for backing things up and creating a patch for distribution.

- `@build_baserom.bat` Does a lot of the work for you when it comes to inserting custom assets into your ROM by present a list the options corresponding to each of the tools. Additionally will create a BPS patch for distribution.
- `@backup_baserom.bat` Gives you the option to exports all modified levels, edited map16 and/or shared palettes from your ROM using Lunar Magic, as well as create a time-stamped backup of your ROM if you desire.
- `@restore_from_backup.bat` Restores global assets your ROM from a time-stamped based backup and imports previously-exported levels, map16 and palettes into your ROM. Requires Lunar Magic and the backup scripts to be run first.

## More Information

For more information about the creating levels for Romhack Races or for additional documentation about the baserom check out the [baserom Wiki](https://github.com/ampersam-smw/rhr-baserom/wiki). If you need to view documentation for resources included in the baserom, such as the Retry System, the `Help` folder which contains the relevant material.

If you have feedback or would like additional support with the baserom from the Romhack Races team, please visit the `#baserom-support` in the Romhack Races Discord server.

### Resource Credits

It is good practice to keep track of all resources used in your hacks if you can help it and credit their authors. See the included [CREDITS.txt](CREDITS.txt) file for a list of all resources included in the baserom or visit the [corresponding wiki page](https://github.com/ampersam-smw/rhr-baserom/wiki/Resources-Used-in-the-Baserom).

### Contributing

If you have suggestions or improvements for this baserom feel free to open issues or contribute to it on [GitHub](https://github.com/ampersam-smw/rhr-baserom). Important: this project has no license nor do the authors claim any rights to the resources included within, those remain the rights of their respective authors.