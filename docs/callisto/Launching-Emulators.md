Callisto lets you conveniently launch multiple different emulators directly from its menu and will automatically pass the `output_rom` path to them!

To add emulators to Callisto's menu, open your `%appdata%/callisto/user.toml` file, which you should have gotten set up earlier.

You should see some commented out lines at the bottom:

```toml
# [emulators.Mesen2]
# executable = "path/to/my/emulators/Mesen.exe"
# options = "--fullscreen"

# [emulators.snes9x]
# executable = "path/to/my/emulators/snes9x.exe"
```

These lines show examples of how to set up your emulators.

To set up an emulator, start with `[emulators.SomeEmulatorNameHere]` the `SomeEmulatorNameHere` part can be anything you want (as long as there are no spaces, check the TOML format's specification to see what's allowed!) and only affects how the name is displayed in Callisto's menu.

After the `[emulators.EmulatorName]` header, specify the path to the executable by setting `executable = "path/to/your/emulator/YourEmulator.exe"` and, if necessary, specify any options that should be passed to the emulator. The `output_rom`'s path is always automatically passed to the emulator as the final argument.

For the following setting:

```toml
[emulators.Mesen2]
executable = "path/to/my/emulators/Mesen.exe"
options = "--fullscreen"
```

if your `output_rom` path is `C:/my_hack/my_hack.smc`, Callisto will launch the emulator via `path/to/my/emulators/Mesen.exe --fullscreen C:/my_hack/my_hack.smc`.

Your emulator list will then show up similarly to this, on the right side of Callisto's main menu:

![callisto_CUiRd6Kr4Y](https://github.com/Underrout/callisto/assets/8695490/01ceb5b5-c9fb-47eb-b45d-d6bcdec3bf5c)

You can launch the corresponding emulator by either navigating to it with your arrow keys or by pressing the number next to the emulator's name on your keyboard, i.e. I could press "1" to launch my `output_rom` in Mesen 2 in this screenshot.

That's all there is to it, your emulators are shared across all projects since you've set them in your user settings, so you only need to do this setup once!
