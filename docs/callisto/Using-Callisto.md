Now that you have successfully set up Callisto, it is time to actually *use* it.

You have already seen Callisto's main menu, which is where all functions it can perform are freely available from.

We will now briefly go through each of them.

# `Rebuild`

You have already used `Rebuild`, what it does is:

- ensure that there are no unsaved resources in your `output_rom` (otherwise, it prompts you to save first)
- make a copy of your `clean_rom` in the `temporary_folder`
- apply all steps of the `build_order` to the temporary ROM
- report any errors
- if there are none, rename the temporary ROM to the `output_rom`, write a build report and report any detected conflicts between resources

That's all `Rebuild` does! You might already have noticed that it is pretty slow, but it is the most consistent way to build your hack, ensuring reproducible results.

# `Update`

`Update` is exactly what it sounds like, `Rebuild` for the impatient.

If you're curious, this is what the customized asar version that comes with Callisto is actually necessary for.

`Update` does the following:

- check if the `output_rom` exists (otherwise fall back to `Rebuild`)
- check that a build report is available for the output ROM (otherwise fall back to `Rebuild`)
- check that the build order has not changed compared to the last build (otherwise fall back to `Rebuild`)
- ensure that there are no unsaved resources in your `output_rom` (otherwise, it prompts you to save first)'
- make a copy of the `output_rom` in the `temporary_folder`
- for each part of the build order, check if the corresponding resource/tool or any files it depends on has changed since the last build, if so the resource/tool will be reinserted (for some changes, `Rebuild` will be called instead), otherwise, the step is skipped
- report any errors
- if there are none, rename the temporary ROM to the `output_rom` and write a build report

`Update` is essentially the equivalent of how hacking is "usually" done, applying tools to an already hacked ROM whenever any changes are made that require re-insertion. The advantage of `Update` over the manual process (and batch scripts) is that it can automatically figure out which parts of the project require re-insertion and even whether the changes require a full rebuild, which can sometimes be the case (i.e. a patch no longer hijacks a part of the ROM it used to hijack, levels were removed from the levels folder, etc.).

Compared to `Rebuild`, `Update` is often faster by a ridiculous margin (for some projects as much as 1 second vs 40 seconds), but it *can* be less accurate than a rebuild and also notably **does not** offer conflict detection. I would thus recommend using `Update` when things are going "right" and `Rebuild` when things are going "wrong". The rationale being that if nothing is breaking with `Update`, it is unlikely that things would break with a `Rebuild`, but if things *are* breaking, there may be conflicts or other accumulated artifacts due to `Update` that a `Rebuild` can either report to you or get rid of.

If you are patient by nature, you may prefer to `Rebuild` every time, with one **important exception**:

| :exclamation:  If you change the number of extra bytes a custom sprite takes **after you have already inserted it**, you **must** use `Update`|
|-----------------------------------------|

This is because after you make a change like this, PIXI has to fix the level data to match the new extra byte count and there is simply no good way to accomplish this during a rebuild, since the levels must be in the ROM for PIXI to do this, but the levels also **cannot** be inserted into a clean ROM before PIXI has ran on it and **also** cannot be inserted into a clean ROM on which PIXI has been run, since the extra byte counts will mismatch between what Lunar Magic expects and what's actually in the levels in both cases, which will result in it corrupting your level data before PIXI can fix it. Long story short: use `Update` if you change extra byte counts after you have already inserted the sprite. I do have a workaround for this in mind, but it is extremely gross and it will take a while for me to come to terms with it and implement (if I do so at all).

# `Package`

This option will just take whatever ROM is at `output_rom` and pass it through FLIPS, outputting the resulting ROM at `bps_package`.

This is in contrast to Lunar Helper, which would `Rebuild` the `output_rom` first and only package it afterwards, which made it less predictable what your package would actually contain. This is now no longer the case, you will get exactly what is in your `output_rom` with Callisto.

# `Save`

This option will export all resources from your `output_rom` to the relevant configured locations. The output is often interleaved since it will use multithreading to speed up the process, which can save multiple seconds. Note that `Save` should ensure that you don't accidentally overwrite (Ex)Graphics which differ from the ones stored in your ROM, since it is usual to edit graphics externally. If you forget to import edited graphics into your ROM prior to a `Save`, you may get a prompt about it which can be easy to miss in all the output. If it seems like the `Save` might be stuck, scroll up a bit and look for prompts to respond to.

# `Edit`

This option will open your `output_rom` in Lunar Magic for you. If you press it multiple times without switching the ROM in Lunar Magic, it should keep bringing the same window you already had open to the front!

Note that by default, Callisto will also automatically reload Lunar Magic windows opened with the `Edit` function for you whenever a `Update` or `Rebuild` succeeds, which is useful since the ROM will immediately reflect any modifications. If you would like to disable this feature, add

```toml
settings.enable_automatic_reloads = false
```

to your `project.toml` file.

Furthermore, `Edit` can also be configured to enable automatic resource exports from Lunar Magic, which makes manual usage of `Save` unnecessary in most cases. For details on this feature which is not completely stable yet, please check out [Automatic Resource Exports](Automatic-Resource-Exports).

Note that Callisto can re-attach to Lunar Magic instances which were previously launched with `Edit`, even if you close and re-open Callisto, so there is no need to do anything special in this case.

# `Reload configuration`

This function just reloads Callisto's configuration. This shouldn't be too necessary to use usually, unless your configuration is broken and you're trying to fix it. Configurations are also automatically re-parsed before you use functions like `Rebuild`, `Update` or `Save` to ensure that the configuration is up to date.

# `Reload profiles`

This function concerns a feature which we have not actually covered yet, since it's somewhat advanced. Please refer to [Using Profiles](Using-Profiles) for details, if you're interested and already comfortable with Callisto. Otherwise, don't worry about it for now.

# `View console output`

This just takes you back to the console output view which you switch to during builds and saves in case you want to check the last output again.

# `Exit`

This just closes Callisto. If you close it, you may have to open it again later if you need it again, so proceed with caution and weigh the pros and cons. Really take in the weight of this decision, consider the consequences of your actions, then act with confidence, whichever way you choose to go.

# Other Uses

That's pretty much it for simple usage of Callisto. If you're satisfied, you can just stop here. You know enough to work with Callisto effectively, but there are many more things it has to offer too. If you're comfortable, feel free to have a look at the [Advanced Topics](Advanced-Topics).
