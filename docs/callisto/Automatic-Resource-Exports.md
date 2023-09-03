As stated in [Using Callisto](Using-Callisto), the `Edit` function can be configured to automatically call `Save` whenever you save:

- a level
- map16
- or the overworld

in Lunar Magic. 

This feature is **not** implemented ideally at the moment and thus must be explicitly turned on. To do this, add

```toml
enable_automatic_exports = true
```

somewhere in your `project.toml` file under the `[settings]` header.

After doing so, you should see the following indicator pop up under the main Callisto menu whenever you save a level, map16 or the overworld in Lunar Magic:

![indicator](https://github.com/Underrout/callisto/assets/8695490/7eac6688-c607-4dd6-9bf2-eb9367d942ac)

Of course, this automatic export can fail. Your configuration could be invalid or something else could go wrong. In this case you will likely get a popup that will tell you where you can find an error log to check what went wrong.

Note that if an automatic save is in progress and you start another one by saving something in Lunar Magic again, the earlier save will be aborted and a new one will start, so you don't need to worry about "saving too often" or anything like that.

Callisto will ensure that you cannot accidentally build or save in its menu while an automated save is in progress. This is usually desirable, but there is an outside chance that an automated save *could* get stuck indefinitely. In this case, you may need to manually stop the process. To do so, open your task manager, locate an `eloper.exe` process (this is the tool that resides next to `callisto.exe` and handles interaction with Lunar Magic) and end it. After this, you may still need to re-open Callisto and use `Edit` again, but should then be able to continue as normal.

If stuck saves or other issues become a common occurrence, you may prefer sticking to manually using `Save` from within Callisto for the time being.
