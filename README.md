# Romhack Races Baserom

This is the official baserom for creating Super Mario World race levels for [Romhack Races](https://romhackraces.com/). This baserom is tailor-made for both race level creation as well as general purpose hacking, but a lot of the changes made and patches included are to accommodate Kaizo level design in particular (see the [baserom Wiki page](https://github.com/romhackraces/baserom/wiki/Changes-or-Additions-to-Vanilla-Super-Mario-World) for a detailed breakdown of the all changes).

## Getting Started

The first thing you're going to do is provide your copy of Super Mario World. For the build system to work properly, you'll need to provide a clean copy of a headered (U) [!] ROM Super Mario World ROM renamed to 'clean.smc'. Ensure the file extension is `.smc` and not `.sfc`.

### Initialize the Baserom

To start using the baserom you will first have to initialize the baserom folder and download all of the tools used by it. You can do this by running `!initialize_baserom.bat` this will check for all of the tools used by the build system and download them on demand. This is done to keep the baserom pretty lean and avoid distributing a lot of executables and binary files.

## Building the Baserom

To make life easier for you as a hacker, this baserom comes with a build tool called Lunar Helper that will automagically rebuild your hack everytime you make changes to it.

### Lunar Helper

When working on your hack Lunar Helper is your new best friend, you can find it by running `Lunar Helper.exe` in the LunarHelper folder. This tool will entirely rebuild your rom (from scratch) each time you want to add (or remove) things to make sure it all builds smoothly. It will also help you with quickly editing, testing and packaging your hack for distribution. See the Lunar Helper readme in the Docs\readmes folder for more information.

Lunar Helper comes bundled with a tool to monitor your hack and export level, map16, palette and overworld updates as you make changes. This is only if you use the Edit function of Lunar Helper and the bundled Lunar Magic.

## More Information

For more information about the creating levels for Romhack Races or for additional documentation about what is in the baserom check out the [baserom Wiki](https://github.com/romhackraces/baserom/wiki). If you need more information on how to use some of the resources included in the baserom, check out the documentation in the Docs folder included in this baserom.

If you have feedback or would like additional support with the baserom from the Romhack Races team, please visit the `#baserom-support` in the Romhack Races Discord server.

### Resource Credits

It is good practice to keep track of all resources used in your hacks if you can help it and credit their authors. See the included [CREDITS.txt](CREDITS.txt) file for a list of all resources included in the baserom.

### Contributing

If you have suggestions or improvements for this baserom feel free to open issues or contribute to it on [GitHub](https://github.com/romhackraces/baserom) or reach out on Discord to one of the Romhack Races team. Important: this project has no license nor do the authors or organizers claim any rights to the resources included in this project, those remain the rights of their respective authors.