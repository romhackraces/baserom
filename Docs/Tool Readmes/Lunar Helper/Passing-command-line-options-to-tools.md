In this chapter, we will briefly talk about the possibility of passing command line options to the underlying tools through Lunar Helper.

You can pass command line options to the following tools:
- PIXI
- GPS
- AddMusicK
- UberASM Tool
- Lunar Magic

To do so, specify the `pixi_options`, `gps_options`, `addmusick_options`, `uberasm_options` or `lm_level_import_flags` config variable in a config file.

For example, if I wanted GPS output to include more information during insertion, I would add the line `gps_options = -d` to one of my config files. Note that the `pixi_options` variable is already included in `config_project.txt` since most people don't like the default list location PIXI uses.

The `lm_level_import_flags` variable is a bit different than the others, since it only controls whether the amount of screens in levels is auto-set during insertion or not. Setting it to 1 will auto-set the screen amount, 0 won't, the default is 1.

Any of the other options are passed to the underlying tools verbatim.

For information on the available options, please consult the corresponding tool's readme file(s).