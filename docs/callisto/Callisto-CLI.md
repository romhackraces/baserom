All main functions of Callisto are also available via command-line calls.

You can use `callisto.exe --help` to see them, I will also show a short list of them here.

## `callisto.exe rebuild`

This is equivalent to `Rebuild`.

You can pass `--no-export` to make Callisto not call `Save` prior to the build if there may be unsaved resources in your ROM, which it will do by default. Instead, it will error out if there may be unsaved resources, aborting the build.

## `callisto.exe update`

This is equivalent to `Update`.

The `--no-export` flag can also be passed with this command and has the same effect as with `rebuild`.

## `callisto.exe save`

This is equivalent to `Save`.

## `callisto.exe edit`

This is equivalent to `Edit`. Note that this also supports automatic ROM reloads and automatic resource exports if you have those enabled, just like Callisto's main menu.

## `callisto.exe package`

This is equivalent to `Package`.

## `callisto.exe profiles`

This will list the configured profiles for this project (see [Using Profiles](Using-Profiles) for details). Each profile name will appear on its own line.

If you are using profiles, you can also pass the profile to use during builds/saves to `rebuild`, `update` and `save` with the `--profile` option, i.e. `callisto.exe rebuild --profile release` is the same as selecting the `release` profile in Callisto's menu and using `Rebuild`.

## Other Options

The `--max-threads`, `--allow-user-input` and `---check-pending-save` options you may see in the help message, while technically usable, are mostly meant for `eloper.exe` to use when telling Callisto to perform an automatic export. Using them yourself is not recommended, but may work fine anyway.