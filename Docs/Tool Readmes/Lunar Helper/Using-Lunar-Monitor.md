If you've made it to this chapter, you might wonder what's up with Lunar Monitor. After all, we (seemingly) haven't used it at all yet. Well, that is because we have not yet actually edited our ROM in Lunar Magic at all, which is where Lunar Monitor actually comes into play!

# What does it do?

Lunar Monitor is a mostly invisible tool that essentially ensures that any of the resources we edit in Lunar Magic, such as levels, map16, palettes, the overworld, etc. are *automatically* exported to the locations Lunar Helper expects them to be at whenever we change them. This both ensures that the exported resources are up-to-date with the actual content of the ROM and also makes it so you don't generally have to worry about exporting anything manually.

# How do I run it?

The easiest option, if you've been following the previous chapters, is to just use Lunar Helper's `E - Edit` function. You can alternatively also open `LunarMonitorLoader.exe`, which will find the Lunar Magic executable with the highest version number in the same folder as it and inject it with a fitting version of Lunar Monitor from the `DLLs` folder that comes with it. Note that new Lunar Magic versions require an update to Lunar Monitor, so they may not be supported right away.

# Using it

Go ahead and use the `E - Edit` function from Lunar Helper to launch Lunar Magic. You should see this button: ![lunar_magic_mL0eImgjlg](https://user-images.githubusercontent.com/8695490/201227856-c82978a4-ab54-48be-ad54-2cce0ba4a8ca.png) in the toolbar as well as an extra panel in the bottom right corner of the main editor's status bar. 

Lunar Monitor will log any messages for you both to the `log_path` file as well as to this new status bar field. In addition, you will receive message boxes from Lunar Monitor if something goes wrong if you have `log_level` set to `Warn`.

Generally, you don't really have to "use" Lunar Monitor, you can just use Lunar Magic as usual and, provided your configuration is correct, resources should be exported automatically by Lunar Monitor whenever you save them to your ROM without any extra work on your part.

Lunar Monitor should also reload the ROM for you any time Lunar Helper builds the ROM while you have it open in Lunar Magic. This is useful because you will see any changes from the newly built ROM as soon as it's available. Note that this feature can be a little unreliable, so please make sure your ROM has actually been reloaded after each build.

The button Lunar Monitor adds to the toolbar can be used to export map16, shared palettes, global data and all modified levels for Lunar Helper. You shouldn't generally have to use it unless Lunar Monitor prompts you to do so, because it suspects there may be unexported changes in your ROM, which can happen if you forget to use Lunar Monitor and edit the ROM with an unmonitored Lunar Magic.

# Caveats

Please note that global ExAnimation does not have its own save function and Lunar Monitor can thus not export it when it is changed. If you change global ExAnimation, please save the overworld, titlescreen or credits afterwards in order to ensure global ExAnimation is exported.

Note that Lunar Monitor has historically been detected as malware by several antiviruses due to the way it alters Lunar Magic's code as it's running in order to add this additional functionality. This may be less prevalent in newer versions of Lunar Monitor, but please ensure that no antiviruses on your system are blocking Lunar Monitor, preventing it from doing its job.

# Moving on

Please ensure that Lunar Monitor is exporting resources correctly before moving on by checking for any warning message boxes or warnings in the log file.

Once you're convinced Lunar Monitor is working correctly, you are actually done with the main setup and usage instructions! 

This is more or less the end of basic Lunar Helper and Lunar Monitor information. For additional chapters on advanced Lunar Helper concepts as well as git usage, check the [Advanced topics](Advanced-topics) page in the sidebar if you are interested, happy hacking :)