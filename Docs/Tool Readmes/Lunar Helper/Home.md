**Note: This wiki is applicable for versions of Lunar Helper >= v4.0.0, for earlier versions consult the corresponding readmes/release notes**

# What is Lunar Helper?

Lunar Helper is a build system for Super Mario World ROMs originally created by [Maddy Thorson](https://github.com/MaddyThorson). This repository contains a heavily modified version of the tool, with various additional features, quality of life improvements and fixes.

This specific version of Lunar Helper also includes a tool called Lunar Monitor. Together, they offer a very streamlined workflow when combined with [git](https://git-scm.com/), which makes manual backups and Lunar Magic's restore system unnecessary and comes with various additional upsides. You do not **have** to use git with Lunar Helper and Lunar Monitor, but I personally highly recommend it and will try to make this wiki a decent entry point into using git for the first time if you're not familiar with it.

At its core, Lunar Helper is about ensuring that your ROM can be rebuilt even if it were to go missing or become damaged. It can also help with debugging resource conflicts and uncovering additional freespace in supposedly full ROMs. To accomplish this, Lunar Monitor plugs directly into Lunar Magic in order to export resources (levels, map16, overworlds, etc.) as you edit them. Lunar Helper can then use these extracted resources, as well as all your patches, sprites, blocks, etc. in order to rebuild your ROM.

# Where is the source code available?

The source code for this particular version of Lunar Helper, as well as Lunar Monitor and Lunar Monitor Loader is available at https://github.com/Underrout/LunarHelper.

The original version by Maddy Thorson is available at https://github.com/MaddyThorson/LunarHelper.

# What does this wiki contain?

This wiki will (eventually) contain
- a general overview of how to set up Lunar Helper and Lunar Monitor
- explanations for select features of Lunar Helper
- examples you can follow along with to learn about Lunar Helper and git

# What should I know before reading this?

It depends on what type of hack you are working on and your own ambitions. Lunar Helper can be used to build both completely vanilla as well as highly modified ROMs. 

What follows is a list of all major tools that Lunar Helper currently supports, as well as links to tutorials for each of them that you can consult in order to learn about them. Note that some of the advice given in these tutorials does **not** apply when using Lunar Helper and git, but they are still useful for learning how the tools work when you're starting out. 

Out of all of these, you only really **have** to be familiar with Lunar Magic and potentially FLIPS in order to get started using Lunar Helper, Lunar Monitor and git.

- [Lunar Magic](https://smwc.me/s/32211) - [Video series](https://www.youtube.com/watch?v=kbU33fXahH0&list=PLc_6IrpTVYqHvGZoUWreWkXFcdh26Xufd) (**required**)
- [FLIPS](https://smwc.me/s/11474) - [Tutorial](https://smwc.me/1399053) (**somewhat required**)
- [AddMusicK](https://smwc.me/s/24994) - [Tutorial](https://smwc.me/1398329) (optional, custom music insertion tool)
- [GPS](https://smwc.me/s/31515) - [Tutorial](https://smwc.me/1404234) (optional, custom block insertion tool)
- [PIXI](https://smwc.me/s/26026) - [Tutorial](https://smwc.me/1444600) (optional, custom sprite insertion tool)
- [UberASM Tool](https://smwc.me/s/28974) - No tutorial available at the moment (optional, custom per-level code insertion tool)
- [Asar](https://smwc.me/s/25953) - [Tutorial](https://smwc.me/1408014) (also covered in the video series linked above) (optional, generic code/data insertion tool)

# Where do I start?

Depending on whether you're setting up an entirely new project or a preexisting project, you should go to:

- [Lunar Helper setup (new project)](https://github.com/Underrout/LunarHelper/wiki/Setting-up-Lunar-Helper-(new-project))
- [Lunar Helper setup (preexisting project)](https://github.com/Underrout/LunarHelper/wiki/Setting-up-Lunar-Helper-(preexisting-project))
