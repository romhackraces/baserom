## Overriding default emulator

By default, Lunar Helper will try to launch the emulator you have configured for Lunar Magic when using the `R - Run` or `T - Test` functions. To specify a different emulator, use the `emulator_path` and (optionally) `emulator_options` config variables in a config file.

For example, if I had retroarch installed at `C:/Program Files/retroarch/retroarch.exe` and I wanted to use it instead of the emulator I have set up in Lunar Magic, I would add the line

```
emulator_path = C:/Program Files/retroarch/retroarch.exe
```
to one of my config files. Since retroarch also needs to know which core to use, I would also specify 

```
emulator_options = -L C:/Program Files/retroarch/cores/snes9x_libretro.dll
```
to let it know to load a snes9x core. Other emulators may or may not required command line options, please check the corresponding emulator's readme to find out which command line options are available for yours.

## Automatic emulator reload after builds

Sometimes it can be annoying to have to relaunch your emulator every time you want to test a little change. Lunar Helper can be set to automatically relaunch your emulator after successful builds for quick testing.

To enable this, set the `reload_emulator_after_build` config variable in one of your config files like this:

```
reload_emulator_after_build = yes
```

If you now launch your emulator using `R - Run` or `T - Test` from inside Lunar Helper and then rebuild/quick build your hack, Lunar Helper will automatically relaunch your emulator if the build succeeds. Note that this will not work if your emulator was launched any other way, since Lunar Helper only keeps track of emulator processes it launched itself.
