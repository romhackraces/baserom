This chapter is not so much about how to configure Callisto and more about how you as a user can reorganize and modify the configuration files to better fit whatever structure you prefer to have.

# Reorganizing Configuration Files

As it turns out, you can actually split your configuration into as many or as few files as you please. This goes for your user files in `%appdata%/callisto`, the config files in your project's Callisto folder as well as the config files in any profile folders you're using (see [Using Profiles](Using-Profiles) for details on profiles).

All you have to do for this to still work correctly is ensure that you also move any headers along with the settings you're moving. By that I mean that if you're looking at, say, `resources.toml`, you will see `[resources]` somewhere in the file. This is a [TOML header](https://toml.io/en/v1.0.0#table) which affects any assignments under it until the end of the file or the next such header. So, if you move, say `titlescreen = "resources/titlescreen.bps"` somewhere else from the `resources.toml` file, you will need to ensure that it still says `[resources]` somewhere above it or alternatively use `resources.titlescreen = "resources/titlescreen.bps"`, which should also be valid. Ideally, check the TOML syntax for details.

# User Variables

You can actually define your own variables in a config file, if you want. These serve to remove some of the redundancies you might run into during configuration. For example, you might have 

```toml
[output]
output_rom = "build/my_hack.smc"
bps_package = "build/package/my_hack.bps"
```

somewhere. It might be nice if instead you could write 

```toml
[output]
output_rom = "build/{project_name}.smc"
bps_package = "build/package/{project_name}.bps"
```

and write

```toml
[variables]
project_name = "my_hack"
```

somewhere else, so that you can change both the name of the output ROM and the BPS patch in one location.

As it turns out, you can do it exactly like I just showed, with the special condition that all your variables for a specific level of configuration (user, project, profiles) must be in a file named `variables.toml` at the corresponding level, unless all your configuration for that level is in just one TOML file, then you can just put the `[variables]` table right in there as well if you want.

That means, if my project's callisto folder is `my_hack/callisto` I would have to put

```toml
[variables]
project_name = "my_hack"
```

in a `my_hack/callisto/variables.toml` file, unless I only had one config file in that folder, say, `my_hack/callisto/config.toml`, then I could put the variables in there instead if I wanted to. The same would apply if I added any more variables. Note also that you do need the `[variables]` header in both cases.

As you might have guessed from the earlier example, to use your defined variable in a string, you just wrap it between `{` and  `}`.

If you for some reason need to use literal `{` and `}` characters in a string, just double them, so `{` becomes `{{` and `}` becomes `}}`.

Profiles (see [Using Profiles](Using-Profiles)) inherit user variables from your project's main Callisto folder, but can also add their own ones in their own `[variables]` table as well if needed.

For the curious, yes, it is valid to use variables inside other variables, like this for example:

```toml
[variables]
hello = "hello"
world = "world"
hello_worlrd = "{hello} {world}"  # expands to "hello world"
```

And that's all there is to user variables. 