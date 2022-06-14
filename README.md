# Romhack Races Baserom

This is the official baserom for creating Super Mario World race levels for [Romhack Races](https://romhackraces.com/). This baserom is tailor-made for both race level creation as well as general purpose hacking, but a lot of the changes made and patches included are to accommodate Kaizo level design in particular.

See the [baserom Wiki page](https://github.com/romhackraces/baserom/wiki/Changes-or-Additions-to-Vanilla-Super-Mario-World) for a detailed breakdown of the changes made to the base game. 

## Getting Started

The first thing you are going to do is patch your copy of unmodified Super Mario World with the `RHR4.bps` patch found in the main folder of this baserom, ensuring it has the name 'RHR4' and an extension of `.smc` when completed. This patch contains all of the changes already made so you can get going straightaway on building your Romhack Race level.

If you change the filename of your ROM be sure to update it in the `Defines\@your_defines.bat` file otherwise the baserom scripts will not work as intended.

### Build Scripts

To make life easier for you as a hacker, this baserom comes some helpful scripts to automate the process of applying additional custom assets to your ROM as well as for backing things up and creating a patch for distribution. See the "How to use the Build Scripts" file in the Docs folder or check out the [Wiki page](https://github.com/romhackraces/baserom/wiki/Using-the-Build-Scripts) for more information about these scripts.

Also, in order to keep things lean and to avoid distributing executable files, the tools are downloaded on demand when the baserom build scripts are run to add things to your hack.

## More Information

For more information about the creating levels for Romhack Races or for additional documentation about what is in the baserom check out the [baserom Wiki](https://github.com/romhackraces/baserom/wiki). If you need more information on how to use some of the resources included in the baserom, check out the documentation in the Docs folder included in this baserom.

If you have feedback or would like additional support with the baserom from the Romhack Races team, please visit the `#baserom-support` in the Romhack Races Discord server.

### Resource Credits

It is good practice to keep track of all resources used in your hacks if you can help it and credit their authors. See the included [CREDITS.txt](CREDITS.txt) file for a list of all resources included in the baserom.

### Contributing

If you have suggestions or improvements for this baserom feel free to open issues or contribute to it on [GitHub](https://github.com/romhackraces/baserom) or reach out on Discord to one of the Romhack Races team. Important: this project has no license nor do the authors or organizers claim any rights to the resources included in this project, those remain the rights of their respective authors.