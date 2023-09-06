(It is recommended that you read [Using Modules](Using-Modules) and [Using Profiles](Using-Profiles) before this chapter.)

Callisto offers some interesting functionality for writing hybridized resources which can behave in different ways, depending on whether they're being inserted with Callisto or not.

When Callisto is inserting a patch or a module, it will implicitly pass `!CALLISTO_ASSEMBLING = 1` to the resource. This lets you determine whether Callisto is available for use or not.

As you might have already heard previously, Callisto will create a `callisto.asm` file at `.callisto/callisto.asm` in the root of your project prior to every build. 

This file contains various information about Callisto, as well as the current profile that's in use if there are any (see [Using Profiles](Using-Profiles)).

In addition, this file also contains a few macros for including/calling modules, as well as a `require_callisto_version(major, minor, patch)` macro, which can be used to error out if the used Callisto version is lower than the one required. I.e. if we use `%require_callisto_version(0, 2, 0)` and the user is using Callisto version 0.1.0, we will throw an error.

To safely include this file in resources if it is available, you can use:

```
if defined("CALLISTO_ASSEMBLING")
    incsrc "callisto.asm"
endif
```

Let's say you are working on a patch that adds some functionality to a hack that can then be called from other resources. This is essentially what a module is! But not everyone is using Callisto, so we might still want to distribute it as a patch, but also offer it as a module to people who *are* using Callisto.

To do this, you could write your patch in a way where it can be inserted as *either* a patch or a module by checking for `!CALLISTO_ASSEMBLING` and instructing Callisto users to insert the patch as a module instead of a patch.

Perhaps you could also offer debug functionality in your patch by doing something like this:

```
if defined("CALLISTO_ASSEMBLING")
    incsrc "callisto.asm"
endif

!debug_profile_name = "debug"  ; if you're using Callisto, change this to match your debug profile's name

; ...

!CALLISTO_PROFILE = ""
if not(stringsequal(!CALLISTO_PROFILE, !debug_profile_name))
    ; non-debug/non-callisto-user code here
else
    print "Inserting patch in Callisto debug mode to make debugging easier!"
    ; debug code here
endif
```

That way, if the Callisto user switches to their debug profile, your patch will automatically compile the other code, which may in some situations facilitate easier debugging. Of course you're not limited to doing this with debug code, you could offer a variety of different functionality depending on the user's selected profile while still offering people who aren't using Callisto a perfectly normal patch.

Unfortunately, there is not yet an easy mechanism to offer hybrid functionality like this for resources other than patches and modules, since other resources aren't inserted by Callisto and there is no simple way to pass defines like `!CALLISTO_ASSEMBLING` as well as additional include paths to other tools as far as I'm aware, though this might change in the future!

Hopefully this gives you some fun ideas, there are probably a lot more possibilities I haven't considered yet. If you come up with any cool use-cases, please do let me know and I might add them here!