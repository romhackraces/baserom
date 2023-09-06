(It is recommended that you read [Customizing the Configuration](Customizing-the-Configuration) before this chapter.)

Profiles are a feature of Callisto that allows you to easily and quickly switch between different ways of building your project. This can be really useful in many situations. Maybe you want to include certain patches only while you're actually working on the project, but not when you're releasing it to testers or maybe you want to use different verbosity levels for tool output when you're trying to find a bug. There are endless possibilities!

# Creating Profiles

Profiles are easy to create too, just add a `profiles` folder next to `callisto.exe` and then another folder inside the `profiles` folder for each profile you want to create. For example, I will add a `release` and `debug` profile to my project, like this:

```
my_hack/
└── callisto/
    ├── asar.dll
    ├── callisto.exe
    ├── eloper.exe
    ├── profiles/
    │   ├── debug/
    │   └── release/
    └── (various other files ending in .toml)
```

Now, the thing about profiles is that they can overwrite settings from the "main" configuration of the project, which are the `.toml` files that are immediately next to `callisto.exe`. So if I were to add another `project.toml` file in my `release` folder and add something like

```toml
[output]
output_rom = "build/my_released_hack.smc"
```

to it, then my hack would be built as `my_released_hack.smc` when building while in the `release` profile, neat!

The only exception to this are the `patches` and `module` lists; If the `patches` list next to my `callisto.exe` says

```toml
[resources]
patches = [
	"resources/patches/stickyground.asm"
]
```

and the `patches` list in my `profiles/debug` says

```toml
patches = [
	"resources/patches/cpumeter.asm",
]
```

the two lists will be internally combined by Callisto, so all patches from the main configuration and profile configurations will be applied if the `Patches` symbol appears in the build order. The same applies for modules!

As with the main configuration, you can split your configuration up into files however you'd like.

That's more or less it for high-level profile usage. Callisto will show you a nice little menu to the right of its main menu when profiles are in use so you can easily switch between them:

![callisto_UqPJHqHzM0](https://github.com/Underrout/callisto/assets/8695490/e114c04b-48db-474a-80cb-9923bdc47c30)

(Fair warning, the navigation in the profiles menu is a little broken and I'm unsure of how to fix it, so if it's hard to select the right profile, I know, it's hard for me too.)

Callisto will also remember the currently selected profile, so if you close it and open it again, the same profile should still be selected!

Profiles will also work correctly with [Automatic Resource Exports](Automatic-Resource-Exports), even if you change the location resources use between profiles. The automatic resource exports should always use the currently selected profile, as you would expect.

Please note that if you change the name or number of profiles while Callisto is open, you should use the `Reload profiles` function afterwards so that Callisto can refresh that information.

That's pretty much it for high-level usage of profiles. You can already do a lot of cool stuff with this, but for the ASM-savy, there is an additional section below that allows low-level customization of resources depending on the active profile you can dive into too!

# Low-level Profiles

If you've read the [Using Modules](Using-Modules) chapter, you may already know a bit about the `callisto.asm` file that Callisto generates before each build at `my_hack/.callisto/callisto.asm`. This file contains some useful information and macros provided by Callisto. In patches and modules, it can be included with just `incsrc "callisto.asm"`, in other resources you unfortunately will have to give the entire path explicitly to include it.

When profiles are in use, this file will contain the following lines in addition to its usual contents:

```
; Define containing the name of the active profile
!CALLISTO_PROFILE = "debug"
```

where `"debug"` is the name of the currently selected profile at the time of the build. This allows you to easily customize code depending on the selected profile by including `callisto.asm` and using asar's `if` statements. For example, maybe there is a certain piece of code I would rather not run while the `debug` profile is selected, I could accomplish that like this:

```
!CALLISTO_PROFILE ?= ""
if not(stringsequal(!CALLISTO_PROFILE "debug"))
    ; code here will be inserted in all cases except if 
    ; the selected profile is called "debug"
endif
```

The `!CALLISTO_PROFILE ?= ""` is a safeguard which will set `!CALLISTO_PROFILE` to an empty string if it is not defined. This ensures we don't get any asar errors if no profiles are in use or the resource is assembled without Callisto.

And that's all there is to using profiles in ASM.
