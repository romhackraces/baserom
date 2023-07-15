**Note: This section assumes you have previously performed the steps in [Setting up Lunar Helper (new project)](Setting-up-Lunar-Helper-(new-project)) or [Setting up Lunar Helper (preexisting project)](Setting-up-Lunar-Helper-(preexisting-project))**

# Setup

After setting up the files in the `Lunar Helper` folder of the `LunarHelper-vX.X.X.zip` you downloaded, go back to the main folder of the zip archive and open the `Lunar Monitor` folder.

It should contain the following:

- a `lunar_monitor` folder
- a `lunar-monitor-config.txt` file
- a `LunarMonitorLoader.exe` file
- a `usertoolbar.txt`file

Take the `lunar_monitor` folder, `usertoolbar.txt` file and the `LunarMonitorLoader.exe` file and copy all of them to the same folder as your project's Lunar Magic executable. In the example used throughout the Lunar Helper setup, it would look like this afterwards:

```
MyHack/
├── LunarHelper/
├── Other/
├── Tools/
│   └── LunarMagic/
│       ├── lunar_monitor
│       ├── Lunar Magic.exe
|       ├── LunarMonitorLoader.exe
│       └── usertoolbar.txt
├── Levels/
└── Build/
```

Note that your `lunar_monitor_loader_path` variable from the Lunar Helper setup should now be pointing to the `LunarMonitorLoader.exe` file we just pasted. Make sure this is actually the case.

The purpose of Lunar Monitor Loader is to "inject" the Lunar Monitor tool into Lunar Magic. Lunar Monitor will, once injected, ensure that changes to the ROM you make in Lunar Magic are automatically exported whenever you save your changes. For example, whenever you save a level while Lunar Monitor is running, the level will be exported to our `Levels` folder. Note that you should **launch Lunar Monitor Loader** instead of launching Lunar Magic directly, otherwise your Lunar Magic **will not** be injected!

This ensures that Lunar Helper always uses up-to-date resources when building your ROM.

Now, take the `lunar-monitor-config.txt` file from the zip archive and place it in the same folder as the path of the `output` ROM from Lunar Helper's configuration. Following the example from Lunar Helper's setup, I will place my Lunar Monitor config file in the `Build` directory:

```
MyHack/
├── LunarHelper/
├── Other/
├── Tools/
├── Levels/
└── Build/
    ├── Temp/
    └── lunar-monitor-config.txt
```

Note that the file name **has to be** `lunar-monitor-config.txt` or Lunar Monitor may ignore the file!

# Configuration

## Paths

Now, go ahead and open this `lunar-monitor-config.txt` file:

```
level_directory: "Levels"
flips_path: "Tools/FLIPS/flips.exe"
map16_path: "Other/all.map16"
clean_rom_path: "clean.smc"
global_data_path: "Other/global_data.bps"
shared_palettes_path: "Other/shared.pal"

log_path: "Other/lunar-monitor-log.txt"
log_level: Log
```

A lot of this should look very similar to the Lunar Helper configuration. Namely, the whole first block of configuration variables here has an exact equivalent in the Lunar Helper configuration.

| Lunar Monitor variable | Lunar Helper variable |
|------------------------|-----------------------|
| `level_directory`      | `levels`              |
| `flips_path`           | `flips_path`          |
| `map16_path`           | `map16`               |
| `clean_rom_path`       | `clean`               |
| `global_data_path`     | `global_data`         |
| `shared_palettes_path` | `shared_palette`      |

Make sure that all the Lunar Monitor paths point to the same locations as the corresponding Lunar Helper variables.

Note that any paths in the `lunar-monitor-config.txt` file are relative **from the location of that file**, they are not affected by Lunar Helper's `dir` variable. In our example, since our Lunar Monitor config file is in the `MyHack/Build` folder, we will end up with this configuration for these variables:

```
level_directory: "../Levels"
flips_path: "../Tools/FLIPS/flips.exe"
map16_path: "../Other/all.map16"
clean_rom_path: "../clean.smc"
global_data_path: "../Other/global_data.bps"
shared_palettes_path: "../Other/shared.pal"
```

## Logs

The remaining two variables, `log_path` and `log_level` are related to what information Lunar Monitor logs and at which location it should place a log file. This log file can be useful if you're not sure if Lunar Monitor is working/exporting files correctly. This config variable can be omitted, in that case, a `lunar-monitor-log.txt` file will be generated in the same folder as the `lunar-monitor-config.txt` file.

With our setup, we would probably use `log_path: "../Other/lunar-monitor-log.txt`, but you can use any location and name you want for this file.

`log_level` can be one of `Warn`, `Log` or `Silent`. 

`Log` will write every log message to the `log_path` file and to a little added status bar in the lower right corner inside Lunar Magic. This is the default setting if `log_level` is omitted.

`Warn` behaves the same as `Log`, but also pops up a message box inside Lunar Magic if Lunar Monitor encounters a problem, which can be useful for debugging.

`Silent` will discard all log messages and never log anything. I would not recommend using this.

I would recommend sticking with `Log` or changing it to `Warn`, so we would end up with:

```
log_path: "../Other/lunar-monitor-log.txt"
log_level: Warn
```

# Finishing up

After these steps, your Lunar Monitor should be fully set up.

If you're starting a new project, please continue to [Your first build (new project)](Your-first-build-(new-project)).

Otherwise, if you're working with a preexisting project, continue to [Your first build (preexisting project)](Your-first-build-(preexisting-project)).