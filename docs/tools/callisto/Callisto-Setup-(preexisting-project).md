# Potential Dealbreakers

Here are some potential dealbreakers that could mean that your project just absolutely cannot be migrated to Callisto:
- Callisto **requires** Lunar Magic 3.33 or newer.
- Callisto **does not work correctly** with UberASMTool versions below 2.0
- Callisto **is hard to set up** with AddMusicK versions below 1.0.9

If you are not sure if UberASMTool 2.0 is a dealbreaker for you, [here is a list of known incompatibilities](https://github.com/Underrout/UberASMTool/blob/master/assets/incompatibilities.txt). Note also that neither UberASMTool 2.0 nor AddMusicK 1.0.9 are not yet standardized and *may* be buggy.

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

First and foremost, **make a backup of your project folder** as there are many things that could go wrong during the setup process.

For the purposes of this guide, I will assume that your hack is stored in a folder called `my_hack`, but it doesn't really matter what the name is, this is purely for illustrative purposes. I will also assume that you keep copies of each tool somewhere inside your project folder, rather than having them in one centralized location somewhere on your computer.

## Project Setup

To start, create a new folder inside your hack's folder for Callisto to go in. You can put it anywhere inside your project folder you want, classical places would be the root of your project folder (`my_hack/callisto`) or inside the folder you keep your tools in (`my_hack/tools/callisto`).

For simplicity, I will put my callisto folder in the root, so at `my_hack/callisto`.

Now, I will actually put Callisto into my `callisto` folder. 

To do so:

1. I copy the `callisto.exe`, `eloper.exe` and `asar.dll` files from the root of the ZIP archive to your `callisto` folder
2. I copy all files from the `config/project` folder from the ZIP file to your `callisto` folder too

My hack folder's structure now looks like this:

```
my_hack/
├── callisto/
│   ├── asar.dll
│   ├── callisto.exe
│   ├── eloper.exe
│   └── (various other files ending in .toml)
└── (various other preexisting folders and files)
```

## User Setup

Go ahead and open the `my_hack/callisto/callisto.exe` file by double-clicking on it. You might get a popup from Windows Defender, but you can just dismiss it. After this, there should be a new folder at `%appdata%/callisto`. Grab the files from the `config/user` folder in Callisto's ZIP archive and copy them to your `%appdata%/callisto` folder. Now, go ahead and open the `user.toml` file in a text editor of your choice (some text editors like VSCode even have nice syntax highlighting for TOML files!).

You should see the following lines:

```toml
[settings]
clean_rom = "path/to/my/clean/rom.smc"
```

This tells Callisto where it can find a clean Super Mario World ROM on your computer. This can be any path to a clean ROM, but for simplicity, I will move a clean ROM to my `%appdata%/callisto` folder, call it `clean.smc` and then change the two lines in `user.toml` to:

```toml
[settings]
clean_rom = "C:/Users/user/AppData/Roaming/callisto/clean.smc"
```

## Initial Patch Setup

There are generally a few things that a ROM needs in it for various other resources to be inserted into it without problems. This is why Callisto comes with two "initial patches" that will put a ROM into a state where it is ready for insertion.

If you do not yet have one, create a `resources` folder in the root of your project folder, like this for example:
```
my_hack/
├── callisto/
├── resources/
└── (various other preexisting folders and files)
```

Callisto comes with an initial patch for FastROM and one for SA-1, both of them are in the `initial_patches` folder in Callisto's ZIP archive. Grab whichever of the two you prefer (if you don't know what FastROM and SA-1 are, you can just pick one), move it to your `my_hack/resources` folder and rename it to `initial_patch.bps`, like this:

```
my_hack/
├── callisto/
├── resources/
│   └── initial_patch.bps
└── (various other preexisting folders and files)
```

# Setting up Other Tools

## Setting up FLIPS and Lunar Magic

Given that you have a hack already set up, I will assume that you *have* FLIPS and Lunar Magic *somewhere* on your system. For the purposes of using Callisto, it is *highly* recommended to keep copies of both tools inside your project's folder as well. Furthermore, Callisto requires Lunar Magic 3.33 or newer to work. I would thus recommend you grab a copy of FLIPS and a copy of Lunar Magic 3.33 or newer and add them somewhere inside your project. In my case, I will add them like so:

