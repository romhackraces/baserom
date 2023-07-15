Now that you've successfully built your ROM, let's talk a bit about using Lunar Helper in general.

While you have Lunar Helper open, press `H` to see a list of the available functions, with a short explanation of each of them:

![LunarHelper_B3W45zWBzi](https://user-images.githubusercontent.com/8695490/209853858-7c0689da-fd5c-441c-838d-9b9c736df676.png)

I'll go into a little more detail on each of them, with some relatively important notes along the way!

# Functions

## `B - (Re)Build`

We've already seen this in the last chapter. Essentially, all it does is take a clean ROM, insert all resources configured and specified in `build_order` one after the other, check for errors and if there are none, output the final ROM. The state your ROM is in immediately after a build should be functionally the same whenever you build without making any other changes. This is a highly useful property, since it means you can never really "screw up" your ROM, since it can always be rebuilt as it was before any potential catastrophe, as long as the rest of your project remains the same.

## `Q - Quick Build`

Quick Build is very similar to Build, except it doesn't immediately start from a clean ROM, but first tries to reuse the current `output` ROM, if one exists. This can be a lot faster if it turns out that all that is needed to bring your ROM up to date are a few insertions rather than a full rebuild.

Quick Build is pretty smart and can generally figure out quite well which parts of your hack need re-insertion, though it is not entirely impossible that sometimes the ROM output by Quick Build will contain bugs that wouldn't be present with a full rebuild. This is why it is generally a good idea to do a full rebuild when you've been Quick Building and run into a problem, to verify that it is an actual bug and was not just a result of some sort of unfortunate resource conflict that resulted from Quick Build's more flexible insertion style.

## `R - Run`

This function can be used to run the `output` ROM in an emulator. You might have noticed that we did not cover setting up an emulator in any of the previous chapters. This is because it should generally not be necessary, as long as you have an emulator set up to run in Lunar Magic, via the F4 key, because Lunar Helper can figure out how to launch the Lunar Magic emulator and just use it instead of making you specify additional configuration variables.

Should you prefer to use a different emulator than your Lunar Magic emulator, please see [Customizing the emulator](Customizing-the-emulator) for the specific configuration variables that can be used for emulator setup.

## `T - Test`

This is relatively self-explanatory, it's literally just a Quick Build followed immediately by the `R - Run` function. Can be useful for quick testing.

This function also has a secondary use, allowing you to insert a specific "test level" only when this specific function is run, that will not be inserted with the `Build`, `Quick Build` or `Package` functions, which can be useful if you want a test level but don't want it to appear in your actual released hack. For more on this, see [Inserting a test level](Inserting-a-test-level).

## `E - Edit`

This function will actually launch Lunar Magic and immediately open your `output` ROM. This is the preferred way of opening your ROM in Lunar Magic, since Lunar Helper will ensure that Lunar Monitor is running inside Lunar Magic when this function is used. 

If you prefer opening Lunar Magic yourself, please ensure you are either opening it via double clicking on `LunarMonitorLoader.exe` or by using a Lunar Magic executable in the same folder as it, otherwise Lunar Monitor may not be injected, which could cause issues down the road.

## `P - Package`

This will first do a full rebuild of your hack and then create a BPS patch of the `output` ROM at the `package` path. Very useful for publishing your hack with ease.

## `O - Open project in File Explorer`

This will just pop up your configured `dir` folder, which is usually the root of your project folder, in the file explorer. Useful if you quickly need to access a file or move stuff around.

# Moving on

Now that you have a bit of an understanding of Lunar Helper, feel free to move on to [Using Lunar Monitor](Using-Lunar-Monitor).
