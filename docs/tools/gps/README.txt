What is GPS:
	GPS is the temporary name of the next generation of block tool.
	 (Except not really temporary anymore)

Features:
	1) Command line based for speed and ease of use
	2) Designed to detect duplicate files and recycle insertion pointer to save space.
	3) Includes a mechanism for shared routines for additional space savings and ease of development.
	4) Hybrid SA-1 support.
	5) Allows setting of the Acts like setting from within the tool.
	6) Include several defines which dynamically changes depending of the ROM type.
	7) All Currently accepted db $42 blocks should be compatible. So this tool is backwards compatible.
	8) Can remove BTSD from a hack for ease of upgrading
	9) You can enable a debug flag which prints the addresses of labels that are inserted.
	   Very handy for block creation if you need to set a breakpoint.
	10) DSC file generation based on descriptions that come with blocks.
	11) Optimiztion levels to decrease insertion sizes

How to use:
	From the command line you would execute the following command:
		GPS <options> <ROM>
	Options are as follow (they are optional of course):
		-d		Enable debug output
		-k		Keep debug files
		-l <listpath>	Specify a custom list file (Default: list.txt)
		-b <blockpath>	Specify a custom block directory (Default blocks/)
		-s <sharedpath>	Specify a shared routine directory (Default routines/)
		-O1		Enable optimization level 1, reduces pointer table size when possible
		-O2		Enable optimization level 2, reduces bank byte size when possible
		-rom		Asks for the rom even when passing command line parameters (GPS will still close once it's done)
	And lastly the ROM is required (Unless -rom is provided).  It may be headered or unheadered.

	Note: Optimization level one is usually very safe unless you feel you may fill your ROM and need to reserve
	extra space for the block table ahead of time.  Level two however requires more care.  Using undefined blocks
	at level two WILL CRASH if mario touches them.  Use level two with caution.

The list format:
	The list format has three parts: the block id, an optional acts like setting, and the ASM file to use.
	The basic structure is as follows:
		<blockid><:acts like> <file>
	Some examples would be:
		200:01		power.asm
		201		power.asm
		1203:0130	power.asm

	If you want to assign the same file to mutiple blocks at the same time you can use
		<blockid 1>-<blockid 2><:acts like> <file>
		R<blockid 1>-<blockid 2><:acts like> <file>
	Examples:
		200-202:10	power.asm
		R203-214	power.asm

	The first line will assign blocks 200, 201 and 202 the file "power.asm" and acts like 10
	The second line will assign a rectangle of blocks 203, 204, 213, 214 with the file "power.asm" without changing their acts like.

	The tabbing is optional and may be a single space instead.
	When a line starts with ";" it's treated as a comment and won't be read by GPS.

The "@dsc" command:
	When putting "@dsc" in the line everything after it is pasted after the generated .dsc file. This allows you to manually assign descriptions to blocks that are not custom blocks from GPS
	NOTE:
		The "@dsc" needs to go on its own separate line with the dsc content going on the subsequent lines.
		As soon as GPS reads the "@dsc" command it will stop parsing the file, this means that comments and
		other GPS specific rules do not apply. Only .dsc rules apply after this command.
		For more information on dsc files read the 'Custom Tooltips for Direct Map16 Tiles' section in Lunar Magics help file under Help>Contents

	Example:
		; Custom blocks from GPS
		4000:0130	my_custom_blk_1.asm
		4001:0130	my_custom_blk_2.asm
		4002:0130	my_custom_blk_3.asm

		; Custom blocks from Lunar Magic
		@dsc
		4003	0	A Thwimp statue which acts like a cement block.
		4004	0	A decorative flower which acts like nothing.

FAQ:

Q) Can I use this tool if I used BTSD previously?
A) Yes.  This tool will delete the BTSD hijacks. (see features item number 8)

Q) Are BTSD blocks supported?
A) All blocks using the db $42 header are currently supported.  If you find a block without such a header please PM an
   ASM moderator for conversion. (see features item number 7)

Q) Is there a graphical interface for GPS?
A) Yes, however its not quite ready yet so was removed until alcaro has a chance to fix it.  Once it is ready I will
   submit is as an update making the following answer relevant