```
my_hack/
├── callisto/
│   ├── asar.dll
│   ├── callisto.exe
│   ├── eloper.exe
│   └── (various other files ending in .toml)
├── tools/
│   ├── flips/
│   │   └── flips.exe
│   └── lunar_magic/
│       └── Lunar Magic.exe
└── (various other preexisting folders and files)
```

## Migrating to UberASMTool 2.0

(You can skip this part if you're not using UberASMTool.)

If your project is currently using a version of UberASMTool before 2.0, you will need to migrate to 2.0 (or newer) before being able to use Callisto. For the time being, you can use [the version in my fork](https://github.com/Underrout/UberASMTool/releases/latest) which is just a compiled version of [Fernap's fork](https://github.com/Fernap/UberASMTool) of the [main UberASMTool repository](https://github.com/VitorVilela7/UberASMTool) (confusing, I know). If the latter two repositories end up containing a newer release that is also labeled 2.0 or higher, using that version instead of the one in my fork is probably also fine.

Any recommendations given elsewhere for how to migrate to 2.0 also apply to this case. I will assume that you have successfully migrated your project to UberASMTool 2.0 from now on without further reference.

## Migrating to AddMusicK 1.0.9

(You can skip this part if you're not using AddMusicK.)

AddMusicK 1.0.9 is (at time of writing) in the process of being moderated on SMWCentral. Migrating to it should be straightforward (presumably) and I will leave that task in your capable hands and assume you have succeeded from now on without further reference.

## Switching out Tool's Asar Files

Tools must conform to some basic requirements to work (well) with Callisto. To ensure that the standard tools come as close to these requirements as possible, Callisto uses a customized version of asar 1.81 which comes included in the `asar` folder of Callisto's ZIP archive. (It is also separately available [here](https://github.com/Underrout/asar/releases/tag/c-v1.81))

For *any* tool which uses asar, you will need to replace the `asar.dll` or `asar.exe` that comes with that tool with a customized version.

You will notice that the `asar` folder in Callisto's ZIP archive contains both 32-Bit and 64-Bit versions of asar, this is because different tools may require either the 32-Bit or 64-Bit version and you will have to replace the tool's asar with the correct version for it to still function.

Here is a brief list of which tools use which version of asar for your convenience:

| Tool Version    | Asar 1.81 Bitness |
|-----------------|-------------------|
| PIXI < v1.40    | 32-Bit            |
| PIXI >= v1.40   | 64-Bit            |
| GPS <= V1.4.4   | 32-Bit            |
| AddMusicK 1.0.9 | 32-Bit            |
| UberASMTool 2.0 | 32-Bit            |

You should now go through each of your tool folders inside your project and ensure that you replace any `asar.dll` or `asar.exe` files you find with the corresponding version from the `asar/32-Bit`/`asar/64-Bit` folders in Callisto's ZIP archive.

After you've done this, your tools should be compatible with Callisto.

# Configuration

We now have a lot of configuring to do. All configuration files use the TOML format (https://toml.io/en/) which you may want to briefly familiarize yourself with. Note that forward slashes (`/`) are nicer in TOML than backward slashes (`\`) for file paths, since you will need to double any backward slashes (so `\` becomes `\\`) as they're also used as escape characters inside strings.

## `project.toml`

Open `my_hack/callisto/project.toml`.

Change the following line so it points to the root of your project folder relative to the Callisto folder. Since I placed my Callisto folder right in my project's root, it should be `../` in my case, but if you have your Callisto folder at `my_hack/tools/callisto`, you would have to go up two levels, so `../../` would already be correct in that case. All other paths in the config files will be relative to this path.
```toml
# before
project_root = "../../"

# after (in my case)
project_root = "../"
```

Next, find the line that says `output_rom` and change it so it points at your project's hacked ROM. For the purposes of this guide, I will assume that your ROM is called `my_hack.smc` and is located in the root folder of your project, like so:

```
my_hack/
├── my_hack.smc
├── callisto/
├── tools/
└── (various other preexisting folders and files)
```

so in this case, I would change it like this:

```toml
# before
output_rom = "build/my_hack.smc"

# after
output_rom = "my_hack.smc"
```

While you're here, you can also change the `temporary_folder` and `bps_package` settings to whatever you prefer.

## `tools.toml`

This file (`my_hack/callisto/tools.toml`) contains the configuration for all standardized tools Callisto *may* need to work with. Note that Callisto makes no special assumptions about PIXI, GPS, AddMusicK and UberASMTool, all specifics about these tools are purely stored in this file. This also means that Callisto is compatible with any *other* tools as long as they follow some simple requirements.

In the interest of simplicity, we will only fix up small parts of this file to make it work with your preexisting project's structure, but you can see [Tools In-Depth](Tools-In-Dept) for more details, if you want to, though it shouldn't generally be necessary unless you want to integrate a non-standard tool or use very new versions of tools that Callisto does not yet have updated configuration files for.

### Lunar Magic and FLIPS in `tools.toml`

First, look for `[tools.FLIPS]` and `[tools.LunarMagic]`. 

For each of them, change the corresponding `executable` setting so they point to the correct executable file.

In my case, I would end up with:

```toml
[tools.FLIPS]
executable = "tools/flips/flips.exe"

[tools.LunarMagic]
executable = "tools/lunar_magic/Lunar Magic.exe"
```

which already matches what's there, but if you placed the programs at other locations, you might need to change the paths!

### PIXI in `tools.toml`

If you're using PIXI, find the line that says `[tools.generic.PIXI]` in `tools.toml`, slightly below that, you will find:

```toml
directory = "tools/pixi"
```

Simply change this line to reflect where your PIXI folder actually is relative to your project's root folder. For example, if you have a `sprite_stuff` folder right in your project's root folder, you would just change this to:

```toml
directory = "sprite_stuff"
```

Now, PIXI is a little weird when it comes to passing it a list file, so we may also need to edit the following line:

```toml
options = "-l ../../tools/pixi/list.txt"
```

I will assume that you are keeping your list file in your PIXI folder (if you aren't doing it yet, you can start now!).

Callisto will pass the path of the temporary ROM to PIXI during the build process and PIXI resolves the list file's path relative to the ROM that it is inserting sprites into. That means that if you have `temporary_folder = "build/temp"` in `project.toml`, the temporary ROM will be inside this folder during the build. So the `../../` part of `options = "-l ../../tools/pixi/list.txt"` is still correct (in this case), but we may need to adjust the `tools/pixi` part, i.e. if your PIXI folder were `sprite_stuff` in your project's root folder, you would need to change this line to

```toml
options = "-l ../../sprite_stuff/list.txt"
```

Likewise, if we had changed our temporary folder to `temporary_folder = "temp"`, we would need 

```toml
options = "-l ../sprite_stuff/list.txt"
```

instead, since our temporary folder is now only one level "deep" from our project's root folder.

That should be all for PIXI.

### GPS in `tools.toml`

If you're using GPS, look for a `[tools.generic.GPS]` line in `tools.toml` and edit 

```toml
directory = "tools/gps"
```

so it points to your project's GPS folder.

### UberASMTool in `tools.toml`

If you're using UberASMTool, look for a `[tools.generic.UberASM]` line in `tools.toml` and edit 

```toml
directory = "tools/uberasm_tool"
```

so it points to your project's UberASMTool folder.

### AddMusicK in `tools.toml`

If you're using AddMusicK, look for a `[tools.generic.AddMusicK]` line in `tools.toml` and edit 

```toml
directory = "tools/addmusick"
```

so it points to your project's AddMusicK folder.

## `patches.toml`

(If you're not using patches, you can skip this step.)

Open `my_hack/callisto/patches.toml`, you will see something like this:

```toml
[resources]
patches = [
	# "patches/some_patch.asm",
	# "patches/etc.asm"
]
```

This is the list of all patches that Callisto will apply during the build process. It contains two commented out lines to illustrate how one might add patches to the list. 

Keep in mind, all paths in this list are still relative to the project root!

Now, just go through all patches your hack contains and add their paths to this list. If you're keeping your patches in weird places or don't actually have all patches you applied to your hack on hand, this is a good time to change that and organize a little! Maybe a `resources/patches` folder would be nice. Take your time.

## `resources.toml`

This file contains various locations your hack's exported resources will be stored at once Callisto saves them. You can change these to your liking.

Note that the `graphics` and `ex_graphics` settings allow you to do something pretty unusual. Generally, with Lunar Magic, the `Graphics` and `ExGraphics` folders have to be right next to the ROM, but Callisto lets you get around this by using some filesystem trickery. There will still be `Graphics` and `ExGraphics` folders next to your ROM in the `my_hack/build` folder, but editing the files in these folders is exactly the same as editing the files in the corresponding folders in the `my_hack/resources` folder and vice-versa, so you can edit graphics in either of the two locations and they will be tracked the same way! If you would rather only use the default folder locations next to the ROM, you can just comment out the two lines in the file like this:

 ```toml
# graphics = "resources/graphics"
# ex_graphics = "resources/exgraphics"
``` 

(You don't need to ensure that there are `Graphics` and `ExGraphics` folders next to your ROM during the setup process, Callisto will export them fresh from your ROM when saving no matter what.)

## `build_order.toml`

Now, one last step before we can get to building!

Open `my_hack/callisto/build_order.toml`, you will see something like this:

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

This list specifies the order in which Callisto will insert resources into your ROM during the build process. As you can see, a bunch of lines are commented out, because by default the build order is adequate for a vanilla hack. Feel free to uncomment any lines that you are using in addition to the vanilla ones, i.e. if you're using GPS, remove the `#` in front of `# "GPS"` in the list and so on.

That should be it, once you're satisfied, feel free to move on!

# Saving your Hack's Resources

Firstly, once again ensure that you have a backup of both your project folder and your ROM.

Now, open Callisto by double-clicking `my_hack/callisto/callisto.exe`. You should see a menu which you can navigate either by pressing the arrow buttons and using enter to select an option or by simply pressing the key shown to the right of the option on your keyboard. 

Go ahead and use `Save (S)`, which will export relevant resources (levels, map16, overworld, etc.) to the locations listed in `resources.toml`. If you get any errors, resolve them before moving on.

# Rebuilding your Hack from Scratch

Now that your resources have been exported, we will try to rebuild your hack starting from a clean ROM. To do this, in Callisto's main menu, use the `Rebuild (R)` option. You should see Callisto perform the steps listed in `build_order.toml` one after the other.

If there are errors, resolve them before moving on.

# Checking that Things Worked

While it is a good sign if the build succeeds, there is still a good chance that your hack will *not* work right away. Open the newly built ROM in an emulator and ensure that it *actually* works correctly.

If it does, great! You can move on to [Using Callisto](Using-Callisto).

If it does not, there are many reasons for why this could be happening:

- Your hack has turned out to be incompatible with UberASMTool 2.0, AddMusicK 1.0.9 or Lunar Magic 3.33

In this case, there is not much to do but try to figure out, *why* your hack is incompatible and attempting to fix it.

- You forgot to include resources that were present in the original hack

In this case, simply add the forgotten resources by following the steps from earlier and try again.

- You have discovered a conflict (congratulations!)

It is very likely that the way you originally created your ROM was very different from how Callisto just tried to do it. This change in process can often unearth incompatibilities or "conflicts" between tools or patches that were previously "masked" either by insertion order, manual fixing or "random chance". Callisto makes it easier than ever to resolve these kinds of problems, since it is capable of detecting potential conflicts without any additional effort on your part. If you suspect you may have ran into a conflict, consult [Detecting and Resolving Conflicts](Detecting-and-Resolving-Conflicts) and try again.

If none of these tips helped, feel free to reach out for help in the [support discord server](https://discord.gg/SbRM8mUjdE).




