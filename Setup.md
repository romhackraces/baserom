# Setting up the RHR Baserom

**Provide a Clean ROM**

Put a copy of your clean, headered Super Mario World ROM in the *resources* folder, renamed "clean.smc". This step is not required for setup but it is still recommended because otherwise the build process will complain about it later.


## Windows

**1. Run The Setup Script**

Run both actions that you're prompted to do by the `setup.bat` script–to download and set up all the tools, and do a first build of your project.

**2. Use Callisto**

After setup, launch the Callisto executeble (found in tools/Callisto) to manage your project. Run "Edit" to launch Lunar Magic, using the "Update" action to apply changes.


## Linux/Mac

The non-windows version of the baserom has several extra steps and dependencies required for you to be able to get going.

**1. Install WINE**

Version 11 is required for the ideal experience, but a least 10 is ideal. You can check the version by running `wine --version` in a terminal.

**2. Install Program Dependencies**

Set up dotnet8 (or higher) in your WINE prefix with `winetricks`:

```console
$ winetricks dotnetdesktop8
```

**3. Install Setup Dependencies**

This will differ between operating systems, but you should use your OS's package manager to make sure the following executables available on your system (these may be available by default):

```
7z patch curl sed jq
```

**4. Run The Setup Script**

Run the setup shell script which will download all the tools required for the baserom.

```console
$ chmod +x setup.sh
$ ./setup.sh
```
It is recommended after setup to run a `build` action in Callisto to get a clean first build.


**5. Use Callisto from the Terminal**

Instead of running the Callisto executeable through WINE, it needs a workaround. You can use the provided `run-callisto.sh` shell script in a terminal to perform Callisto actions.

```console
$ chmod +x run-callisto.sh
$ ./run-callisto.sh ACTION
```

`ACTION` is one of `rebuild`, `update`, `save`, `edit`, `package`, or `profiles`. See `./run-callisto.sh --help` for more info. 

**Note: Running Callisto normally is not possible because it's TUI does not work within WINE.**
