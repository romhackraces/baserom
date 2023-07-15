# Alternatives to manual setup

If you would prefer to not have to bother with manually setting up Lunar Helper and Lunar Monitor, you might be interested in using a "baserom", which are templates for hacking projects that usually come pre-configured with many useful tools and resources.

Some baseroms that come set up with Lunar Helper and Lunar Monitor are:

- my own [ template](https://github.com/Underrout/smw-project-template) which is continually updated with the newest versions of Lunar Helper and Lunar Monitor
- the [Romhack Races Baserom](https://github.com/romhackraces/baserom/releases/latest) (at least accurate for versions of the baserom from 4.7 to 4.11)

# Manual setup

First, let's create a new folder for our project, you can name yours whatever you want, I'll just refer to it as the `MyHack` folder for now. If you already have a project that you would like to use Lunar Helper with, you just use that folder instead of making a new one, but please make a backup of the whole folder first, just to be safe!

The latest version of Lunar Helper can be downloaded [here](https://github.com/Underrout/LunarHelper/releases/latest).
Just scroll to the bottom of the release. Then, in the "Assets" list, click the `LunarHelper-vX.X.X.zip` link and your browser should download the zip archive.

Open the archive, then open the `LunarHelper` folder, it should contain the following:
- a `initial_patches` folder
- an `asar.dll` file
- multiple config files, ending in `.txt`
- the `LunarHelper.exe` file

Create a new folder in your project and call it something like `LunarHelper`. In our example, this will be `MyHack/LunarHelper`. Take all the files mentioned above and copy them into this new `LunarHelper` folder.

# Configuration

Let's take a look through the config files, these are the files starting with `config_`. 

These files tell Lunar Helper about the structure of your project and let you customize Lunar Helper's behavior.

Note that Lunar Helper will parse all files starting with `config_` that end in `.txt`, so once you're comfortable, you can feel free to split the configuration up into different files or combine it however you like it!

## dir

Let's start with `config_project.txt`. Go ahead and open the file in a text editor of your choice. At the very top, you will see:
```
-- working directory
dir = C:/Users/user/Documents/my_hack
```
(Note that anything after `--` is treated as a comment inside config files, so the first line here is ignored.)

The `dir` path should point to the main folder of your project. This path can be absolute (something like `C:/Users/Me/Documents/MyHack`) or relative (something like `../../MyHack` or `Documents/MyHack`). You can specify the absolute path to your project folder, in our case this would be something like `C:/Users/Me/Documents/MyHack`, or since our `LunarHelper` folder is at `MyHack/LunarHelper`, we could also use a relative path that is just `../`, which will point to the `MyHack` folder.

Whether you use an absolute or relative path here is not usually that important, but your project will be easier to move around and distribute if you use a relative path and keep the `LunarHelper` folder inside your project folder, so you should prefer using a relative path. In our case, this would just be `../`, since our Lunar Helper is in `MyHack/LunarHelper`, which means `../` will point to the `MyHack` folder. So I will go ahead and change this to

```
-- working directory (all paths are relative to this one)
dir = ../
```

Note that you can use either `/` or `\` as a path separator, so `C:/Users/Me/Documents/MyHack` and `C:\Users\Me\Documents\MyHack` are both fine.

## Initial patch

Next is the initial patch:

```
initial_patch = Other/initial_patch.bps
```

This path should point to a .bps patch which will be applied to the clean ROM at the very start of Lunar Helper's build process. This is important, because Lunar Magic normally inserts some code that other tools and patches might rely on, which is exactly what this .bps patch contains.

You might wonder where to get such a .bps patch, luckily two .bps patches that should work for most projects are already included with Lunar Helper. Open up the `initial_patches` folder in your `LunarHelper` folder, there should be a `FastROM` and `SA-1` folder inside. Each of them contains an `initial_patch.bps` file. If you're familiar with FastROM and SA-1, you can pick whichever one you prefer for your project and copy the .bps patch in the corresponding folder. If you don't know what FastROM and SA-1 are, you probably want to pick SA-1, but it shouldn't be a big deal either way.

Go ahead and make a folder called `Other` in your project's main folder, for me this would be `MyHack/Other`. Place your chosen `initial_patch.bps` patch inside this folder. Of course, you can place your initial patch wherever you want, just make sure you adjust the `initial_patch` variable in `config_project.txt` so that it points to it. In our case, we will use this `Other` folder to keep our initial patch and a few other files organized.

You can now remove the `initial_patches` folder from your `LunarHelper` folder, if you want. You can always switch your `initial_patch.bps` patch out for a different one later too.

*See also:* [Creating your own initial patch](Creating-your-own-initial-patch)

## Patches

Next is the patch list:
```
patches
[
--  Patches\retry\retry.asm
--  Patches\asarspritetiles.asm
]
```
(Keep in mind that `--` is a comment, so the two patches in this list are just examples that don't actually get inserted.)

Every patch that is listed in the `patches` list between the square brackets (`[` and `]`) will be inserted by Lunar Helper during the build process (using Asar under the hood).

For now, you can leave this as is (or remove the two examples). If you want to insert any patches, make sure to specify the path to each of them in this list so that Lunar Helper can apply them for you during the build process (you can keep them in their own `Patches` folder for tidiness if you want).

## Tools

Next are all of the tools:
```
-- tools
lunar_monitor_loader_path = Tools/LunarMagic/LunarMonitorLoader.exe
flips_path = Tools/FLIPS/flips.exe
-- gps_path = Tools/GPS/gps.exe
-- pixi_path = Tools/PIXI/pixi.exe
-- pixi_options = -l Tools/PIXI/list.txt
-- addmusick_path = Tools/AddMusicK/AddMusicK.exe
-- uberasm_path = Tools/UberASMTool/UberASMTool.exe
```
You might be wondering what `LunarMonitorLoader.exe` is, this will be covered in more detail in [Setting up Lunar Monitor](Setting-up-Lunar-Monitor).

For now, just create a `Tools` folder in your project folder, for me this would be `MyHack/Tools`, then put a `LunarMagic` and `FLIPS` folder inside of it. After that, put the Lunar Magic executable you want to use in the `LunarMagic` folder and your FLIPS executable in the `FLIPS` folder. Afterwards, your project's folder structure should look something like this:

```
MyHack/
├── LunarHelper/
├── Other/
└── Tools/
    ├── LunarMagic/
    │   └── Lunar Magic.exe
    └── FLIPS/
        └── flips.exe
```

You can uncomment the other tool's lines if you want to use them for your project, just make sure you repeat the same general procedure for each tool, i.e. a full setup might look something like this:

```
-- tools
lunar_monitor_loader_path = Tools/LunarMagic/LunarMonitorLoader.exe
flips_path = Tools/FLIPS/flips.exe
gps_path = Tools/GPS/gps.exe
pixi_path = Tools/PIXI/pixi.exe
pixi_options = -l Tools/PIXI/list.txt
addmusick_path = Tools/AddMusicK/AddMusicK.exe
uberasm_path = Tools/UberASMTool/UberASMTool.exe
```

(For more information on config variables like `pixi_options` see [Passing command-line options to tools](Passing-command-line-options-to-tools).)

with folder structure:

```
MyHack/
├── LunarHelper/
├── Other/
└── Tools/
    ├── LunarMagic/
    │   └── Lunar Magic.exe
    ├── FLIPS/
    │   └── flips.exe
    ├── GPS/
    │   ├── blocks/
    │   ├── routines
    │   ├── ...
    │   ├── gps.exe
    │   └── list.txt
    ├── PIXI/
    │   ├── asm/
    │   ├── cluster/
    │   ├── ...
    │   ├── pixi.exe
    │   └── list.txt
    ├── AddMusicK/
    │   ├── asm/
    │   ├── music/
    │   ├── ...
    │   └── AddMusicK.exe
    └── UberASMTool/
        ├── asm/
        ├── gamemode/
        ├── ...
        ├── UberASMTool.exe
        └── list.txt
```

## Content

Next are various files and folders representing the actual content of your hack:

```
-- content
levels = Levels
shared_palette = Other/shared.pal
map16 = Other/all.map16
global_data = Other/global_data.bps
-- title_moves = Other/title_moves.zst
```

`levels` should be the path to a folder which will contain all of the levels in your hack as .mwl files. Go ahead and create an empty folder called `Levels` in your project directory. In our example case, our folder structure would just look like this afterwards:

```
MyHack/
├── LunarHelper/
├── Other/
├── Tools/
└── Levels/
```

`shared_palette` should be the path to a file which will contain your hack's shared palettes. You do not need to have a file like that yet, even if you have a preexisting project. Just make sure you have a place for the file to go. In our case, it will go next to our `initial_patch.bps` in the `MyHack/Other` folder.

`map16` should be the path to a file which will contain your hack's map16 tiles. Again, you don't need a file like that yet, it will be generated for us in the `Other` folder as well.

`global_data` should be the path to a file which will contain your hack's overworld, credits, title screen and global animation data. Again, don't worry about this too much, it will show up in the `Other` folder later on as well.

`title_moves` is commented out, but can be used to insert custom title screen movement data into your hack during the build process.  
Keep this commented out until you actually add title screen movement data, then uncomment it and place the savestate containing your recorded movement at the `title_moves` path.

## Build order

The last part of `config_project.txt` is the `build_order` list:
```
build_order
[
    Graphics                -- Insert standard GFX
    ExGraphics              -- Insert ExGFX
    Map16                   -- Insert Map16

--  TitleMoves              -- Uncomment this if you're inserting title moves

    SharedPalettes          -- Insert Shared Palettes 
    GlobalData              -- Insert Overworld, Title Screen and Credits 

--  Patches                 -- Insert all remaining patches from the patches list that 
                            -- are not explicitly mentioned in this build order

--  PIXI                    -- Insert custom sprites
    Levels                  -- Insert all levels

--  PIXI                    -- Uncomment this if you're using Lunar Magic 3.31 or higher

--  AddMusicK               -- Insert custom music
--  GPS                     -- Insert custom blocks
--  UberASM                 -- Insert UberASM code

--  Patches/some_patch.asm  -- Example of inserting a specific patch at a different time
]
```
This list can be used to customize the order that Lunar Helper builds your ROM in. Every line between the square brackets (`[` and `[`) specifies an operation to be performed on the ROM. The order goes from top to bottom.

As you can see, most steps are commented out by default. With this default build order, the only steps that will be applied are:

```
- Graphics
- ExGraphics
- Map16
- SharedPalettes
- GlobalData
- Level
```

this is all you really need for a vanilla hack (ok, you might want at least AddMusicK even in that case), but if you want to additional tools, just make sure the corresponding configuration variable is set up correctly (see [tools](#tools)) and then uncomment the corresponding line(s) in the build order. (Note that if you're using Lunar Magic 3.31 or higher, you should uncomment both instances of PIXI in the list if you want to use PIXI, because there is an [incompatibility](https://github.com/JackTheSpades/SpriteToolSuperDelux/issues/53) between newer Lunar Magic versions and PIXI that requires PIXI to be applied twice to be fixed.)

Note that the `Patches` entry in the build order means "apply all patches from the `patches` list that are not otherwise mentioned in the build order". As you can see on the last line of the default build order, you *can* apply specific patches at specific steps in the build order if needed by writing it explicitly on its own line.

Of course, you can move different entries in the build order up or down freely as needed, though this shouldn't generally be necessary unless there is some sort of dependency between different tools or patches (which *can* happen in practice).

## ROM paths

That should be it for `config_project.txt`, let's switch over to `config_user.txt`.

This file contains just one batch of configuration variables:

```
-- rom paths
clean = clean.smc
output = my_hack.smc
temp = temp.smc
package = my_hack.bps
```

`clean` specifies the path to a clean Super Mario World ROM. I can't tell you where to get one, but you should have one at this point. This clean ROM is what Lunar Helper will start the build process with. Get a copy of a clean ROM and make sure the `clean` variable points to it. For example, I would put my clean ROM directly inside my `MyHack` folder like this:

```
MyHack/
├── LunarHelper/
├── Other/
├── Tools/
├── Levels/
└── clean.smc
```

`output` specifies the path and name of the ROM that Lunar Helper will output after the build process. If you're starting a new project, you can change this to whatever name you want your hacked ROM to use. For example, I might change this to `output = MyFunHack.smc`. It might also be structurally nice to have a `Build` folder that the ROM gets output to like this instead:

```
MyHack/
├── LunarHelper/
├── Other/
├── Tools/
├── Levels/
└── Build/
```

you would then of course use `output = Build/MyFunHack.smc`.

`temp` specifies the path and name of a temporary ROM that Lunar Helper will use during the build process. This is to ensure that the build process is completely successful before overwriting the output ROM. You shouldn't really have to change `temp` unless you want to ensure the temporary ROM stays out of sight. For example, maybe it'd be nice to have a Temp folder inside the Build folder just to keep things clean, like this:

```
MyHack/
├── LunarHelper/
├── Other/
├── Tools/
├── Levels/
└── Build/
    └── Temp/
```

then we could write `temp = Build/Temp/Temp.smc` and have the temporary ROM be built inside its own designated folder.

(Note for PIXI users: PIXI resolves the list path relative to the ROM it's patching, so you have to keep that in mind when specifying the `-l` option for PIXI. I.e. with the above setup, you will have to use `pixi_options = -l ../../Tools/PIXI/list.txt`, because PIXI will start the search for the list file from the temporary ROM's directory.)

`package` specifies the path and name of an output .bps patch that Lunar Helper can create for you from your output ROM. Following from the example above, maybe we would like this to also be output in our `Build` folder, then we could use `package = Build/MyFunHack.bps`.

# Finishing up

Make sure to save your config files are editing them!

Your Lunar Helper should now be fully set up, if you're following along with this setup, feel free to now move on to [Setting up Lunar Monitor](Setting-up-Lunar-Monitor). 

Note that we did not cover all possible configuration variables. For additional "advanced" configuration that may be useful for some people, please see [Advanced topics](Advanced-topics).