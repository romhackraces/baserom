By default, Quick Build will only re-insert resources/tools which have changed since the last 
successful (Quick) Build. In some cases, it might be useful to re-insert a different tool/resource
than the one that changed as well. Quick Build can be extended for this purpose.

Say you have a patch that needs to be re-inserted if a different patch is changed for some 
reason. There is no way for Quick Build to be aware of this abstract dependency between patches,
but we can extend it to take this into account via specifying triggers.

Triggers are specified in a `quick_build_triggers` list, which in our case might look like this:
```
quick_build_triggers
[
    Patches/some_patch.asm -> Patches/dependent_patch.asm
]
```
This will let Quick Build know that if it detects a change in `Patches/some_patch.asm` it should 
not only re-insert that patch, but also re-insert `Patches/dependent_patch.asm` afterwards.

Generally, Quick Build triggers take the form `X -> Y` where `X` is the resource/tool that a change is 
detected in and `Y` is the resource/tool that should be re-inserted in this case.

Any resource/tool that is contained in the `build_order` list can be used in a trigger (with the 
exception of `Patches`). (_See_ [Build order](Setting-up-Lunar-Helper-(new-project)#build-order))

For example, we could have a `PIXI -> GPS` trigger, which would make it so whenever PIXI is 
re-inserted by Quick Build, it will also re-insert GPS afterwards.

Note that triggers can trigger other triggers, i.e. if we have `PIXI -> GPS` and 
`GPS -> Map16` triggers and PIXI is re-inserted by Quick Build, then GPS will be 
re-inserted at some point after PIXI and Map16 will be re-inserted at some point
after GPS.

Any re-insertions that are not a trigger or caused by a trigger are performed at the end of the
Quick Build process.

Note that when using Lunar Monitor, Quick Build should not notice changes made from inside Lunar Magic
and thus Map16, Levels, GlobalData and SharedPalettes will normally only trigger if these 
resources have been changed through other means (a version control system, for example).

Note that constructs such as
```
quick_build_triggers
[
    GPS -> PIXI
    PIXI -> GPS
]
```
are forbidden, as they would lead to an infinite loop. Lunar Helper will throw an error about
"cyclic triggers" if this case is detected.