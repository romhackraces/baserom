Lunar Magic uses a binary format for its .map16 files. This is not optimal for usage with git, since it does not handle binary files particularly well, it does much better with text files.

For this purpose, I made a small tool to convert from Lunar Magic's binary format to a text-based format that git can interact with much better. Lunar Helper and Lunar Monitor are built with this tool in mind and can seamlessly convert to/from the format, meaning you should never have to run the tool by hand (though you certainly could if you wanted to).

To use this format, download the latest version of the conversion tool from https://github.com/Underrout/human-readable-map16-cli/releases/latest. Then take the `human-readable-map16-cli.exe` file from the ZIP archive and extract it to some place within your project. For example, a `MyHack/Tools` folder.

Then set the `human_readable_map16_cli_path` config variable, both in Lunar Helper and Lunar Monitor, and point it to the `human-readable-map16-cli.exe` file you just extracted into your project. In my case, it would look like this in Lunar Helper's config:

```
human_readable_map16_cli_path = Tools/human-readable-map16-cli.exe
```

and this in Lunar Monitor's config:

```
human_readable_map16_cli_path: "Tools/human-readable-map16-cli.exe"
```

You can also specify the `human_readable_map16_directory_path` config variable to customize where the tools will output the converted format to. By default, if this variable is omitted, the output will be placed in a folder with the same name and location as the `map16` config variable. Again, you have to specify this variable for both Lunar Helper **and** Lunar Monitor if want to use it.

For example, if I have `map16 = Other/all_map16.map16`, then if I omit the variable, my converted folder would be `Other/all_map16`. If I specified `human_readable_map16_directory_path = Other/converted_map16`, then my converted files would be output at `Other/converted_map16`.

For details on the converted text format and how the conversion tool works, check out its [readme](https://github.com/Underrout/human-readable-map16-cli#readme).

