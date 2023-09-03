As you might have noticed already, Callisto may show a message like `2 conflict(s) logged to C:/my_hack/conflicts.txt` at the end of a `Rebuild`. This is Callisto's conflict detection feature in action!

What this feature allows you to do is see at a glance which locations in your ROM are getting written to multiple times by different tools or resources. Since any particular byte in your ROM can only hold a single value between 0-255, if multiple things try to write to the same byte, only the last one in the build order will actually have any effect! This can lead to unexpected problems, a certain patch might write to an address and understandably expect the bytes it wrote there to stay like that. If another patch then comes along later and overwrites the earlier patch's changes, the first patch might break! Issues like this are surprisingly common and have historically been very annoying to figure out and fix, since there are so many moving parts involved in hacking. This is what Callisto aims to fix.

With conflict detection enabled, Callisto will do the following during `Rebuild`:
- after every step of the `build_order`, create a snapshot of the temporary ROM
- note any addresses that were changed by the current build step
- at the end of the build process, note any addresses that were written to by multiple build steps
- report the addresses that were written to multiple times and which build steps wrote to them

It's a fairly simple process, but it is highly effective!

# Configuration

Let's take a brief look at the settings that affect conflict detection. By default, these are all located in the `project.toml` file, so go ahead and open that now if you want to follow along.

## `check_conflicts`

```toml
# Valid values: "none", "hijacks", "all"
check_conflicts = "hijacks"
```

The `check_conflicts` setting determines if Callisto should check for conflicts at all and if so, where it should do so.

Here are the meanings of the three valid values:

| Setting | Meaning                                                                                        |
|---------|------------------------------------------------------------------------------------------------|
| none    | Don't check for conflicts at all                                                               |
| hijacks | Only check for conflicts in the  vanilla area of the ROM (from PC offset 0x000000 to 0x800000) |
| all     | Check for conflicts anywhere in the ROM                                                        |

Conflict detection is performed in a separate thread from the main build process, so the performance hit of enabling it should be minimal, which is why I would generally recommend using the `hijacks` setting. Note that while `all` may sound useful, it is prone to spotting a lot of false positives (meaning two or more writes to the same address happen, but there is no actual problem), which makes it overly verbose in most situations. `hijacks` generally spots actually important conflicts and redundancies.

## `conflict_log_file`

```toml
conflict_log_file = "conflicts.txt"
```

This setting specifies the path where Callisto will output a file containing the conflicts it spotted. You can change this to anything you like, leaving it in the root of your project may be undesirable for some.

If you remove this setting, Callisto will output the conflicts directly during the build process, which I would not recommend, as it gets hard to look at quickly if there are many conflicts.

## `ignored_conflict_symbols`

```toml
ignored_conflict_symbols = [
    "InitialPatch",

    "Overworld",
    "TitleScreen",
    "Credits",
    "GlobalExAnimation",

    "SharedPalettes",

    "ExGraphics",
    "Graphics",

    "Levels",

    "Map16"
]
```

This setting specifies which symbols should not factor into conflict detection. You can put anything that appears in the build order, as well as explicit patch/module paths in here if you want. This basically means that if, for example, the `ExGraphics` step and the `AddMusicK` step of the `build_order` both wrote to the same bytes, this would **not** be noted as a conflict by Callisto. But if `ExGraphics`, `AddMusicK` **and** `UberASM` all wrote to the same byte, this **would** be noted by Callisto, as there are at least **two** non-ignored steps writing to the same address. The write by `ExGraphics` would also be included in the conflict report in this case for completeness, even if it didn't itself trigger the conflict detection.

There are quite a lot of ignored symbols in this list by default. This is due to these seemingly triggering a lot of false positives and generally uninteresting conflicts which clutter the conflict report and make it less useful for detecting actually important conflicts (like patch <-> patch conflicts, tool <-> tool conflicts or patch <-> tool conflicts).

# Let's Detect some Conflicts

That's it for configuration! Let's now look at a practical example for detecting conflicts.

