**Note: This section assumes you have previously performed the steps in [Setting up Lunar Helper (new project)](Setting-up-Lunar-Helper-(new-project)) as well as the steps in [Setting up Lunar Monitor](Setting-up-Lunar-Monitor)**

# Building

If you've followed all the steps so far, you should now be fully ready to create a fresh output ROM using Lunar Helper which you can then edit!

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

Open `LunarHelper/LunarHelper.exe`, you should be greeted by a screen like this:

![LunarHelper_auVFuGQF6H](https://user-images.githubusercontent.com/8695490/209853506-e5836738-571c-41b0-81a5-f942ad630735.png)

Pressing `H` will explain each of the available functions, but for now we will focus only on the `B - (Re)Build` function. All (remaining) functions will later be explained in [Using Lunar Helper](Using-Lunar-Helper).

Go ahead and press `B` to start the build now!

![LunarHelper_KmywcMY6Q7](https://user-images.githubusercontent.com/8695490/200652903-aed1ec2e-0b84-4c7b-86a3-b4a0d64c1767.png)

If you've followed the instructions so far, you should see something similar to this. If you get any errors, ensure that your configuration variables are all correctly set up.

As you can see, Lunar Helper was about to insert our hack's graphics, but couldn't find them, since we haven't exported them yet!

Trying to import graphics without exporting them first would lead to an error, so Lunar Helper is offering to create a vanilla graphics folder for us by exporting them from the temporary ROM that has been patched with the `initial_patch.bps` file. Go ahead and press `Y` to make Lunar Helper do this:

![LunarHelper_JTYc8fWiM0](https://user-images.githubusercontent.com/8695490/200652926-feb5c368-457e-4d88-b1de-4420d4cbd3fd.png)

Go ahead and press `Y` for any remaining prompts like this that come up as well.

![LunarHelper_TDBA7mZjWd](https://user-images.githubusercontent.com/8695490/200652939-526f3f23-760f-44d9-b936-7470d91d6db3.png)

Once you see this, the build has succeeded and you have built your first ROM, congratulations!

(Note that all of the `Y` pressing was only necessary because this was our first build, you won't have to do it every time, I promise!)

# Finishing up

Feel free to move on to [Using Lunar Helper](Using-Lunar-Helper) now.