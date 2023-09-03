If you've used Lunar Helper and are familiar with its "globules", you already know what modules are, they simply got a rename for Callisto!

If not, think of modules as something similar to UberASMTool library files or PIXI/GPS routines, but more general.

Modules are re-usable pieces of code or data than can be used by **any** tool or resource. They are inserted directly by Callisto and then made available to other resources through a simple interface. They are very similar to patches, except they may not contain any hijacks, as their intended use is to be sort of "freely floating" inside your ROM, being referred to as needed. 

You may have seen examples of patches which ask you to insert them first, then take note of an address that is printed in the console to actually call the code contained within the patch. This is an annoying and error prone process that modules can replace in an elegant way.

In addition, a header file can be specified for modules, which can be useful to always include SA-1 defines and similar stuff.

# Configuring Modules

Opening up `modules.toml`, we will see something like:

```toml
[resources]
module_header = "path/to/my/header.asm"

modules = [
    # { input_path = "resources/modules/binary/uncompressed_exgfx.bin" },
    # { input_path = "resources/modules/code/teleport.asm" },

    # { input_path = "resources/modules/binary/large_table.asm", output_paths = [ "binaries/my_large_table.asm", "other/random/place.asm" ] },
    # { input_path = "resources/modules/code/reset.asm", output_paths = [ "code/reset.asm", "code/also/accessible/here.asm"] }
]
```

The `module_header` file will be `incsrc`'d into any module that has a `.asm` extension.

The actual `modules` list works somewhat similarly to the `patches` list you should already be familiar with, except it's slightly more complex.

Each entry in the list looks like this:

```
{ input_path = "path/to/the/module.asm", output_paths = [ "some/output/path1.asm", "some/output/path2.asm" ] }
```

The input path is pretty self-explanatory, it's just the path to the file you want to insert as a module.

The `output_paths` are actually a list of paths. You can specify as many as you want. If you omit output paths and just have something like this:

```
{ input_path = "path/to/the/module.asm" }
```

this is equivalent to writing

```
{ input_path = "path/to/the/module.asm", output_paths = [ "module.asm" ] }
```

Now, what does `output_paths` actually mean?

What Callisto will do for each module is:
- insert the module into the ROM
- for each path in the module's `output_paths` list, emit one file at that output path containing the address of each label that was in the inserted module

Unlike all other paths in Callisto, the `output_paths` are relative to the `.callisto/modules` folder, which is created by Callisto in your `project_root` before every `Rebuild` or `Update`. In the example from above with:

```
{ input_path = "path/to/the/module.asm", output_paths = [ "some/output/path1.asm", "some/output/path2.asm" ] }
```

Callisto would first insert `my_hack/path/to/the/module.asm`, then output files containing the addresses of the inserted labels in `my_hack/path/to/the/module.asm` at `my_hack/.callisto/modules/some/output/path1.asm` and `my_hack/.callisto/modules/some/output/path2.asm`.

# Including and Calling Modules

Any labels in the module will be prefixed with the name of the output file, so if we have a `main` label in `module.asm` and output it as `code/my_module.asm`, the label name will be `my_module_main`. Any label names are also available as defines, so `!my_module_main` will work just as well.

To make including and calling modules easier, Callisto offers macros for these tasks. In patches, you can simply write `incsrc "callisto.asm"` to include the `call_module(module_label)` and `include_module(module_name)` macros. For example, to include and call the `my_module_main` label from above, in a patch I could just write:

```
incsrc "callisto.asm"

%include_module("code/my_module.asm")  ; Our `output_path` was "code/my_module.asm",
                                       ; so that is also what we use here!

; ...

main:
    %call_module(my_module_main)  ; `%call_module(my_module_main)` is essentially  
                                  ; `JSL my_module_main`, except it also sets the 
                                  ; data bank register for you
    RTL
```

This same exact technique can also be used to include and access modules from other modules.

Sadly, for blocks, sprites, etc. which Callisto does **not** insert itself, you will have to jump through some hoops to include the `callisto.asm` file. 

For example, if your block is at `my_hack/tools/gps/blocks/my_block.asm`, you will need to include the `callisto.asm` file like this:

```
incsrc "../../../.callisto/callisto.asm"
```