First, we want a baseline, when I build my empty project which uses PIXI, GPS, AddMusicK, UberASMTool and no patches, Callisto logs two conflicts during rebuilds. These are likely false positives and I will ignore them for now (I will give tips for reducing false positives later on).

Now, I will add two patches to my project:

- [Remove Status Bar](https://smwc.me/s/18862)
- [Mario + Animated Tile ExGFX v2.1](https://smwc.me/s/21364)

In my case, my `patches` list will then look like this:

```toml
[resources]
patches = [
	"resources/patches/nuke_statusbar.asm",
	"resources/patches/marioexgfx.asm"
]
```

After I `Rebuild`, Callisto now tells me `6 conflict(s) logged to C:/my_hack/conflicts.txt`, interesting!

Checking the `conflicts.txt` file, I can see four new conflicts which were not there before:

```
Conflict - 0x1 byte at SNES: $808E1C (unheadered), PC: 0x00101C (headered):
	Original bytes:
		14 
	Initial Patch:
		74 
	Patch (resources\patches\nuke_statusbar.asm):
		00 
	UberASM:
		F1 

Conflict - 0x2 bytes at SNES: $808E1D (unheadered), PC: 0x00101D (headered):
	Original bytes:
		05 9D 
	Patch (resources\patches\nuke_statusbar.asm):
		00 00 
	UberASM:
		10 EA 

Conflict - 0x3 bytes at SNES: $80A5D5 (unheadered), PC: 0x0027D5 (headered):
	Original bytes:
		20 1A 8E 
	Patch (resources\patches\nuke_statusbar.asm):
		80 01 EA 
	Patch (resources\patches\marioexgfx.asm):
		22 16 E0 

Conflict - 0x3 bytes at SNES: $85D8B9 (unheadered), PC: 0x02DAB9 (headered):
	Original bytes:
		A5 0E 0A 
	Patch (resources\patches\marioexgfx.asm):
		EA EA EA 
	PIXI:
		20 46 DC 
	UberASM:
		EA EA EA
```

(Depending on your setup, you may see different conflicts.)

Let's look at just the last of these conflicts to get a feel for the format:

```
Conflict - 0x3 bytes at SNES: $85D8B9 (unheadered), PC: 0x02DAB9 (headered):
	Original bytes:
		A5 0E 0A 
	Patch (resources\patches\marioexgfx.asm):
		EA EA EA 
	PIXI:
		20 46 DC 
	UberASM:
		EA EA EA 
```

Let's start with the first line:

```
Conflict - 0x3 bytes at SNES: $85D8B9 (unheadered), PC: 0x02DAB9 (headered):
```
This tells us that there are 3 bytes which were written to multiple times. These bytes are loated at the unheadered SNES address $85D8B9 (note that these addresses can be written multiple ways due to [LoROM addressing](https://en.wikibooks.org/wiki/Super_NES_Programming/SNES_memory_map#LoROM)). Callisto also shows the headered PC address which may be helpful for finding the bytes in some hex editors.

Next comes the list of writes:
```
	Original bytes:
		A5 0E 0A 
	Patch (resources\patches\marioexgfx.asm):
		EA EA EA 
	PIXI:
		20 46 DC 
	UberASM:
		EA EA EA 
```

These are ordered top to bottom with the first write at the top and the last write at the bottom. The three bytes under `Original bytes` show the bytes that were at that location in the vanilla SMW ROM, every subsequent entry shows the three bytes that the corresponding resource wrote to the same location. 

Out of the six conflicts Callisto logged during our last `Rebuild`, the most notable of them is the third one between `nuke_statusbar.asm` and `marioexgfx.asm`. This is an actual real incompatibility between the two patches we just found! The other conflicts between the patches and `UberASM` and `PIXI` might also be interesting to look at if it turns out our hack is having issues after we applied the patches. It is important to note that just because Callisto logs something as a conflict, doesn't necessarily mean that it is an actual problem. Patches and tools **can** write to the same location and either intentionally or accidentally not cause any problems. Conflicts logged by Callisto only serve as a helpful starting point for further investigation, since Callisto cannot possibly know if the authors of two different resources are aware of each other's modifications and have accounted for them!

In this case, if we run into actual problems in our hack after we have applied the two patches, we might consult `conflicts.txt`, see that the patches have a conflict and then try to comment out one or both of the patches in the `patches` list, to see if the issue still occurs. If it does not, we have located an actual conflict, otherwise, we may need to look elsewhere for the problem.

After you have confirmed that there is an actual conflict, further steps may be:
- reporting the conflict to the author(s) of the conflicting resource(s)
- working around the issue by using alternative resources
- attempting to fix the incompatibility yourself (if you know ASM)

That's pretty much it! Again, I want to stress that conflicts reported by Callisto are **not** guaranteed to actually be problematic, but do often warrant further investigation, as even if there is no immediate problem, it is often inherently suspicious for multiple resources to write to the same memory location as there is a good chance this is not intentional.

That's pretty much all there is to conflict detection. As we saw, while Callisto makes it simple enough to find potential conflicts, verifying that they are actually an issue and fixing them can still take considerable effort.

# Reducing the Number of Conflicts

As we saw at the start, I originally had two conflicts before applying the two patches. Here they are:

```
Conflict - 0x1 byte at SNES: $808179 (unheadered), PC: 0x000379 (headered):
	Original bytes:
		AD 
	AddMusicK:
		EA 
	UberASM:
		10 

Conflict - 0x3 bytes at SNES: $85D8B9 (unheadered), PC: 0x02DAB9 (headered):
	Original bytes:
		A5 0E 0A 
	PIXI:
		20 46 DC 
	UberASM:
		EA EA EA 
```

As we can see, these are tool <-> tool conflicts, one between AddMusicK and UberASM and one between PIXI and UberASM. As it turns out, I can get rid of the first one by just switching the insertion order of AddMusicK and UberASM in my `build_order`. This is because while AddMusicK ensures it doesn't overwrite what UberASM wrote at this location, the opposite is not the case.

This just leaves me with:

```
Conflict - 0x3 bytes at SNES: $85D8B9 (unheadered), PC: 0x02DAB9 (headered):
	Original bytes:
		A5 0E 0A 
	PIXI:
		20 46 DC 
	UberASM:
		EA EA EA 
```

This stems from the following lines in `pixi/asm/main.asm`:

```
; make it so the full level number can be read from $010B
; this part will not be removed on cleanup since other
; level based tools may also use this hijack
org $05D8B9|!BankB
    JSR Levelnum
org $05DC46|!BankB
    Levelnum:
    LDA $0E
    STA $010B|!Base2
    ASL A
    RTS
```

and the following lines in `uberasm_tool/asm/base/main.asm`:

```
ORG $05D8B7
    BRA +
    NOP #3        ;the levelnum patch goes here in many ROMs, just skip over it
+
    REP #$30
    LDA $0E        
    STA !level
    ASL        
    CLC        
    ADC $0E        
    TAY        
    LDA.w $E000,Y
    STA $65        
    LDA.w $E001,Y
    STA $66        
    LDA.w $E600,Y
    STA $68        
    LDA.w $E601,Y
    STA $69        
    BRA +
ORG $05D8E0
    +
```

we can see that UberASMTool replaces PIXI's `JSR Levelnum` with `NOP #3`, this matches what the conflict shows, since `EA EA EA` is `NOP #3`!

As UberASMTool is actually aware of what PIXI is doing and restores the same behavior, this is **not** a true conflict. To get rid of this, an easy way is to just remove PIXI's lines from the `pixi/asm/main.asm` file, though this does mean if I ever remove UberASMTool from my project, I may have to add those lines back later!

Either way, after I remove those lines from PIXI's file and rebuild, I get `No conflicts logged to C:/my_hack/conflicts.txt`, great!

While attempting to ensure that your project contains no conflicts might seem like a good idea, it is probably not sustainable given that there are plenty of intentional and non-problematic "conflicts" out there. I would generally recommend taking note when the number of conflicts in your project increases, but not necessarily to attempt to keep the number as low as possible at all times.

