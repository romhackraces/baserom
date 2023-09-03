# What is Callisto?

Super Mario World hacking has historically been quite a precarious activity with many projects dying at some point or another due to something breaking in an unexpected way. While keeping manual backups or using Lunar Magic's restore system can help, there are many shortcomings with both. Additionally, there are many complex tools and resources involved in projects and managing them manually is annoying and error-prone.

The main aim behind Callisto is to address these problems by allowing you to rebuild your hack automatically from scratch in a reproducible way while also enabling compatibility with [git](https://git-scm.com/), which is a vastly superior alternative to both manual backups as well as Lunar Magic's restore system.

The main observations behind Callisto and combining it with git are
1. Hacking should be **safe**
2. Hacking should be **simple**

By "safe" I mean that you should never have to worry about losing, corrupting or otherwise destroying your work, even if your entire house including your computer burned down. By "simple" I mean that there should be no need to worry about how any particular tool is applied to your ROM more than once.

To accomplish this, Callisto lets you (quickly!) extract all relevant resources from inside your ROM (levels, map16, overworld, title screen, etc.) and later rebuild your ROM from these extracted resources, while also automatically applying all necessary tools and patches according to your particular needs. While some more experienced hackers may have used scripts or Makefiles in the past, Callisto offers additional benefits that more generic alternatives usually lack.

Callisto is very similar to [Lunar Helper](https://github.com/Underrout/LunarHelper), which is an earlier tool that performed very similar steps. Compared to Lunar Helper, Callisto comes with several new features as well as improvements to old features, while also being more future-proof.


# What does this Wiki contain?

This wiki contains
- setup instructions for Callisto
- general usage instructions for Callisto
- additional details for advanced Callisto features
- a small introduction to hacking with Callisto + git and additional resources for learning git more in-depth


# What should I know before reading this?

It depends on what type of hack you are working on and your own ambitions. Callisto can be used to build both completely vanilla as well as highly modified hacks. 

What follows is a list of all major tools that Callisto currently supports, as well as links to tutorials for each of them that you can consult in order to learn about them. Note that some of the advice given in these tutorials does **not** apply when using Callisto and git, but they are still useful for learning how the tools work when you're starting out. 

Out of all of these, you only really **have** to be familiar with Lunar Magic and potentially FLIPS in order to get started using Callisto and git.

- [Lunar Magic](https://smwc.me/s/32211) - [Video series](https://www.youtube.com/watch?v=kbU33fXahH0&list=PLc_6IrpTVYqHvGZoUWreWkXFcdh26Xufd) (**required**)
- [FLIPS](https://smwc.me/s/11474) - [Tutorial](https://smwc.me/1399053) (**somewhat required**)
- [AddMusicK](https://smwc.me/s/24994) - [Tutorial](https://smwc.me/1398329) (optional, custom music insertion tool)
- [GPS](https://smwc.me/s/31515) - [Tutorial](https://smwc.me/1404234) (optional, custom block insertion tool)
- [PIXI](https://smwc.me/s/26026) - [Tutorial](https://smwc.me/1444600) (optional, custom sprite insertion tool)
- [UberASMTool](https://smwc.me/s/28974) - No tutorial available at the moment (optional, custom per-level code insertion tool)
- [Asar](https://smwc.me/s/25953) - [Tutorial](https://smwc.me/1408014) (also covered in the video series linked above) (optional, generic code/data insertion tool)


# Where do I start?

Depending on whether you're setting up an entirely new project or a preexisting project, you should go to:

- [Callisto Setup (new project)](Callisto-Setup-(new-project))
- [Callisto Setup (preexisting project)](Callisto-Setup-(preexisting-project))

# Where can I get help?

I set up a sparsely populated [Discord server](https://discord.gg/SbRM8mUjdE) for support, feel free to stop by if you need help or have any questions!


***

For used libraries and their licenses check [Miscellaneous Licenses](Miscellaneous-Licenses).