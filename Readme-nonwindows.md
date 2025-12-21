## How to set up when you are not using Windows:

1. **Install Wine** at least version 11. You can check the version by running `wine --version`.

2. Set up dotnet8 (or higher) in your wine prefix with winetricks:

```console
$ winetricks dotnetdesktop8
```

3. **Install Dependencies.** This will differ between operating systems, but you should use your OS's package manager to make sure the following executables available on your system (these may be available by default):
    - 7z (7zip)
    - patch
    - curl
    - sed

4. **Run the setup script.** Run `./setup.sh`.

5. **You can now use callisto from the terminal.** Run `./run-callisto.sh ACTION` where `ACTION` is one of `rebuild`, `update`, `save`, `edit`, `package`, or `profiles`. See `./run-callisto.sh --help` for more info.
