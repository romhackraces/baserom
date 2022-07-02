# human-readable-map16-cli

A command line wrapper around the [human-readable-map16 library](https://github.com/Underrout/human-readable-map16), allowing you to convert Lunar Magic's map16 files 
to a directory of text files and from that directory of text files back to the map16 format from the command line.

The library and this executable were tested with map16 files exported by Lunar Magic 3.31, but should work fine for older versions as long as they're not old 
enough to not use the map16 format, of course.

Using this tool with [Lunar Monitor](https://github.com/Underrout/lunar-monitor) and [Lunar Helper](https://github.com/Underrout/LunarHelper) is highly recommended, 
as these tools can automatically convert from map16 to text and back as needed, meaning you should rarely (if ever) need to run this tool yourself.

# Purpose

Lunar Magic's map16 format is binary and hardly editable or readable by humans. It is also very inconvenient to work with using git, which is a shame. I also 
discovered that the full-game-export map16 files contain redundant data and an as of yet unfixed bug that can potentially manifest upon re-importing the map16 file.
This program solves all of these issues by transforming the binary file into a directory structure containing a bunch of files, which in total contain 
all information from the map16 file, but without redundancy and in a readable and easily editable text format. (It also fixes the afforementioned bug, but the bug 
is relatively obscure and probably affected very few, if any, projects.)

Of course, this would be useless if you could not convert the text files back to the binary format, which of course this tool also allows you to do.

Git actually works fantastically with this new text format. With the binary map16 format, merging any two branches that contained *any* map16 changes would lead to 
a merge conflict. With this new format, merge conflicts should only *ever* happen if the *exact* same tile is changed in two different commits. Even then, resolving 
the merge conflict is much easier, since only two lines will conflict, instead of two entire binary files!

# Known limitations

Currently you can only convert full-game-export map16 files (AllMap16.map16) using this program, as the library does not yet support converting 
partial map16 exports (but may in the future).

# Usage

## map16 -> text

`human-readable-map16-cli.exe --from-map16 "C:\my_hack\resources\AllMap16.map16" "C:\my_hack\resources\map16"`

Converts the map16 file `C:\my_hack\resources\AllMap16.map16` to a directory of text files at `C:\my_hack\resources\map16`.

## text -> map16

`human-readable-map16-cli.exe --to-map16 "C:\my_hack\resources\map16" "C:\my_hack\resources\AllMap16.map16"`

Converts the directory of text files at `C:\my_hack\resources\map16` to a map16 file at `C:\my_hack\resources\AllMap16.map16`.

## Drag and drop

You can drag and drop a map16 file onto the executable, it will then convert it to a directory of text files with the same name as the map16 file in the same location.

The same works for dragging and dropping the directories of text files created this way, this will then re-create the original map16 file.

## Interactive mode

`human-readable-map16-cli.exe`

Launching the exectuable without arguments will start interactive mode, you will be prompted for whether you want to convert to/from map16 and where files should 
be taken from/output to.

# Output format

Note that the output format is not immediately important for you unless you want to edit the output text files by hand, so I would only recommend reading 
this part if you have to do that or if you're curious.

## Directory structure
The output directory will have the following structure:

```
- global_pages
  - BG_pages
    - page_80.txt
    - page_81.txt
    - ...
  - FG_pages
    - page_00.txt
    - page_01.txt
    - ...
    
- pipe_tiles
  - pipe_0.txt
  - pipe_1.txt
  - ...
  
- tileset_group_specific_tiles
  - tileset_group_0.txt
  - tileset_group_1.txt
  - ...
  
- tileset_specific_tiles (optional, see explanation below)
  - tileset_0.txt
  - tileset_1.txt
  - ...
  
- header.txt
```

The two subdirectories of the `global_pages` directory together contain all 0x100 pages you can see in the Lunar Magic map16 editor. The `FG_pages` directory contains 
the first 0x80 of these pages, which are for foreground tiles. The `BG_pages` directory contains the remaining pages from 0x80-0xFF, which are pages for background
tiles.

The `pipe_tiles` directory contains four files, one for each of the four pipe colors in Super Mario World. Lunar Magic lets you edit different pipe color tiles 
independently of each other, which is why these tiles are handled separately. You can switch pipe colors in Lunar Magic's map16 editor by pressing the blue pipe 
button in its toolbar.

The `tileset_group_specific_tiles` directory contains five files, one for each "tileset group" in Super Mario World. As you may know, certain map16 tiles on the 
first two pages may have different 8x8 tiles, palettes, priority, etc. between different tilesets. Usually, we call these tiles "tileset specific", but I prefer 
calling them "tileset group specific", because there are only actually five such "tileset groups" that have different tile specifications. The remaining 10 tilesets 
all have the same "tileset group specific" tiles as the other tilesets in their group. This means that saving the tileset group specific tiles for one group of 
tilesets is good enough to store the tileset specific tiles for all tilesets, which is why we only save 5 files in this directory.

The `tileset_specific_tiles` directory is optional, as it is tied to a little known Lunar Magic setting that allows you to make map16 page 2 tileset specific. In 
this case, tileset specific means actually tileset specific. Meaning that, with this setting active, there are 15 different versions of page 2 to store. One for each 
tileset. If this setting is enabled, this directory contains 15 files, each containing a full copy of the corresponding tileset's page 2.

`header.txt` contains a small bit of information from the map16 file's header section. The presence of a file with this name indicates to this program that the 
folder it is contained in is in fact a directory it created.

## File format

The file format, like the directory structure, is only really relevant for you if you have to edit these files by hand or are curious.

### Header file

The `header.txt` file will look something like this:

```file_format_version_number: 100
game_id: 1
program_version: 331
program_id: 1
size_x: 10
size_y: 1000
base_x: 0
base_y: 0
is_full_game_export: 1
has_tileset_specific_page_2: 1
comment_field: "Lunar Magic 3.31  ©2021 FuSoYa  Defender of Relm"
```

Generally, there should be no reason to edit this file by hand and most values are not very important/interesting. If you are still curious about them you can read 
[this](https://smwc.me/1139931) and [this](https://smwc.me/1598391) forum post by FuSoYa or consult the map16 file format section of Lunar Magic's help file.

### Text files

All remaining files in the whole directory contain (mostly) the same kind of data. All non-blank lines in the various files (`page_00.txt`, `tileset_group_0.txt`, 
`pipe_tiles_0.txt`, etc.) specify one map16 tile and have this general format:

`TTTT: AAA { EEE C XYP  EEE C XYP  EEE C XYP  EEE C XYP }`

Part of format | Explanation                   | Valid values
---------------|-------------------------------|------------------
TTTT           | Map16 tile number             | 0x0000-0xFFFF
AAA            | Acts like settings            | 0x000-0x1FF
EEE            | 8x8 tile number               | 0x000-0x3FF
C              | Palette number of 8x8 tile    | 0-7
X              | X flip setting of 8x8 tile    | 'x' (x flip on) or '-' (x flip off)
Y              | Y flip setting of 8x8 tile    | 'y' (y flip on) or '-' (y flip off)
P              | Priority setting of 8x8 tile  | 'p' (priority on) or '-' (priority off)

The order of the four 8x8 tiles is top left, bottom left, top right, bottom right.

Every value uses leading zeros if needed.

Here is an example, the first tile of the `page_00.txt` file for Super Mario World's vanilla map16 (the animated water tile):

`0000: 000 { 070 7 ---  072 7 ---  071 7 ---  073 7 --- }`

As you can see, its tile number is 0000 and its acts like setting is 000. The first 8x8 tiles are 070, 072, 071 and 073. All of them use palette 7 and have 
no x flip, y flip or priority set. 

Here are a few more lines from `page_00.txt`, just so you can see a bit more of the format:

```003C: 03C { 0A0 7 --p  0A2 7 --p  0A1 7 --p  0A3 7 --p }

003D: 03D { 0A2 7 --p  0A2 7 --p  0A3 7 --p  0A3 7 --p }

003E: 03E { 0A2 7 --p  0A4 7 --p  0A3 7 --p  0A5 7 --p }

003F: 03F { 194 2 ---  192 2 ---  195 2 ---  193 2 --- }

0040: 040 { 1C0 2 ---  1D0 2 ---  195 2 ---  193 2 --- }

0041: 041 { 194 2 ---  192 2 ---  1C0 2 x--  1D0 2 x-- }

0042: 042 { 185 2 ---  192 2 ---  195 2 ---  193 2 --- }

0043: 043 { 194 2 ---  192 2 ---  185 2 x--  193 2 --- }

0044: 044 { 192 2 -y-  194 2 -y-  193 2 -y-  195 2 -y- }
```

If you look around a bit, you may notice that some entries in `page_00.txt` look like this:

`0073: 073`

These are specifications for tileset group specific tiles. Since these tiles can have different 8x8 tiles in every tileset group, only the acts like part is specified 
in this file, since it stays the same across different tileset groups. The actual tile numbers are specified in each of the 5 tileset group files, for example, in 
`tileset_group_0.txt`:

`0073:     { 1C5 5 ---  1CC 5 ---  1C6 5 ---  1CD 5 --- }`

As you can see, here the acts like setting is "missing" and we only have the four 8x8 tiles specified. This is because the acts like setting is already specified 
for all the tileset groups in `page_00.txt` as we saw earlier! This is also the format for all 0x80 background map16 pages, which don't have acts like settings.

Note that the whitespace in these formats is strictly enforced to make sure it stays consistent. If you accidentally change it, the program will let you know, as 
long as you are using it via the command line (i.e. no drag and drop!).

If you have the tileset specific page 2 setting enabled, `page_02.txt` will also only contain acts like settings and the `tileset_X.txt` files will contain the 
8x8 tile specifications.

If you look at other page files, you may come across this format (a lot!):

`0300: ~`

The peculiar `~` symbol is a shorthand for `130 { 004 4 ---  004 4 ---  004 4 ---  004 4 --- }`. This may look like a random specification at a glance, but as you 
may have already guessed, this is actually the tile specifictaion for Lunar Magic's empty map16 tile. Given that for any hack that's starting out there will be 
thousands of these empty tiles, this shorthand saves a ton of space for most projects and also allows the program to run slightly faster. Of course, this shorthand 
can at any point be replaced by a full tile specification when the tile is no longer unused.

Note that `~` in some contexts is also valid shorthand for `    { 004 4 ---  004 4 ---  004 4 ---  004 4 --- }` (note the lack of acts like setting), specifically 
for tileset (group) specific tiles, as well as background pages, which all don't have an acts like setting.

### Condensed special cases

- All background pages, tileset group specific pages and tileset specific pages use the format *without* acts like settings
- All tiles in the foreground pages that are tilset (group) specific use the format with *only* acts like settings 
- The `tileset_group_0.txt` file has a few more lines than the other tileset group files, since tileset group 0 has a few extra tileset group specific 
tiles (the diagonal pipe tiles), the 8x8 tiles for all other tileset groups for these specific tiles are specified in the corresponding lines in `page_01.txt`
- `~` symbol is a shorthand for Lunar Magic's empty map16 tile and can replace the full 16x16 tile format, as well as the 16x16 tile format without acts like settings
(but not the one *with* acts like settings!)

### Additional notes

- Tiles must stay in the correct order, meaning their tile numbers must increase from top to bottom of every file
- Page files within a directory are parsed in order of their hexadecimal number, going from lowest to highest
- The program is very strict about whitespace and format in order to prevent any "artificial" changes to files, but it should give you detailed error messages if 
you mess up the format on accident
- The program now allows arbitrary amounts of blank lines between individual 16x16 tile specifications and will insert one blank line between each when 
converting from the binary map16 format in order to prevent git from throwing merge conflicts when two commits from different branches alter neighboring tiles
