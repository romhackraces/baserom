When we were setting up Callisto, we sort of glossed over `tools.toml`. But there's a lot going on in there!

Let me explain in a little bit more detail now.

# Tool Requirements

Outside of Lunar Magic and FLIPS, Callisto makes no special assumptions about the tools it's working with. That means, you won't find any references to "PIXI", "GPS" or similar tools inside Callisto's source code. This also means that any weird tools or scripts you make, as well as old and future tools, can work with Callisto as long as they follow two simple rules:

- return a non-zero exit code on failure and 0 on success
- output the (absolute or relative to your tool) paths of the files your program depends on line-by-line in a text file after your tool runs

The first rule ensures that Callisto can tell when your program runs into an error, which should obviously stop the build process.

The second rule ensures that Callisto's `Update` can figure out when your tool needs to be re-applied. In particular, Callisto will check for each file your program listed as a dependency in its output file whether the file has changed since your tool was last applied to the ROM. If any files *have* changed, your tool will be re-applied, otherwise, `Update` will know that re-applying your tool is not necessary.

That's all your tool needs to do to work well with Callisto.

# Tool Configuration

Now, that's just the requirements. Configuring your tool to work with Callisto is also necessary. This is what the `tools.toml` file that comes with Callisto does. Let's take a look at it now.

Here is part of a configuration for PIXI (comments removed for brevity):

```toml

[tools.generic.PIXI]

directory = "tools/pixi"

executable = "pixi.exe"

options = "-l ../../tools/pixi/list.txt"

# pass_rom = false

static_dependencies = [
    { path = "pixi.exe", policy = "rebuild" },
    { path = "list.txt" }, 
    { path = "asar.dll", policy = "rebuild" }, 
    { path = "NewtonSoft.Json.dll", policy = "rebuild" } ,
    { path = "routines", policy = "reinsert" },
    { path = "sprites", policy = "reinsert" }
]

dependency_report_file = ".dependencies"
```

You can probably already guess what most of this means, but let's go through it step by step.

## Configuration Header

```toml
[tools.generic.PIXI]
```

This line starts the configuration for `PIXI`. Note that the part at the end (`PIXI`) can be freely chosen to be whatever name you wish (as long as it is allowed by [TOML's syntax for keys](https://toml.io/en/v1.0.0#keys)). That part of the header is *also* the name that you will use to refer to it in the `build_order`, so now you know where the `"PIXI"` in the build order actually comes from. Unlike `Graphics`, `Overworld` and the like, `"PIXI"` is not some magic string, it's exactly the name we gave it in the `tools.toml` file and we could have chosen a different one if we wanted!

You always must start a tool's configuration with a header.

## Directory

```toml
directory = "tools/pixi"
```

This is pretty self-explanatory. This is just the directory the tool is in. It's relative to the project root, so if my project root is `my_hack`, this means my PIXI folder is at `my_hack/tools/pixi`. Note that any other paths inside this tool's configuration will be relative to this path, which makes configuration a little less verbose than if it were relative to the project root.

## Executable

```toml
executable = "pixi.exe"
```

This is just the executable file of the tool. Note that this doesn't need to be an EXE necessarily, a BAT or anything else executable should also work just fine. Note again that this is relative to the `directory`, i.e. `tools/pixi` in this example. So the full path to `pixi.exe` in our project is `my_hack/tools/pixi/pixi.exe`.

## Options Flags

```toml
options = "-l ../../tools/pixi/list.txt"
```

This setting lets you specify any additional options to be passed to the tool. In this case, we are passing an option to PIXI to let it know where the sprite list is relative to the temporary ROM which it is being applied to, since PIXI usually expects the list file to be in the same folder as the ROM rather than itself. To learn which options you can pass to a tool, consult its readme file or other documentation. 

If this is omitted, no options are passed.

## Passing the ROM

```toml
# pass_rom = false
```

As you can see, this line is commented out. This is because PIXI expects to be passed the ROM it is inserting into as an argument on the command line. When this setting is omitted or set to `true`, the path to the temporary ROM will automatically be passed by Callisto as the final argument during the build process. If this is set to `false`, the ROM will not be passed, which can be useful for some tools/scripts that don't directly work on the ROM but only produce files for other tools to use in their own building process.

| :exclamation:  If a tool has `pass_rom = false` set, it **should never** edit the temporary ROM during the build|
|-----------------------------------------|

## Static Dependencies

```toml
static_dependencies = [
    { path = "pixi.exe", policy = "rebuild" },
    { path = "list.txt" }, 
    { path = "asar.dll", policy = "rebuild" }, 
    { path = "NewtonSoft.Json.dll", policy = "rebuild" } ,
    { path = "routines", policy = "reinsert" },
    { path = "sprites", policy = "reinsert" }
]
```

Now, this is probably the most complicated part of setting up a tool. There are generally some files that a tool depends on no matter what, like its own executable or some static libraries it's using. These are listed here, alongside files and resources that are "hard" to track for some reason or another (I will talk more about this in a few paragraphs). 

Each entry in this list is an object containing a `path` to a file or folder as well as, optionally, a `policy` that can be either `rebuild` or `reinsert`. If the `policy` is omitted, it is implicitly `reinsert`.

When the `path` is a file, we are saying "the tool in some way works with this file". When the `path` is a folder, we are saying "the tool in some way works with this folder and all files in it".

During `Update`, if any file or folder (or any files in a folder) listed in the `static_dependencies` has been written to since the last time the `output_rom` was built, the `policy` of that entry will be triggered. If the policy is `reinsert`, the tool will just be re-inserted. If the policy is `rebuild`, the entire ROM will be rebuilt from scratch. Whether it makes more sense to use `reinsert` or `rebuild` for any particular folder or file depends on how severe of an effect you think a change to that file or folder will have on the build process overall. This is a judgment call on your part.

Now, a brief word on the last two entries in this list:

```toml
static_dependencies = [
    # ...
    { path = "routines", policy = "reinsert" },
    { path = "sprites", policy = "reinsert" }
]
```

As you may know, Callisto uses a customized asar version, which helps us automatically track dependencies on anything inserted by asar (more on this in the next section!). Unfortunately, that does mean that for anything else that tools depend on, we *don't* have automatic tracking. In PIXI's case, this affects `routines`, which are implicitly made available to sprites as well as `.cfg/.json` files, which are handled by PIXI internally.

Whenever we can't easily and automatically track a set of dependencies, either by the tool playing nice and making itself compatible with Callisto by outputting its dependencies in a file or by tricking it into doing so via our customized asar version, we have to resort to static dependencies. Which is what I'm doing with these last two lines. Basically, any changes to the `my_hack/tools/pixi/routines` and `my_hack/tools/pixi/sprites` folders will trigger a reinsertion of PIXI during `Update`. This is not as precise as we would like, after all, we can just drop a `.cfg/.json` into the `sprites` folder without using it anywhere, which wouldn't make a reinsertion meaningful, but it is the best we have for now.

It is important to set up `static_dependencies` adequately, or important changes could slip by `Update` and cause inaccurate results!

## The Dependencies File

```toml
dependency_report_file = ".dependencies"
```

As alluded to earlier, tools should output their dependencies in a file so Callisto can track which files it depends on. This is where we specify the path to this file. The file can be named anything you want, the `.dependencies` name is just a convention, making it easy to ignore them in a `.gitignore` file if needed.

That's all for tool configuration and compatibility!