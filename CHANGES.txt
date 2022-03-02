#--------------------------------------#
# Changes and Additions to Vanilla     #
#--------------------------------------#

Version 4 of the Romhack Races BaseROM has made a few changes to the vanilla game via hex edits
as well as included several Quality of Life patches and bug fix patches for creating your levels.


GRAPHICS CHANGES & ADDITIONS

All of Mario's 8x8 tiles have been patched to use DMA upload, which freed up several tiles in GFX00.

The graphics for the noteblock and ON/OFF block bounce sprites have been remapped, as well as
the 8x8 tiles for Yoshi's tongue and throat, which means there will be no more broken graphics when using
these in levels.

Much of the graphics for Big Bush object (in GFX14) have been removed as well as some additional remapping 
on various vanilla objects to accommodate graphics for global line guides, custom blocks and extra animations.

A custom 8x8 font and symbol pack has been included in ExGraphics (ExGFXFF) for use as in-level text.

Coins of additional colours (green, red and pink) have been included via ExAnimation to be used for indication.

----------------------------------------

BLOCK ADDITIONS

A handful of commonly used custom blocks have been included in version 4:

- directional one-way blocks
- blocks that only Mario can pass through
- blocks that only sprites can pass through
- a block that silently kills any sprite, including held sprites (warning: this will lock the game if you're in P-balloon)
- ON/OFF blocks, a block that is solid when a switch is ON and not when switch OFF and vice versa
- a block that breaks when a thrown sprite hits it
- an instant death block, even when Mario is on Yoshi or has a powerup

A demonstration of each can be found in the 105 level in the BaseROM itself.

----------------------------------------


SPRITE CHANGES

The classic and upside down Piranha Plant has been restored via hex editing and can be 
used from the sprite menu as normal without ExGraphics.

The palette of the double hit shell has been changed so that it appears grey in game, this
will also affect the green parakoopa.

----------------------------------------


GAMEPLAY CHANGES

Some minor changes have been made to the game to optimize it for building Kaizo levels:

- Doors have been edited to have larger enterable region which makes them easier to enter.
- Mario-Sprite interaction has been patched to be every frame (colloquially known as the "Frame Rules" patch).
- Scrolling with the L/R buttons has been disabled.
- Midways do not give powerups.
- Spinning is guaranteed to flip your direction while Mario is cape-flying.
- the bridge will no longer break in the Reznor fight

----------------------------------------


FIXED BUGS & GLITCHES

A number of bugs and glitches have been patched out of the original game so they will not impact your levels:

- Yoshi stomp hitbox will no longer wrap the screen
- double hitting an ON/OFF switch is no longer possible
- horizontal pipes now make an exit sound
- beating a boss in sublevel 18 will no longer glitch Yoshi and stop Mario from walking past a goal tape
- you can no longer duplicate blocks glitch.
- double sprite bug, where spinjumping on two sprites at once can end up hurting you, is fixed.
- the game will no longer freeze when collecting a feather outside the screen during auto-scroll.
- entering pipes, bouncing of enemies, or hitting enemies with shells 256 times will no longer overflow the game.
- game will no long crash after eating a berry and collecting a Fire Flower at the same time.
- Mario will no longer remain in a climbing state when being pushed off a rope.
- the "Time Up!" message will no longer appear when you die in a level with no time limit.
- you can no longer duplicate a P-Switch with Yoshi by tonguing a pressed switch.
- clipping into noteblocks or any block in a wall (to get a jump off of it) has been patched out
- you can no longer go though blocks while using a P-balloon or Lakitu cloud, by holding the left and right buttons simultaneously.

----------------------------------------