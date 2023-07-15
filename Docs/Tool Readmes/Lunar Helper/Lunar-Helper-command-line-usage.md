Lunar Helper supports `--build`, `--quickbuild`, `--package` and `--profiles` command line options, 
which you can use to quickly perform the corresponding actions without having to navigate 
Lunar Helper's menu or even to further automate processes by invoking Lunar Helper from a script 
or git hook. 

The exit code will be 0 if the (quick) build/package process succeeded or -1 if errors were 
encountered. `--help` or `-h` can be used to quickly see the available options.

Optionally, you can pass a second command line option after `--build`, `--quickbuild` and `--package` 
in order to specify the name of the profile to use when building the ROM. For example, if I wanted 
to build the ROM from scratch using a `Debug` profile, I would use `LunarHelper.exe --build Debug`.
`--profiles` can be used to get a list of available profiles.

You can also pass a `-v` option for `--build`, `--quickbuild` and `--package` in order to specify
how they should handle potentially unexported resources if there might be some in a ROM that would 
be overwritten by the build. 

`-v Y` will export all resources from the ROM and then continue building, `-v N` will not export
resources and just continue building (this can potentially overwrite unexported resources in the
ROM so be careful) and `-v C` will cancel the build with an error if such resources are detected
(C is the default).