A) Yes! Alcaro has made a GUI which is included with GPS V1.2.31. This GUI is not included in the current version as it does
   not support features of the current list and will cause problems when trying to use these features. If you still want to
   use it and don't care about the features download an older version which still has the GUI (https://www.smwcentral.net/?p=section&a=details&id=15337&r=0)
   and copy the GUI over to your current GPS then just double click gps_gui instead of gps.
   I do recommend at least trying to use the command line version first -- it's very simple and you may just like it!

Q) Are SA-1 ROMs supported?
A) Yes, as long the new blocks and shared routines you insert are compatible with SA-1. You can convert them using the
   SA-1 Convert Tool, available at the Tools section in SMW Central or by asking the block author for a SA-1 or hybrid
   (both standard and SA-1) version of the block in case the tool doesn't work.

For developers:
	Shared routines:
		To make a shared routine:
			1) Write your code, do *not* label the routine. The tool will generate the label based on the file name.
			2) Place in routines folder with the desired routine name
			3) Done

		Using a routine:
			1) Just call "%my_routines_name()"
			2) Done

		Special notes:
			1) A label with the file name is reserved. Do not use it.
			2) A define with the name of the file is reserved. Do not use it.
			3) A macro with the name of the file is reserved. Do not use it.

	A quick note on shared routines and labels:
		As of version 1.4.0 GPS uses namespaces and #<label> to prevent sublabel conflicts.
		This means that in routines normal labels should not be used. To prevent issues with nested routines only macro labels should be used in routines.
		Use of +/- labels can still be done when prefixed with a questionmark (?) e.g. ?+/?-

	DSC files:
		You should include a "print" statement within your block.  The first print statement will be used as the
		description in the DSC file.

		As of version 1.4.2 you may also use additional prints to further specify how the block appears in Lunar Magic.
		(The first print is still always the description even if it matches one of the new print options)
		Further print options are:
			@pswitch=<rel><map16>
				Displays a different map16 tile when "View>Invisible POW Objects" is enabled
			@hidden=<rel><map16>
				Displays a different map16 tile when "View>Other Invisible Objects" is enabled
			@content=<sprite map16>
				Shows the specified sprite map16 number when "View>Block Contents" is enabled
			@transparent
				Always displays the map16 tile as transparent in Lunar Magic

			All parameters are parsed as hexadecimal
			<sprite map16> is the map16 tile of the sprite section of the 16x16 Tilemap editor. Refer to Lunar Magics help file for information on these
			<map16> is the map16 tile to display if the corresponding view option in Lunar Magic is enabled
			<rel> may be a + or a - to indicate that <map16> is relative to the map16 number the block was inserted on or empty to use <map16> directly

			A few examples on block 310:
				print "@hidden=+1"	; displays map16 tile 311 when "View>Other Invisible Objects" is enabled
				print "@pswitch=48"	; displays map16 tile 48 when "View>Invisible POW Objects" is enabled
				print "@pswitch=-5"	; displays map16 tile 30B when "View>Invisible POW Objects" is enabled
				print "@content=1DB"	; displays a hammer (sprite map16 tile 1DB) when "View>Block Contents" is enabled
				print "@transparent"	; always displays the map16 tile transparent

			GPS looks through all prints after the first description print for options.
			Prints that do not match any of the options are ignored.

	Defines:
		GPS includes several defines which change according to the ROM type, allowing compatibility on ROMs
		with special patches or chips, like SA-1 ROM. GPS for now has the following defines:
			!sa1		0 for LoROM, 1 for SA-1 ROM.
			!dp			$0000 for LoROM, $3000 for SA-1 ROM.
			!addr		$0000 for LoROM, $6000 for SA-1 ROM.
			!bank		$800000 for LoROM (FastROM), $000000 for SA-1 ROM.
			!bank8		$80 for LoROM (FastROM), $00 for SA-1 ROM.

		Additionally there's various sprite defines located in defines.asm where you can either use
		!<RAM address> or !<known name>, for example LDA !14C8,x or LDA !sprite_status,x

		Check out defines.asm for a full list of available defines.

		It is advised when coding your block to use these defines for compatibility with special ROMs, like how
		you can see in the shared routines, but not required.


Bounce Block Unrestrictor & Custom Bounce Block
	The spawn_bounce_sprite routine can be used with the BBU/CBB patches (https://www.smwcentral.net/?p=section&a=details&id=18996). To use it make sure that !bounce_map16_num (In defines.asm) is what you set the map16 table to in the BBU/CBB patch.
	If you do not use a block that needs these patches then this won't affect you.