So you will need to specify the path relative to the current file that is being inserted. The rest of the process (using `%include_module` and `%call_module`) remains the same, however.

# Writing Modules

Let's now write a silly little module to showcase how to create them.

Let's say I want some code that will check the player's coin count and kill them if it is exactly at decimal 10. 

First, let's make a small header file so we can use SA-1 defines:

```
if read1($00FFD5) == $23
	if read1($00FFD7) == $0D ; full 6/8 mb sa-1 rom
		fullsa1rom
		!fullsa1 = 1
	else
		!fullsa1 = 0
		sa1rom
	endif
	!sa1 = 1
	!SA1 = 1
	!SA_1 = 1
	!Base1 = $3000
	!Base2 = $6000
	!dp = $3000
	!addr = $6000
	
	!BankA = $400000
	!BankB = $000000
	!bank = $000000
	
	!Bank8 = $00
	!bank8 = $00
	
	!SprSize = $16
else
	lorom
	!sa1 = 0
	!SA1 = 0
	!SA_1 = 0
	!Base1 = $0000
	!Base2 = $0000
	!dp = $0000
	!addr = $0000

	!BankA = $7E0000
	!BankB = $800000
	!bank = $800000
	
	!Bank8 = $80
	!bank8 = $80
	
	!SprSize = $0C
endif
```

Let's save this at `resources/shared_code/sa1def.asm` and set it as our module header in `modules.toml`:

```toml
[resources]

module_header = "resources/shared_code/sa1def.asm"
```

Now, let's create an empty file for our actual globule at `resources/modules/death_on_coins.asm` and tell Callisto to insert it and output the result at `my_code/death.asm` in the `.callisto/modules` folder via our `modules.toml` file:

```toml
[resources]

module_header = "resources/shared_code/sa1def.asm"

modules = [
    # Insert `my_hack/resources/modules/death_on_coins.asm` and 
    # output the result at `my_hack/.callisto/modules/my_code/death.asm`

    { input_path = "resources/modules/death_on_coins.asm", output_paths = [ "my_code/death.asm" ] }
]
```

In our actual module file at `my_hack/resources/modules/death_on_coins.asm`, we might write the following:

```
freecode

check:
    LDA $0DBF|!addr
    CMP #10
    BNE .skip

    JSL $00F606

.skip
    RTL
```

This very simple code just checks if the player's coin count (`$0DBF|!addr`) is at exactly decimal 10 (`#10`). If not, we just return, otherwise, we call the death subroutine (`JSL $00F606`).

Important parts:
- Note the `freecode` at the top, if you forget it, Callisto will yell at you!
- You can also use `freedata` instead of `freecode` if you don't need RAM mirrors, as well as `prot` and other freespace commands you may need
- Modules must return with `RTL` (or ensure they return "as if" they had used an `RTL`)
- Modules must contain at least one label in each freespace area, otherwise Callisto will yell at you!
- Modules may not edit ROM areas below PC offset 0x800000 (aka the vanilla ROM area), since they are meant to be non-hijacking

That's pretty much it for code modules. We could now include and call this module in a patch like this:

```
incsrc "callisto.asm"

%include_module("my_code/death.asm")

; ... 

main:
    %call_module(death_check)
    RTL
```

# Binary Modules

As stated earlier, any module that does not end in `.asm` will be inserted as data. For example, if we had a `ExGFX800.bin` file in our `resources/modules` folder and wanted to insert it, we could just add 

```
{ input_path = "resources/modules/ExGFX800.bin" }
```

to our `modules` list and then include it in a patch with:

```
incsrc "callisto.asm"

%include_module("ExGFX800.asm")  ; note the ".asm" here, output files are 
                                 ; always ".asm" files since they contain labels

; ...

; Accessing the module's data
LDA.l ExGFX800,x  ; Note the .l, you can alternatively set the 
                  ; data bank register yourself and use .w addressing
```

When binary modules are inserted, they only generate a single label, which will be identical to the file name of the corresponding output path. In our case, that's just `ExGFX800`.

# Moving on

That's pretty much all there is to know about modules! As we saw, they are an extremely versatile part of Callisto and offer several advantages over existing mechanisms for "general" code or data insertion. I hope you will find them useful!




