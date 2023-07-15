The two initial patches that are available in the `initial_patches` folder that comes with Lunar Helper should be sufficient for most common project scenarios. Both are expanded to 4MB, their compression is set to "optimized for speed" and all important Lunar Magic hijacks should be inserted. 

If you do need a different setup, here are the steps I used to create these two patches, which you can follow and adjust to create your own initial patch:

- Grab a clean ROM
- Open the ROM
- Expand the ROM to 2 MB
- Apply FastROM or SA-1 (if you want to use them)
- Change the compression options to whatever you prefer
- Reapply SA-1 if you applied in step 3
- Expand the ROM to 4 MB
- Save a level
- Extract GFX and ExGFX
- Import GFX and ExGFX
- Create an ExAnimation, save the level, delete the ExAnimation and save the level 
  again (so Lunar Magic installs ExAnimation hijacks)
- Enable a custom palette in a level, change the background color and any other 
  color in the palette, save the level, disable the custom palette and save the 
  level again (for palette hijacks)
- Open the overworld editor
- Edit a path (for the hijacks)
- Edit a level tile (for the hijacks)
- Edit a level name (for the hijacks)
- Edit a message box (for the hijacks)
- Edit the normal layer (for the hijacks)
- Save the overworld (for the hijacks)
- Revert your changes and save again (if you want to have the vanilla overworld 
  back exactly as it was)
- Switch back to the level editor, press Shift+F8 and apply the fix (if you want 
  to have it)

After you're done, just create a BPS patch from the resulting ROM and use it as your `initial_patch.bps`.