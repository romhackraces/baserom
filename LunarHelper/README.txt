Lunar Helper is a build system for Super Mario World ROM hacking.

Step by step, what it does is:

- Takes a clean SMW ROM
- Applies an initial .bps patch to it (more on this later)
- Runs GPS and PIXI on it
- Applies your patches to it
- Runs UberASM Tool on it
- Runs AddmusicK on it
- Inserts various SMW data (graphics, map16, overworld, title screen,
  title screen moves etc.) into it
- Inserts level files into it

It basically takes a bunch of resources stored as individual files
(i.e. all of your blocks, sprites, patches, graphics, levels, etc.)
and creates a single fully functional hacked ROM from them.

Lunar Helper also offers convenient functionality for:

- Opening the built ROM in Lunar Magic
- Running it inside an emulator of your choice

Full details on this tool can be found in the Docs folder of this baserom.