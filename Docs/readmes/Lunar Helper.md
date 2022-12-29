# Lunar Helper ([lunar-monitor](https://github.com/Underrout/lunar-monitor) compatible version)

Lunar Helper is a build system for SMW ROMs originally created by Maddy Thorson and extensively modified
by me (underway).

Modifications include:

- Automatic resource exports and automatic Lunar Magic reloading after successful builds via [Lunar Monitor](https://github.com/Underrout/lunar-monitor#lunar-monitor)
- A Quick Build function which selectively applies updates to a pre-existing ROM instead of rebuilding it from scratch
- Customizable build order
- Ability to have multiple different build configurations for the same hack
- A safety mechanism preventing you from accidentally overwriting unexported changes
- A mechanism for inserting automatically managed global routines and data (called "globules") that can be used by all other tools during the build process
- Ability to use Lunar Helper via command line options for more automated building
- Detection of UberASM errors
- A workaround for the PIXI <-> Lunar Magic 3.31+ incompatibility
- Compatibility with a [human readable map16 format](https://github.com/Underrout/human-readable-map16-cli)
- Ability to pass command line arguments to the underlying tools
- A set of two initial .bps patches for convenience
- Ability to auto-reload open emulator instances after a successful build
- Comes with asar included
- Various other fixes and adjustments


# Introduction

Step by step, what Lunar Helper does is

- Taking a clean SMW ROM
- Applying an initial .bps patch to it (more on this later)
- Inserting Graphics, Map16, title moves and global data (overworld, title screen, credits, etc.)
- Applying patches to it
- Running PIXI on it
- Inserting levels
- Running AddMusicK on it
- Running GPS on it
- Running UberASM Tool on it

Note that you can customize the order these insertions take place to fit your
hack's specific needs.

As you can see, it basically takes a bunch of resources stored as individual files 
(i.e. all of your blocks, sprites, patches, graphics, levels, etc.) and creates a 
single fully functional hacked ROM from them. 


## Source code

The source code for this version can be found here:

    https://github.com/Underrout/LunarHelper

The original source code by Maddy Thorson is available at:

    https://github.com/MaddyThorson/LunarHelper


## Templates

Lunar Helper, among other tools, is available as part of at least two baseroms, which require almost no 
manual setup on your side.

A very basic project template made by me that is continously updated and already fully set up to use Lunar Helper, 
Lunar Monitor and the human readable map16 format is available [here](https://github.com/Underrout/smw-project-template).

This version of Lunar Helper is also used alongside Lunar Monitor in 
the [Romhack Races Baserom](https://github.com/romhackraces/baserom) (at least as of version 4.11).


## Assumptions

The rest of this guide will assume you are already familiar with basic SMW hacking 
tools, such as Lunar Magic, FLIPS, GPS, PIXI, Asar, AddmusicK and UberASM Tool. 


# Setup

Lunar Helper setup is relatively straightforward provided you already have all the 
tools it relies on (FLIPS, GPS, PIXI, Asar, AddmusicK and UberASM Tool) set up. If 
you don't yet, please get those set up somewhere first!


## Extracting and checking files

Take the LunarHelper.exe, config_user.txt, config_project.txt and asar.dll files 
from this zip archive and extract them so some location on your computer. 

Let's look at these files in detail. 

As you might have guessed, LunarHelper.exe is the actual tool itself. You should 
be able to launch it simply by double-clicking it.

If a window launches containing the "Welcome to Lunar Helper ^_^" message, the tool 
is launching correctly!

Note that you will very likely get an error if you try any of the menu options 
except H or ESC at this point, since we have not yet configured the tool!

If you press H you will see what all of the other menu options do. I will thus not 
discuss them here, since they should be pretty self-explanatory.

Note that Lunar Helper may at times generate and updated a hidden ".lunar_helper" 
folder in the same folder as your output ROM. This folder contains various internal 
information the tool uses, so please don't edit any of the files in there. 

If you're using git, you should add this folder to your .gitignore, because it's 
generally not releavant for version control.

Once you've made sure the tool has launched correctly, go ahead and close it 
for now.


## Configuration

We will now take care of actually configuring the tool so it can perform its tasks 
correctly by editing the two config files which should be in the same folder as the 
exe file.

Open up config_project.txt and config_user.txt, read through them and then 
come back.

As you should know now, config_*.txt files are used to tell the tool where it can 
find various tools and resources it will need to build your ROM. Being able to 
split the configuration into different files as we please can be useful if you are
working on a team project and want to separate individual user settings from the 
project's settings!

Note that all paths you specify inside configuration files are relative to a "dir" 
path which by default is specified inside config_user.txt. You should change this 
path to the absolute or relative path to the root of your project folder on your 
PC before following the rest of this configuration guide. For example, if my hack 
were in a folder called "hack" and I'd stored it in my documents folder I would change 

    dir = C:/Users/user/Documents/my_hack 

to 

    dir = C:/Users/me/Documents/hack

Note that a relative path also works here, so you can use

    dir = ../..

to set the directory two levels above the one Lunar Helper is in as the
project directory.
    
Any other paths I specify in config files would then be relative to this path, 
i.e. if I had GPS stored at 

    C:/Users/me/Documents/hack/tools/gps/gps.exe 
    
I would then set the "gps_path" variable like this: 

    gps_path = tools/gps/gps.exe
    
Likewise, if I'd stored GPS outside my hack folder, let's say I had it at 

    C:/Users/me/Documents/tools/gps/gps.exe 
    
instead, I would have to set "gps_path" like this:

    gps_path = ../tools/gps/gps.exe

You can use forward (/) or backward slashes (\) interchangeably in paths, 
Lunar Helper can handle both.

If you feel like you understand most or all of the configuration variables already,
feel free to skip forward as much as you like.

I will now go through the configuration variables we need to specify one by one.


### initial_patch

This variable specifies the path to an initial .bps patch that will be applied to 
the clean ROM at the very start of the build process. 

#### Using included .bps patches

There are two such .bps patches for common scenarios included in this archive inside 
the "initial_patches" directory. 

One is a 4MB FastROM patch ("initial_patches/SA-1/initial_patch.bps") and the other 
is a 4MB SA-1 patch ("initial_patches/SA-1/initial_patch.bps"). Both are set up 
identically with compression optimized for speed and all usually relevant 
Lunar Magic hijacks inserted (see list below in the "Creating your own patch" section 
for steps I performed to create these patches). 

Both of them do NOT have the Shift+F8 fix inserted, if you would like to have that 
included you could just patch one of the patches, add the fix and create a new patch 
from the resulting ROM to use instead.

If you want to use one of the two included .bps patches, just extract the one you 
want from the archive and set the "initial_patch" variable to the location you 
moved the patch to.

#### Creating your own patch

To create a .bps patch by hand, I would recommend grabbing a clean ROM and making 
Lunar Magic install all the hijacks you might need later. 

Personally, I would recommend you

- Open the ROM
- Expand the ROM to 2 MB
- Apply FastROM or SA-1 (if you want to use them)
- Change the compression options to whatever you prefer
- Reapply SA-1 if you applied in step 3
- Expand the ROM to 4 MB
- Save a level
- Extract GFX and ExGFX
- Import GFX and ExGFX
- Create an exanimation, save the level, delete the exanimation and save the level 
  again (so Lunar Magic installs exanimation hijacks)
- Enable a custom palette in a level, change the background color and any other 
  color in the palette, save the level, disable the custom palette and save the 
  level again (for palette hijacks)
- Open the overworld editor
- Edit a path (for the hijacks)
- Edit a level tile (for the hijacks)
- Edit a level name (for the hijacks)
- Edit a message box (for the hijacks)
- Edit the normal layer (for the hijacks)
- Save the overworld (for the hijacks)
- Revert your changes and save again (if you want to have the vanilla overworld 
  back exactly as it was)
- Switch back to the level editor, press Shift+F8 and apply the fix (if you want 
  to have it)

After you're done with this admittedly long list of tasks, you should have a 
solid base. Go ahead and create a .bps patch from this ROM using FLIPS.

Now just set "initial_patch" to the location of the patch you just created.

Example: 

If I had my initial patch at 

    C:/Users/me/Documents/hack/other/initial_patch.bps 
    
I would use 

    initial_patch = other/initial_patch.bps


### patches

The "patches" variable simply specifies a list of paths to patches you want the 
tool to apply to your ROM during the build process using Asar.

Simply specify the path to each patch on its own line between the angled brackets, 
there are already two patches in the list to show you the format. Note that 
patches are applied in order from top to bottom if that's something that matters 
for your patches, also you may not leave extra blank lines between patch paths or 
the tool will throw an error.

Example: 

If I had a folder with a few patches and another subfolder in it inside my hack 
folder like so:

    C:/Users/me/Documents/hack/patches/
        retry.asm
        cutscenes.asm
        some_other_patches/
            another_patch.asm

I would write:

patches
[
    patches/retry.asm
    patches/cutscenes.asm
    patches/some_other_patches/another_patch.asm
]

and Lunar Helper would apply all of them in order from top to bottom for me 
during builds.


### gps_path

This variable simply specifies the path to your gps.exe program.

Example: 

If I had GPS at 

    C:/Users/me/Documents/hack/tools/gps/gps.exe 
    
I would write

    gps_path = tools/gps/gps.exe


### pixi_path

"pixi_path" is exactly the same as "gps_path" but for PIXI (pixi.exe).


### addmusick_path

"addmusick_path" is exactly the same as the previous two but for AddmusicK 
(AddmusicK.exe).


### uberasm_path

"uberasm_path" is exactly the same as the previous three but for UberASM Tool
(UberASMTool.exe).


### levels

This variable specifies the path to a folder which contains all the (altered) 
levels from your SMW hack. If you're using the standard version of Lunar Helper, 
this is the folder all your .mwl level files are saved to whenever you use the 
save function. All of these level files are then imported from this directory 
into the clean ROM during the build process whenever you build your ROM using 
Lunar Helper.

Go ahead and create such a directory in your project's folder and then set the 
variable to the path to this directory.

Example:

If I had created my directory at 

    C:/Users/me/Documents/hack/levels 
    
I would just write 

    levels = levels

since that is the name of the folder.


### command line options

You can pass command line options for PIXI, GPS, AddmusicK, UberASM Tool and Lunar Magic 
that will be used during the build process, if you need additional functionality 
from these tools. 

To specify these, you can use the "pixi_options", "gps_options", "addmusick_options", 
"uberasm_options" and "lm_level_import_flags" config variables respectively. 

The text you specify is inserted into the command issued to the respective tool 
verbatim, so for example in order to pass the "-d" flag to PIXI to enable debug output, 
I would write

    pixi_options = -d

If I wanted to pass the -d and -O2 flags to GPS I would write

    gps_options = -d -O2

For the "lm_level_import_flags" variable, note that this is just a single number 
that determines which flags are enabled during the level import, see Lunar Magic's 
help file for further details on this.

To not auto-set the screen amount when levels are imported, I would write

    lm_level_import_flags = 0


### shared_palette

This variable specifies where you would like Lunar Helper to retrieve your 
hack's exported shared palettes from. 

Note that you do not need to export this file yourself, just specify where you 
would like it to go.

Example:

If I wanted that location to be 

    C:/Users/me/Documents/hack/other/shared_palettes.pal 
    
I would write 

    shared_palette = other/shared_palettes.pal


### map16

This variable specifies where you would like Lunar Helper to retrieve your 
hack's exported all.map16 file from, which is a .map16 file containing all of 
your hack's map16 pages in one place.

Note that you do not need to export this file yourself, just specify where you 
would like it to go.

Example:

If I wanted that location to be 

    C:/Users/me/Documents/hack/other/all.map16 
    
I would write

    map16 = other/all.map16


### human_readable_map16_cli_path

This variable specifies the path to a human-readable-map16-cli.exe, which you can 
get at https://github.com/Underrout/human-readable-map16-cli. This variable is 
optional. If it is supplied, Lunar Helper will be compatible with the human 
readable map16 format that can also be used with Lunar Monitor.

Example:

If I had this executable at 

    C:/Users/me/Documents/tools/human-readable-map16-cli.exe

I would write

    human_readable_map16_cli_path = ../tools/human-readable-map16-cli.exe


### human_readable_map16_directory_path

This variable specifies where you would like Lunar Helper to retrieve the 
directory of human readable text files generated by human-readable-map16-cli.exe 
from. This variable is optional and has no effect unless "human_readable_map16_cli_path"
is also specified. If this variable is left unspecified, Lunar Helper will use the 
"map16" path without the .map16 extension for this path. For example, if you leave 
this variable unspecified and your "map16" variable is "resources/all_map16.map16", 
the human readable text files will be retrieved from a directory called "all_map16" in the 
"resources" directory.

Example:

If I wanted Lunar Helper to retrieve this directory from

    C:/Users/me/Documents/hack/other/all_map16

I would write

    human_readable_map16_directory_path = other/all_map16


### title_moves

This variable specifies where you would like Lunar Helper to retrieve your 
hack's title screen moves, as a .zst file, from. 

Note that you do not need to export this file yourself, just specify where you 
would like it to go.

Example:

If I wanted that location to be 

    C:/Users/me/Documents/hack/other/title_moves.zst
    
I would write

    title_moves = other/title_moves.zst


### test_level

This variable specifies the level number of a level you would like Lunar Helper 
to copy to a different level number if you use its Test option from its menu.

Useful if you have a test level you only want to be accessible when you are 
actually testing your hack.

Note: must always be a 3-digit hex value, so to specify level 1 as a test 
level you would have to write 001, not 1!

Example:

If my test level were A7 I would write

    test_level = A7


### test_level_dest

This variable specifies at which level number the "test_level" should be inserted
when Lunar Helper's Test option is run. This number must also always be a 3-digit 
hex value.

Example:

If I wanted the test level to be inserted as level 105 I would write

    test_level_dest = 105


### global_data

This variable specifies where you would like Lunar Helper to store/retrieve a 
.bps patch containing various other data (overworld, titlescreen, credits, etc.) 
at/from. Note that you do not need to create this patch yourself, just specify 
where you would like it to go. All the contained data will be copied from this 
patch to the clean ROM during the build process.

Example:

If I wanted that location to be 

    C:/Users/me/Documents/hack/other/global_data.bps 
    
I would write 

    global_data = other/global_data.bps


### build_order

This variable lets you customize which tools/resources are inserted and in 
which order. Lunar Helper will work through this list from top to bottom 
whenever it rebuilds your ROM.

The available resources/tools you can use in this list are:

- Graphics
- ExGraphics
- Map16
- TitleMoves
- GlobalData
- SharedPalettes
- Patches
- PIXI
- Levels
- AddMusicK
- GPS
- UberASM
- paths to individual patches (i.e. Patches/Fixes/some_patch.asm)

Note that any individual patches listed in the build order must also appear in
the "patches" list.

"Patches" is a shorthand for "all patches from the patches list that are not
individually listed in the build order", this is just for convenience so that 
you don't have to mention every single patch in the build order if you don't 
care about them being inserted in a particular order.


### dir

We already talked about dir earlier, which is inside config_user.txt by default, 
which you should have open now since the remaining variables are all inside 
config_user.txt as well.

Just make sure this path is set to the root directory of your project as described 
earlier and you should be fine.


### clean 

This variable specifies the path to a (preferably) clean SMW ROM which will be 
the base ROM Lunar Helper starts from during the build process.

Note that Lunar Helper always uses a copy of your clean ROM and not the actual 
ROM itself so you don't have to worry about it being altered in any way.

Example:

If my clean ROM were at 

    C:/Users/me/Documents/hack/clean.smc 
    
I would write 

    clean = clean.smc


### output

This variable specifies the name and location you would like the built ROM 
(aka your hack) to have.

Example:

If I wanted my output ROM to be called "hack.smc" and be located in the root 
directory of my project I would just write 

    output = hack.smc


### temp

This variable just specifies the location and name you want the ROM Lunar Helper 
builds on to have during the build process. Basically Lunar Helper takes your 
clean ROM, copies it to this temp location and then if the build succeeds this 
ROM will be renamed and moved to the location specified by output. 

Example:

If I wanted my temp ROM to be called "temp.smc" and be inside the project's root 
directory during the build process I would write 

    temp = temp.smc


### package

This variable specifies the name and location you want Lunar Helper to give to 
the .bps patch it creates of your hack when you use the Package option from 
its menu. Basically it just builds your ROM like normal and then runs FLIPS on 
it to create a .bps patch of it.

Example:

If I wanted Lunar Helper to produce this patch at 

    C:/Users/me/Documents/hack/hack.bps 
    
I would write 
    
    package = hack.bps


### lm_path

This variable specifies the location of your Lunar Magic executable.

Example:

If I had Lunar Magic at 

    C:/Users/me/Documents/tools/lunar_magic/lunar_magic.exe 
    
I would write 

    lm_path = ../tools/lunar_magic/lunar_magic.exe


### flips_path

Same as lm_path but for FLIPS.

Example:

If I had FLIPS at 

    C:/Users/me/Documents/tools/flips/flips.exe 
    
I would write 

    flips_path = ../tools/flips/flips.exe


### emulator_path 

This variable lets you specify the path to your emulator of choice if you want 
to be able to run the built ROM in it from Lunar Helper's menu via the Run 
and/or Test menu options.

Example:

If my emulator were installed at 

    C:/Program Files/retroarch/retroarch.exe 
    
I would thus write 

    emulator_path = C:/Program Files/retroarch/retroarch.exe


### emulator_options

Allows you to specify command line arguments to pass to your emulator 
when Lunar Helper starts it up. Useful to specify a core for retroarch, 
for example. 

Example: 

If I had a snes9x libretro core at 

    C:/Program Files/retroarch/cores/snes9x_libretro.dll 
    
I would write 

    emulator_options = -L C:/Program Files/retroarch/cores/snes9x_libretro.dll


### reload_emulator_after_build

Allows you to specify whether you would like Lunar Helper to automatically 
relaunch your emulator if a (Quick) Build succeeds while you have the emulator open.
Setting this variable to "true" or "yes" will cause Lunar Helper to do this,
using any other string or omitting this variable will cause Lunar Helper not
to reluanch your emulator automatically.

Note that for this to work, you have to launch your emulator using 
Lunar Helper's Run or Test functions, it won't work if your emulator was 
launched from outside Lunar Helper.

This can be useful if you're prototyping something and frequently have to 
check whether it's actually working in-game.

To make Lunar Helper reload the emulator after a successful build, I would write

    reload_emulator_after_build = yes


## Finishing up 

After configuring the tool, you should be able to use it easily by launching it and using the 
included menu.

Some advanced features of Lunar Helper are listed below, if you're just starting out, you might 
prefer to get familiar with Lunar Helper first before diving into these!


## Advanced features


## Profiles

Profiles are essentially different sets of config files you can easily switch between in order 
to customize Lunar Helper's behavior for different scenarios. A classic example would be having a 
`Debug` and `Release` profile with different emulators and potentially different patches, but you 
can really create whatever profiles you want.

To set up a (default) profile, just create a `default_profile_<your_profile_name_here>` or 
`profile_<your_profile_name_here>` folder in the same folder as Lunar Helper. For example, to create 
a `Release` profile as my default profile, I would create a `default_profile_Release` folder in the 
same folder as my Lunar Helper executable. The only difference between the default profile and any 
other profiles is that you can only have one default profile and it will be the one that you start 
in whenever you open Lunar Helper.

After this, just put any `config_` files you want to associate with this profile into the folder you 
created for it. Any config files you leave in the same folder as the Lunar Helper executable will 
affect *every* profile, so you can use them to specify config variables you might want to share 
between profiles (like the working directory, ROM paths, tool paths, etc.). Any config variables 
specified this way can be overwritten in the config variables of a specific profile. So you could 
have `emulator_path = C:/snes9x.exe` in the same folder as Lunar Helper and then 
`emulator_path = C:/Mesen-S.exe` in a `Debug` profile folder, meaning that any profile will use 
snes9x as emulator by default unless the variable is overwritten, like in the debug profile, where 
Mesen-S will be used instead. The `patches` list is an exception to this, rather than being 
overwritten, any patches you specify in the list in a profile folder will be applied *in addition* 
to any patches specified in config files in the same folder as Lunar Helper.

By default, if no profile folders exist, Lunar Helper will look and hopefully behave exactly the same 
as previously. If profile folders exist, Lunar Helper will show you your current profile and show you 
the new `S - Switch profile` option, which allows you to easily switch between different profiles 
from a small menu.


### Profiles for coders

For the asm-savy, Lunar Helper will generate a `.lunar_helper/current_profile.asm` file in the 
configured working directory right before a (Quick) Build, allowing you to customize smaller code 
portions in patches, sprites, blocks, etc. depending on the current profile.

The file looks something like this:


; DO NOT EDIT THIS FILE MANUALLY, IT IS AUTOMATICALLY GENERATED BY LUNAR HELPER
; Feel free to incsrc this to determine the currently active Lunar Helper profile though!

!LH_PROFILE_Debug = 1  ; Format: "!LH_PROFILE_<profile_name> = 1", current profile is: Debug


where the `Debug` part of `!LH_PROFILE_Debug` changes to reflect the name of the current profile.

You can `incsrc` this file in order to then write code similar to this:


if defined("LH_PROFILE_Debug")
    ; debug code here
elseif defined("LH_PROFILE_Release")
    ; release code here 
else
    ; code for remaining profiles here
endif


## Globules

"Globules" are globally inserted pieces of code or data that are not directly tied to 
any particular tool or resource, but can instead be used from practically anywhere.

This can be very useful for adding new functionality to a ROM that should be available 
to any potential resource or tool, not just one in particular.

Globules are inserted and managed directly by Lunar Helper and can be removed or added at 
any time without having to do a full rebuild.

Lunar Helper has a `globules_path` config variable that should point to a folder somewhere 
inside your folder that you intend to keep your globule files in.

Any .asm file that is directly inside this folder will be inserted as a globule, .asm files
in folders nested in the globule folder will be ignored.

As an example, let's say we have a very simple globule, we'll call it `MakeBig.asm` and 
its contents will look like this:

```
main:
    LDA #$01
    STA $19   ; store $01 to powerup status, making Mario big!
    RTL
```
if we place this in our globule folder, Lunar Helper will insert this subroutine
into our ROM the next time we do a (Quick) Build.

But how do we actually use the subroutine?

After Lunar Helper has inserted the globule, it will store a file containing the 
address of every label inside the globule to `.lunar_helper/globules/globule_name.asm`,
in our example, this would be `.lunar_helper/globules/MakeBig.asm`. Every label is 
prefixed with the name of the globule, so the `main` label in our globule will be 
available as `MakeBig_main`. Every label is also available as a define, so both 
`MakeBig_main` or `!MakeBig_main` can be used and refer to the same exact location
in the ROM.

Let's say we're inserting a block that should make the player big when they touch it.
Our block could be located at `MyProject/Tools/GPS/blocks/MakeBig.asm`, for example.

Of course, since our globule is so simple, it would be easier to just use the exact
same code in the block, but let's try to call the subroutine in our globule instead.

To do so, we would first include the generated globule using 
`incsrc "../../../.lunar_helper/globules/MakeBig.asm"` and then call the subroutine 
using `%call_globule(MakeBig_main)`. The `%call_globule` macro is a convenience macro
that is automatically included whenver you include a generated globule and lets you
call globule subroutines easily.

Our resulting block might look something like this:
```
incsrc "../../../.lunar_helper/globules/MakeBig.asm"

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside

MarioBelow:
MarioAbove:
MarioSide:

TopCorner:
BodyInside:
HeadInside:

%call_globule(MakeBig_main)  ; %call_globule(!MakeBig_main) would also work!

SpriteV:
SpriteH:

MarioCape:
MarioFireball:
RTL
```
The big advantage of globules is that you can use this exact approach in
sprites, uberasm code, patches, etc. without wasting any ROM space on duplicate
routines or data or having to manually manage addresses.

The only pitfalls to keep in mind are

- accidentally including the source globule instead of the generated file
- the globule will likely be in a different bank than the code trying to access it

The second pitfall means that you should generally either use long addressing or 
change the databank register when trying to read data from globules.

Any freespace used by globules will be automatically cleaned up whenever they're 
re-inserted or removed. They're (re-)inserted at the very start of a any (Quick)
Build and are not currently a configurable part of the build order. Note that
Globules should currently **not** import other globules (via incsrc for example).
Make sure every freespace area in your globules contains at least one label, 
otherwise you may leak freespace, since Lunar Helper cannot clean these areas up
automatically unless they contain a label.


## Lunar Helper Information in asm

Information about Lunar Helper is available in the `.lunar_helper/defines.asm` file, which 
can be freely included from any other resource and is generated before each (Quick) Build.

For details on the available defines, feel free to take a look at the contents of the file.

Note that the defines in the file are also automatically included in all globules and patches,
this can potentially be used to let code authors detect that their code is being assembled by a 
project and account for that if they want to.


## Command-Line Options

Lunar Helper supports `--build`, `--quickbuild`, `--package` and `--profiles` command line options, 
which you can use to quickly perform the corresponding actions without having to navigate 
Lunar Helper's menu or even to further automate processes by invoking Lunar Helper from a script 
or git hook. 
The exit code will be 0 if the (quick) build/package process succeeded or -1 if errors were 
encountered. `--help` or `-h` can be used to quickly see the available options.

Optionally, you can pass a second command line option after `--build`, `--quickbuild` and `--package` 
in order to specify the name of the profile to use when building the ROM. For example, if I wanted 
to build the ROM from scratch using a `Debug` profile, I would use `LunarHelper.exe --build Debug`.

You can also pass a `-v` option for `--build`, `--quickbuild` and `--package` in order to specify
how they should handle potentially unexported resources if there might be some in a ROM that would 
be overwritten by the build. 

`-v Y` will export all resources from the ROM and then continue building, `-v N` will not export
resources and just continue building (this can potentially overwrite unexported resources in the
ROM so be careful) and `-v C` will cancel the build with an error if such resources are detected
(C is the default).


## Resolving arbitrary dependencies

Alternatively to simply leaving arbitrary dependencies unresolved,
if you have some asm knowledge, you may opt to resolve the arbitrary 
dependencies by hand. To do so, replace every instance of an arbitrary include 
with a statically resolvable one. 

For example, if there were code like this in a file:

macro inc_file(file)
    incsrc "../<file>.asm"  ; this line is what makes Lunar Helper flag this file
endmacro

%inc_file(file_A)
%inc_file(file_B)

I would rewrite it as:

; macro inc_file(file)
;    incsrc "../<file>.asm"  ; this line will no longer be flagged, since it is commented out
; endmacro

incsrc "../file_A.asm"
incsrc "../file_B.asm"

Note that UberASM Tool's macro library file by default includes `prot_file` and `prot_source` macros
which are flagged as arbitrary dependencies by Lunar Helper, if you're not using them you can simply
comment them out as described above.

Resolving arbitrary dependencies can be nice in some cases, but in other cases it might be simpler
and more organized to just accept them and live with Quick Build being slightly slower.

Note that functions like asar's `canreadfile` will lead to "potentially missing" dependencies if the 
file that is being checked for is absent. This causes essentially the same behavior as an 
arbitrary dependency: Lunar Helper will re-insert the affected resource on every Quick Build to 
ensure the code that's using `canreadfile` gets a chance to check whether the previously absent
file is now present.


## Quick Build triggers

By default, Quick Build will only re-insert resources/tools which have changed since the last 
successful (Quick) Build. In some cases, it might be useful to re-insert a different tool/resource
than the one that changed as well. Quick Build can be extended for this purpose.

Say you have a patch that needs to be re-inserted if a different patch is changed for some 
reason. There is no way for Quick Build to be aware of this abstract dependency between patches,
but we can extend it to take this into account via specifying triggers.

Triggers are specified in a `quick_build_triggers` list, which in our case might look like this:

quick_build_triggers
[
    Patches/some_patch.asm -> Patches/dependent_patch.asm
]

This will let Quick Build know that if it detects a change in Patches/some_patch.asm it should 
not only re-insert that patch, but also re-insert Patches/dependent_patch.asm afterwards.

Generally, Quick Build triggers take the form "X -> Y" where X is the resource/tool that a change is 
detected in and Y is the resource/tool that should be re-inserted in this case.

Any resource/tool that is contained in the build_order list can be used in a trigger (with the 
exception of "Patches").

For example, we could have a "PIXI -> GPS" trigger, which would make it so whenever PIXI is 
re-inserted by Quick Build, it will also re-insert GPS afterwards.

Note that triggers can trigger other triggers, i.e. if we have "PIXI -> GPS" and 
"GPS -> Map16" triggers and PIXI is re-inserted by Quick Build, then GPS will be 
re-inserted at some point after PIXI and Map16 will be re-inserted at some point
after GPS.

Any re-insertions that are not a trigger or caused by a trigger are performed at the end of the
Quick Build process.

Note that when using Lunar Monitor, Quick Build should not notice changes made from inside Lunar Magic
and thus Map16, Levels, GlobalData and SharedPalettes will normally only trigger if these 
resources have been changed through other means (a version control system, for example).

Note that constructs such as

quick_build_triggers
[
    GPS -> PIXI
    PIXI -> GPS
]

are forbidden, as they would lead to an infinite loop. Lunar Helper will throw an error about
"cyclic triggers" if this case is detected.
