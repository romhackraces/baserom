**Note: This section assumes you have previously performed the steps in [Setting up Lunar Helper (preexisting project)](Setting-up-Lunar-Helper-(preexisting-project)) as well as the steps in [Setting up Lunar Monitor](Setting-up-Lunar-Monitor)**

# Building

If you've followed all the steps so far, you should now be fully ready to export resources from your preexisting ROM and rebuild it from scratch with Lunar Helper!

**BIG NOTE: Please keep a backup of your project folder and ROM around before trying this, for various reasons, the process of getting your hack to rebuild correctly when first moving to this workflow can be tough to get right and unearth previously unknown issues!**

Navigate to your `LunarHelper` folder, in the ongoing example, this would be `MyHack/LunarHelper`. As a reminder, this is what the project looks like in this example (your project's structure can look slightly different, just make sure your configuration is accurate):

```
MyHack/
├── LunarHelper/
│   ├── LunarHelper.exe
│   ├── config_project.txt
│   ├── config_user.txt
│   └── asar.dll
├── Other/
├── Tools/
├── Levels/
└── Build/
```

Make sure that your preexisting ROM is placed at the `output` path you specified in `config_user.txt`. In my case, this is `Build/MyFunHack.smc`. **As a reminder, please create a backup of your preexisting project, including your ROM!**

Open `LunarHelper/LunarHelper.exe`, you should be greeted by a screen like this:

![LunarHelper_auVFuGQF6H](https://user-images.githubusercontent.com/8695490/209853506-e5836738-571c-41b0-81a5-f942ad630735.png)

Pressing `H` will explain each of the available functions, but for now we will focus only on the `B - (Re)Build` function. All (remaining) functions will later be explained in [Using Lunar Helper](Using-Lunar-Helper).

Go ahead and press `B` to start the build now!

![LunarHelper_MMLZjN0bKq](https://user-images.githubusercontent.com/8695490/201200572-f6b1bc3d-630b-4851-9323-728720f0ccb7.png)

If you've followed the instructions so far, you should see something similar to this. Don't be alarmed, this is perfectly normal in this case!
Lunar Helper checks whether any ROM it is about to overwrite by building might have unexported resources in it and will refuse to build until those resources are extracted. Please note that this only extends to levels, shared palettes, overworlds, titlescreens, map16 and any other resources **managed by Lunar Magic**! Lunar Helper cannot detect or export blocks, sprites, patches or other resources inserted by external tools, so make sure you keep these on hand!

If you read through the above warning, you will see that Lunar Helper is offering to export these resources from our preexisting ROM. Press `Y` in order to make it do that now.

You should see Lunar Helper exporting a bunch of resources from your hack and then `Starting build`, at which point Lunar Helper will be rebuilding your hack from scratch, using the resources it just exported. 

![LunarHelper_TDBA7mZjWd](https://user-images.githubusercontent.com/8695490/200652939-526f3f23-760f-44d9-b936-7470d91d6db3.png)

Once you see this, the build has succeeded and you have rebuilt your preexisting ROM using Lunar Helper!

If you're seeing any error messages instead, ensure your configuration is set up correctly and address any errors Lunar Helper is showing you, then try to build by using `B` again until it succeeds.

# Problems

It is common to experience issues at this point, especially when moving projects that use a lot of heavy-duty patches or unusual resources.

Don't panic if your newly built ROM crashes immediately. 

First of all, you (should) have a backup, so if worse comes to worst, you can always restore your backup if necessary. 

Secondly, crashes can actually be a good thing, believe it or not. Usually, what crashes indicate is that there is a conflict between some of the resources in your hack that may have previously gone unnoticed. If you've ever had your hack crash for "no reason" after applying a patch, you might actually have run into a patch conflict in the wild without realizing. 

What's nice about Lunar Helper here is that we can just remove patches from the `patches` list, rebuild our ROM and then check if the crash is gone. If so, we know that at least one of the patches we removed was part of a conflict. This way, we can more easily pinpoint the specific patch(es) or other resources that are conflicting and potentially report this behavior to the patch authors or otherwise look into getting it fixed (playing around with the build order and inserting the conflicting patches in a different order can sometimes help).

Note that some patches may also just have specific requirements that aren't being met, for example [this patch](https://smwc.me/s/28028) requires re-insertion if you're "upgrading" to Lunar Magic 3.31 which can actually happen mid-build because the initial patches were all created with Lunar Magic 3.30, but you may actually be using a newer Lunar Magic version outside of that, which could cause issues (again, see [Creating your own initial patch](Creating-your-own-initial-patch) for details on how to create your own initial patch). Likewise, other patches may also have obscure requirements, always refer to the patch's readme and consider all other options before concluding that it's a patch conflict.

# Finishing up

Once you have made sure that your hack is working as intended (i.e. it looks and functions the same as it did before switching to this workflow), feel free to move on to [Using Lunar Helper](Using-Lunar-Helper).