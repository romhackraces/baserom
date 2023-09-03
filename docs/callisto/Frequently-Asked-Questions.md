This page gives a brief overview of some common questions about setting up and using Callisto. If your question does not appear here, feel free to reach out in the [Discord server](https://discord.gg/SbRM8mUjdE).

***

> Callisto says `[error] toml::parse_basic_string: the next token is not a valid string` when parsing configuration, what's wrong?

Likely what happened is that you used backslashes (`\`) in a file path instead of forward slashes (`/`). Just replace your backslashes with forward slashes and see if that helps. If you want to use backslashes anyway, you will need to escape them by doubling them, i.e. use `\\` instead of `\`. (This is a normal part of the [TOML specification](https://toml.io/en/v1.0.0#string).) 

***

> When I use `Save`, it gets stuck, what's wrong?

What likely happened is that the (ex)graphics that were exported from your ROM differed from the ones stored in your project's (ex)graphics folder(s). This should usually not happen unless you:

- keep random files in your (ex)graphics folders, which is not recommended
- forgot to import graphics you edited into the ROM (using `Update` or `Rebuild` instead of importing would also have worked)

When Callisto detects this, it avoids overwriting the external graphics with the ones from the ROM and instead will first prompt you on whether it should overwrite them or not. This can sometimes be hard to see since the `Save` operation is multithreaded and the output can be chaotic. Just scroll up a little and see if you find any prompts, there can be up to two. All you need to do is enter `Y` or `N` as desired and press enter.

