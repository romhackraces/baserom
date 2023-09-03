# Alternatives to Manual Setup

Setting up Callisto can be a fairly complex process. It is often far more convenient to use a baserom that comes with Callisto integrated already.
These baseroms make setup far easier and allow you to jump right into designing within minutes.

Some baseroms that come with Callisto:
- [my own project template](https://github.com/Underrout/smw-project-template)

Even if you end up using a baserom, you may still find it useful to refer to this wiki for non-setup-related information about Callisto, such as [Using Callisto](Using-Callisto) or the section of this setup page about [adding patches](Callisto-Setup-(new-project)#adding-patches), but you can safely skip most of this setup page!

Otherwise, if you're a brave soul, please continue below.

# Getting Callisto

The latest version of Callisto can be [downloaded here](https://github.com/Underrout/callisto/releases/latest).

Just click on `callisto-vX.X.X.zip` in the "Assets" list and your browser should download the ZIP archive.

## Contents of the ZIP Archive

The archive should contain the following folders:

```
- asar
- config
- initial_patches
```

and the following files:

```
- asar.dll
- ASAR_LICENSE
- callisto.exe
- eloper.exe
- LICENSE
```

# Setting up Callisto

To start, create a new folder for your project to go in, for demonstration's sake we'll use `my_hack`.

In this newly created empty project folder, create another folder and call it `tools` and then another folder inside the `tools` folder called `callisto`. The folder structure now looks like this:

```
my_hack/
└── tools/
    └── callisto/
```

Now, put Callisto into the `callisto` folder. To do so:

1. copy the `callisto.exe`, `eloper.exe` and `asar.dll` files from the root of the downloaded ZIP archive into the `callisto` folder
2. copy all files from the `config/project` folder from the ZIP file to the `callisto` folder too

Project folder's structure now looks like this:

```
my_hack/
└── tools/
    └── callisto/
        ├── asar.dll
        ├── callisto.exe
        ├── eloper.exe
        └── (various other files ending in .toml)
```

Great! Now, Callisto *does* require some additional tools in order to run. We at least need:

- Lunar Magic 3.33 (or newer)
- Floating IPS (FLIPS)

Grab Lunar Magic 3.33 and FLIPS from SMWCentral and place them into your project folder in their respective folders like this:

```
my_hack/
└── tools/
    ├── callisto/
    │   ├── asar.dll
    │   ├── callisto.exe
    │   ├── eloper.exe
    │   └── (various TOML config files)
    ├── flips/
    │   └── flips.exe
    └── lunar_magic/
        └── Lunar Magic.exe
```

Nice, now let's create a folder to hold various resources for our hack. Create a new `resources` folder in your project's main folder, like this:

```
my_hack/
├── tools/
│   ├── callisto/
│   │   ├── asar.dll
│   │   ├── callisto.exe
│   │   ├── eloper.exe
│   │   └── (various TOML config files)
│   ├── flips/
│   │   └── flips.exe
│   └── lunar_magic/
│       └── Lunar Magic.exe
└── resources/
```

There are generally a few things that a ROM needs in it for various other resources to be inserted into it without problems. This is why Callisto comes with two "initial patches" that will put a ROM into a state where it is ready for insertion.

Callisto comes with an initial patch for FastROM and one for SA-1, both of them are in the `initial_patches` folder in Callisto's ZIP archive. Grab whichever of the two you prefer (if you don't know what FastROM and SA-1 are, you can just pick one), move it to your `my_hack/resources` folder and rename it to `initial_patch.bps`, like this:

```
my_hack/
├── tools/
│   ├── callisto/
│   │   ├── asar.dll
│   │   ├── callisto.exe
│   │   ├── eloper.exe
│   │   └── (various TOML config files)
│   ├── flips/
│   │   └── flips.exe
│   └── lunar_magic/
│       └── Lunar Magic.exe
└── resources/
    └── initial_patch.bps
```

Great! Now all we need to do is give Callisto a clean Super Mario World ROM to work with. If you've already followed this guide previously and done this step, you shouldn't need to do it again.

To do this, we need to open Callisto. Go ahead and double-click on `my_hack/tools/callisto/callisto.exe` and the window should open. You might get a Windows Defender warning, but you can just dismiss it. After this, there should be a new folder at `%appdata%/callisto`. Grab the files from the `config/user` folder in Callisto's ZIP archive and copy them to your `%appdata%/callisto` folder. Now, go ahead and open the `user.toml` file in a text editor of your choice (some text editors like VSCode even have nice syntax highlighting for TOML files!).

You should see the following lines:

```toml
[settings]
clean_rom = "path/to/my/clean/rom.smc"
```

This tells Callisto where it can find a clean, headered Super Mario World ROM on your computer. This can be any path to a clean ROM, but for simplicity, I will move a clean ROM to my `%appdata%/callisto` folder, call it `clean.smc` and then change the two lines in `user.toml` to:

```toml
[settings]
clean_rom = "C:/Users/user/AppData/Roaming/callisto/clean.smc"
```

Now we are actually ready for our first build! If you still have Callisto open, go ahead and switch back to its window, otherwise re-open it (by double-clicking `my_hack/tools/callisto/callisto.exe`.

You should see a window with various options. You can navigate it either with your arrow keys or by pressing the button next to the option on your keyboard. To build, go ahead and press `R` on your keyboard or navigate to `Rebuild` with your arrow keys and press enter.

You should see the build process start and then get a message saying `Some resources which are configured to be inserted are not present, extract them from your clean ROM? Y/N`. This is because we don't yet have anything to insert into our ROM! Go ahead and press `y` then enter so that Callisto will extract all relevant resources from our vanilla ROM and give us a clean slate to work with.

If all goes well, you should see `Build finished successfully`. Congratulations, you just built an (almost) vanilla ROM!

You will also see the various files Callisto extracted from our clean ROM in your resources folder:

```
my_hack/
├── tools/
│   ├── callisto/
│   │   ├── asar.dll
│   │   ├── callisto.exe
│   │   ├── eloper.exe
│   │   └── (various TOML config files)
│   ├── flips/
│   │   └── flips.exe
│   └── lunar_magic/
│       └── Lunar Magic.exe
└── resources/
    ├── all_map16/
    ├── exgraphics/
    ├── graphics/
    ├── levels/
    ├── credits.bps
    ├── global_exanimation.bps
    ├── initial_patch.bps
    ├── overworld.bps
    ├── shared_palettes.pal
    └── titlescreen.bps
```

If you want, you can take a peek at the ROM by pressing `e` in Callisto's main menu, which will open the built ROM in Lunar Magic for you. It's not much to look at for now though.

Now that we've come this far, it is time to talk about configuration.

# Basic Callisto Configuring

## `build_order.toml`

Let's  take a look at `my_hack/tools/callisto/build_order.toml`. This file specifies in which order all our resources are inserted into our ROM during the build process.

```toml
[orders]
build_order = [
    "InitialPatch",             # Apply initial patch

    # "Modules",                  # Insert modules

    "Graphics",                 # Insert GFX
    "ExGraphics",               # Insert ExGFX
    "Map16",                    # Insert Map16

    # "TitleScreenMovement",      # Uncomment this if you're inserting title moves

    "SharedPalettes",           # Insert Shared Palettes 
    "Overworld",                # Insert Overworld
    "TitleScreen",              # Insert Titlescren
    "Credits",                  # Insert Credits
    "GlobalExAnimation",        # Insert Global ExAnimation

    # "Patches",                  # Insert all remaining patches from the patches list that 
                                # are not explicitly mentioned in this build order


    # "PIXI",                     # Insert custom sprites
    "Levels",                   # Insert all levels

    # "GPS",                      # Insert custom blocks
    # "AddMusicK",                # Insert custom music
    # "UberASM",                  # Insert UberASM code

    # "patches/some_patch.asm",   # Example of inserting a specific patch at a specific point
]
```

As you can see, a lot of lines are commented out, so by default we get a build order that is suitable for vanilla hacks. Whenever we add a tool, for example PIXI, or a resource to our hack, we will need to add it to the build order to tell Callisto to actually apply that tool/insert that resource. 


## `project.toml`

Let's take a quick look at the `my_hack/tools/callisto/project.toml` file. 

Opening it up, you will see a lot of comments about every configuration variable, I will only touch on a few that are of immediate interest here.

`project_root` specifies the root of your project folder. All other paths you specify will be relative to this one. As you can see, it is currently set to `"../../"`, which means the folder two levels up from this one. Since Callisto is at `my_hack/tools/callisto`, `../../` refers to the `my_hack` folder, which is indeed the root of our project! If you move your Callisto folder around, let's say to `my_hack/callisto`, you might need to change this setting, in this case to `project_root = "../"`

Note that it is easier to use forward slashes (`/`) with the [TOML format](https://toml.io/en/), since you will have to use `\\` instead of just `\` when using backwards slashes, so I would recommend sticking to forward slashes for all your paths! 

`output_rom` specifies the path where the ROM Callisto builds will be output. You can change this to `build/my_cool_hack.smc` or anything else you prefer if you want your ROM name and location to be different! The same goes for `bps_package`, which specifies where the BPS package of your ROM will be output when you use the `Package (P)` function in Callisto's main menu.

## `resources.toml`

The `my_hack/tools/callisto/resources.toml` file contains the paths to various resources used by your hack. Most should be pretty self-explanatory.

Note that the `graphics` and `ex_graphics` settings allow you to do something pretty unusual. Generally, with Lunar Magic, the `Graphics` and `ExGraphics` folders have to be right next to the ROM, but Callisto lets you get around this by using some filesystem trickery. There will still be `Graphics` and `ExGraphics` folders next to your ROM in the `my_hack/build` folder, but editing the files in these folders is exactly the same as editing the files in the corresponding folders in the `my_hack/resources` folder and vice-versa, so you can edit graphics in either of the two locations and they will be tracked the same way! If you would rather only use the default folder locations next to the ROM, you can just comment out the two lines in the file like this:

 ```toml
# graphics = "resources/graphics"
# ex_graphics = "resources/exgraphics"
```

If you're just making a vanilla hack, this should already be enough information and you can probably move on to [Using Callisto](Using-Callisto) if you want to! Otherwise, feel free to continue below.

# Adding Tools

So far, we have only used Callisto with two other tools, FLIPS and Lunar Magic. But Callisto is also compatible with all standard tools (PIXI, GPS, UberASMTool, AddMusicK) as well as *any* other tools that conform to some simple requirements (see [Tools In-Depth](Tools-In-Dept) for details).

In the interest of simplicity, I will only show you how to add PIXI, GPS, UberASMTool and AddMusicK to your project here and leave out any low-level details. 

## A Note on Asar

As noted earlier, tools must conform to some basic requirements to work (well) with Callisto. To ensure that the standard tools come as close to these requirements as possible, Callisto uses [a customized version of asar 1.81](https://github.com/Underrout/asar/tree/v1.81-callisto) which you can [download here](https://github.com/Underrout/asar/releases/tag/c-v1.81).

For *any* tool which uses asar, you will need to replace the `asar.dll` or `asar.exe` that comes with that tool with a customized version.

You will notice that the customized asar's ZIP archive contains both 32-Bit and 64-Bit versions of asar, this is because different tools may require either the 32-Bit or 64-Bit version and you will have to replace the tool's asar with the correct version for it to still function.

Here is a brief list of which tools use which version of asar for your convenience:

| Tool Version    | Asar 1.81 Bitness |
|-----------------|-------------------|
| PIXI < v1.40    | 32-Bit            |
| PIXI >= v1.40   | 64-Bit            |
| GPS <= V1.4.4   | 32-Bit            |
| AddMusicK 1.0.9 | 32-Bit            |
| UberASMTool 2.0 | 32-Bit            |

You may notice that for AddMusicK and UberASMTool only version 1.0.9 and version 2.0 are listed respectively. This is because Callisto is *not* compatible with versions of those tools lower than the ones listed. At time of writing, neither of the tools have been standardized with these version numbers yet, but appear to work fine in testing, so use them at your own risk.

## A Note on Folder Paths

It should be noted that all the setup instructions below assume that you are also using the same folder structure and folder names as I am. Changing the folder names would entail making small edits in `tools.toml`, which you can otherwise avoid. I would recommend simply sticking with these folder names and this folder structure until you are more comfortable with Callisto and have perhaps read [Tools In-Dept](Tools-In-Depth).

## Adding PIXI

To add PIXI to my project, I will first download it. Personally, I will go with PIXI v1.40, but any other version should also be fine.

I will now create a `my_hack/tools/pixi` folder and place the contents of the PIXI ZIP archive in it, resulting in this structure:

```
my_hack/
├── tools/
│   ├── callisto/
│   ├── flips/
│   ├── lunar_magic/
│   └── pixi/
│       ├── asm/
│       ├── cluster/
│       ├── extended/
│       └── ...
└── resources/
```

As mentioned earlier, we will have to replace the `asar.dll` that comes with PIXI with the customized version. For PIXI 1.40, which I'm using, I will need the 64-Bit version of asar. I'll grab the `asar/64-Bit/asar.dll` file from Callisto's ZIP archive and copy it into my `my_hack/tools/pixi` folder, overwriting the `asar.dll` that came with PIXI.

Since PIXI doesn't come with a list file by default, I will add an empty one in the `my_hack/tools/pixi` folder and call it `list.txt`:

```
my_hack/
├── tools/
│   ├── callisto/
│   ├── flips/
│   ├── lunar_magic/
│   └── pixi/
│       ├── asm/
│       ├── cluster/
│       ├── extended/
|       ├── ...
|       ├── list.txt
│       └── ...
└── resources/
```

Finally, I will open `my_hack/tools/callisto/build_order.toml` and uncomment the PIXI line by removing the `#` sign to tell Callisto to insert PIXI.

Now, if we use `Rebuild (R)` in Callisto's menu, PIXI will be inserted, just like we wanted!

## Adding GPS

To add GPS, I will download GPS V1.4.4 from SMWCentral and move the contents of the ZIP archive into a new `my_hack/tools/gps` folder, like this:

```
my_hack/
├── tools/
│   ├── callisto/
│   ├── flips/
│   ├── gps/
│   │   ├── blocks/
│   │   ├── routines/
│   │   ├── asar.dll
│   │   └── ...
│   └── lunar_magic/
└── resources/
```

Again, I will need to replace the `asar.dll` that comes with GPS with the one that comes with Callisto. Since GPS V1.4.4 uses the 32-Bit version, I will grab `asar/32-Bit/asar.dll` from Callisto's ZIP archive and copy it to my `my_hack/tools/gps` folder, overwriting the `asar.dll` that was already there.

Now, I will simply uncomment the line that says `# GPS` in `my_hack/tools/callisto/build_order.toml` and Callisto will insert GPS during the build process, just like we wanted!

## Adding UberASMTool

To add UberASMTool, we will actually have to ensure we're using UberASMTool 2.0 (newer versions may also work, older versions will **definitely** not, though they may look like they do at first glance). For the time being, you can use [the version in my fork](https://github.com/Underrout/UberASMTool/releases/latest) which is just a compiled version of [Fernap's fork](https://github.com/Fernap/UberASMTool) of the [main UberASMTool repository](https://github.com/VitorVilela7/UberASMTool) (confusing, I know). If the latter two repositories end up containing a newer release that is also labeled 2.0 or higher, using that version instead of the one in my fork is probably also fine.

With that out of the way, I'll just create a new folder for UberASMTool in my project at `my_hack/tools/uberasm_tool` and move the contents of the UberASMTool 2.0 ZIP I downloaded earlier into it:

```
my_hack/
├── tools/
│   ├── callisto/
│   ├── flips/
│   ├── lunar_magic/
│   └── uberasm_tool/
│       ├── asm/
│       ├── gamemode/
│       ├── level/
│       └── ...
└── resources/
```

Since UberASMTool also uses an `asar.dll` file, we will again need to replace it. UberASMTool 2.0 stil uses 32-Bit, so I will copy the `asar/32-Bit/asar.dll` from Callisto's ZIP archive to the `my_hack/tools/uberasm_tool` folder and overwrite the `asar.dll` file that's already in there.

Since Callisto will automatically pass UberASMTool the ROM's filename, I will also remove 

```
; ROM file to use, may be overridden on command line, optional here if so
rom: smw.smc
```

from the `my_hack/tools/uberasm_tool/list.txt` file, just for cleanliness.

Finally, I will uncomment the `# UberASM` line in `my_hack/tools/callisto/build_order.toml`. Callisto will now apply UberASMTool during the build process!

## Adding AddMusicK

As stated earlier, to add AddMusicK, we should ideally use the 1.0.9 version, which is (at time of writing) in the process of being moderated on SMWCentral. I will download the AddMusicK 1.0.9 ZIP archive from SMWCentral and place its contents into a new `my_hack/tools/addmusick` folder:

```
my_hack/
├── tools/
│   ├── addmusick/
│   │   ├── 1DF9/
│   │   ├── 1DFC/
│   │   ├── asm/
│   │   └── ...
│   ├── callisto/
│   ├── flips/
│   └── lunar_magic/
└── resources/
```

AddMusicK has historically used an EXE version of asar, but appears to now also support a DLL, so you can grab either the `asar.dll` or `asar.exe` file from the Callisto ZIP archive's `asar/32-Bit` folder and copy it to the `my_hack/tools/addmusick` folder.

Finally, just uncomment `# AddMusicK` in `my_hack/tools/callisto/build_order.toml` and Callisto will insert AddMusicK for you during the build process!

## Setting up Tools: Finishing up

That's pretty much it for setting up the standardized tools! If you want to (and/or need to), you can read more about how this all works and how the `tools.toml` file plays into this in the [Tools In-Depth](Tools-In-Depth) section, but this should generally not be necessary and is also much more complex, so I would recommend only reading it once you're comfortable.

Adding blocks, sprites, etc. to the tool's insertion lists works exactly the same as it would if you weren't using Callisto, the only difference is that you will no longer run the tools by hand, since Callisto handles this for you!

Next, we will cover how to insert patches.

# Adding Patches

Adding patches is very simple, since Callisto comes with asar integration and can patch anything needed itself!

To keep all my patches in one place, I will add a new `patches` folder to my `resources` folder like this:

```
my_hack/
├── tools/
│   ├── callisto/
│   ├── flips/
│   └── lunar_magic/
└── resources/
    └── patches/
```

Let's say I want to insert the Remove Status Bar patch from SMWCentral. To do so, I would just grab the `nuke_statusbar.asm` file from the patch's ZIP archive and move it to my new `patches` folder. Then, I would open the `patches.toml` file at `my_hack/tools/callisto/patches.toml`, which we haven't covered yet. It contains the following lines:

```toml
[resources]
patches = [
	# "patches/some_patch.asm",
	# "patches/etc.asm"
]
```

The two lines that are commented out are examples of how we might specify a path to a patch.

Since our patch is at `resources/patches/nuke_statusbar.asm`, relative to the project's root folder, I will change the list to look like this:

```toml
[resources]
patches = [
	"resources/patches/nuke_statusbar.asm"
]
```

Finally, I would need to uncomment the `# Patches` line in Callisto's build order file (`my_hack/tools/callisto/build_order.toml`). The `Patches` symbol is special and stands for all patches in the `patches` list from `patches.toml`, so any patch we add to that list will automatically be inserted at the point in time where the `Patches` symbol appears in the build order. (If you don't want all your patches to be inserted at the same point in the build order, you can check out [Patches in Build Order](Patches-in-Build-Order) for more details).

And that's it, if we build our hack with `Rebuild (R)` in Callisto, it will insert the patch for us, just like we specified!

# Moving on

That pretty much covers all the basic setup of Callisto! You can now move on to [Using Callisto](Using-Callisto).


