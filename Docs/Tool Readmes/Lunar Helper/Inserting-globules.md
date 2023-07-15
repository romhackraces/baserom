"Globules" are globally inserted pieces of code or data that are not directly tied to any particular tool or resource, but can instead be used from practically anywhere. They are similar to PIXI/GPS routines or UberASM Tool's library folder, but offer additional flexibility.

Globules are inserted and managed directly by Lunar Helper and can be removed or added at any time without having to do a full rebuild.

To use globules, create a dedicated folder, `MyHack/Globules`, for example, and add the `globules_path` config variable to your Lunar Helper configuration, pointing it to this folder:

```
globules_path = Globules
```

for example.

Any .asm file in the root of this folder will be inserted as a globule by Lunar Helper. Files in subfolders will be ignored.

A very simple `MakeBig.asm` globule with a routine in it might look like this:
```
main:
    LDA #$01
    STA $19   ; store $01 to powerup status, making Mario big!
    RTL
```

Note that globule code must end in `RTL`.

If we place this file in our `Globules` folder, Lunar Helper will insert the code into our ROM at the start of our next (quick) build.

After Lunar Helper inserts globules at the start of a build, it will store a file containing the address of the inserted globule's labels to `.lunar_helper/globules/globule_name.asm`. In our case, this would be `.lunar_helper/globules/MakeBig.asm`. The labels in this file are prefixed with the name of the globule, meaning our code would have the label `MakeBig_main`. Every label is also available as a define, meaning `!MakeBig_main` will contain the address of the code as well.

To call our `main` function, we would just `incsrc` the `.lunar_helper/globules/MakeBig.asm` file and then call it using the `%call_globule` macro. This macro is automatically included when including any globule and allows you to easily call a globule function. In our case it might look something like this:
```
incsrc "../../.lunar_helper/globules/MakeBig.asm"`

main:
    LDA $14
    AND #$07  ; every 8th frame...
    BNE .skip
    %call_globule(MakeBig_main)  ; make player big
.skip
    RTL
```
Obviously it's overkill to use a globule for such simple code, but if you had more complex code, large chunks of data or need to operate on label addresses in some way, globules can come in very handy.

## Limitations & Caveats

### Reading data

Note that since globules are likely in different banks than the code accessing it, you will probably want to use long addressing or change the data bank register when reading data from a globule. (The `%call_globule` macro handles this for you when calling globule functions.)

### Dependencies between globules

Globules should **not** currently call/access other globules. While this could work, it is dependent on insertion order, which is essentially arbitrary and could fail at any point. For now, please don't call or access globules from other globules, as this may break at any time. This may be remedied in the future.

### Globules without labels

Globules without any labels in them are not only useless, since they cannot be called or accessed, but will also leak freespace. Please ensure your globules have at least one label in them so that they can be accessed and don't leak freespace.

