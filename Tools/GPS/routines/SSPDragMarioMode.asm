incsrc "../Defines/ScreenScrollingPipes.asm"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Drag mario mode handler.
;;
;;When hitting [DragToDestination.asm], it will execute this
;;code to set the player's destination position.
;;
;;Each warp to a specific point is each index ID.
;;
;;Output:
;;-Carry = Set if no warp index found. This is so that for
;; 2-way warps, prevents the centering code from centering the
;; player every frame and traps him inside a pipe when reaching
;; warp destination.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	PHB							;>Preserve bank
	PHK							;\Adjust bank for any $xxxx,y
	PLB							;/
	PHY							;>Preserve block behaver
	REP #$10
	;Start at the highest valid index:
		LDX.w #((?CorrectDirection_End-?CorrectDirection)-1*2)		;>For 16-bit table array
		LDY.w #(?CorrectDirection_End-?CorrectDirection)-1		;>For 8-bit table array
	?Loop
		;Which warp to use:
			;Check if the player is going in the correct direction into the warp:
				?.CorrectDirectionCheck
					LDA !Freeram_SSP_PipeDir
					AND.b #%00001111
					CMP #$05
					BCC ?.AlreadyConvertedDirection
					SEC
					SBC #$04
				?.AlreadyConvertedDirection
					CMP ?CorrectDirection,y
					BNE ?.Next
			;Find if current level matches
				REP #$20
				LDA $010B|!addr
				CMP ?LevelNumberTable,x
				SEP #$20
				BNE ?.Next
			;Level matched, now check the XY start position
				;Is Xposition matched?
					REP #$20
					LDA $9A
					LSR #4			;>Convert pixel coordinates to 16x16 block coordinate
					CMP ?StartPositionX,x
					SEP #$20
					BNE ?.Next
				;What about Y?
					REP #$20
					LDA $98
					LSR #4			;>Convert pixel coordinates to 16x16 block coordinate
					CMP ?StartPositionY,x
					SEP #$20
					BNE ?.Next
		;With the XY start position matched, now take the destination position, write it to
		;!Freeram_SSP_DragWarpPipeDestinationXPos and !Freeram_SSP_DragWarpPipeDestinationYPos
			REP #$20
			LDA ?EndPositionX,x
			STA !Freeram_SSP_DragWarpPipeDestinationXPos
			LDA ?EndPositionY,x
			STA !Freeram_SSP_DragWarpPipeDestinationYPos
			SEP #$20
		;State and prep direction
			LDA #$09			;>$09 = %00001001
			ORA ?DestinationDirection,y	;>%XXXX1001
			STA !Freeram_SSP_PipeDir
		;Done.
			CLC
			BRA ?Done
	?.Next
		DEY
		DEX #2
		BPL ?Loop
		SEC
		BRA ?Done
	?Done
		SEP #$30
		PLY				;>Restore block behaver
		PLB
		RTL
;These are tables containing the warps (each warp is 1 entry, therefore 2-way takes 1 entry from point A to B
;and another from point B back to point A).
;
;When I mean “entry”, I mean the number of items, regardless of the value is 8 or 16-bit.
;
;Due to signed 16-bit limitations, you can have up to 32768 ($8000 in hex, index numbers from $0000-$7FFF
;(0-32767)) warp entries in your entire game per this routine. Highly unlikely you would even get close to
;that number.
;
;Also note that if you have a huge number of entries here, and you trigger this routine that does not match
;any of the entries here (match the direction to warp, level number, and XY start position), the game will lag.
;Reason of the lag is because this code checks every single entry in these tables and all of them will fail.
;
;Technically, this should only lag for 1-frame execution (barely noticeable though) when it matches, especially
;if the player triggering the warp mode block matches with the first entry on the list (the loop code above
;starts at the last index and counts backwards until a match is found or when reaches a negative number).
;
;If you need a lot of warp entries and not have slowdown, here are ways to avoid it:
;-Avoid making it possible for the player to trigger the [Dragplayer.asm] in the wrong direction, it will do
; nothing by default as intended, but it still have to check a list of correct directions.
;--For 2-way warps, don't place the warp destinations (or EndPositionX and Y) that would place the player
;  touching the drag player block he's touching as he leaves that spot. Place him a tile away (such as
;  above it in an upwards facing pipe).
;-Divide the table into separate subroutines, and have it separate per version. Meaning have duplicates of
; this routine and the block with name variations, including the function call [%SSPDragMarioMode()] itself
; inside [DragPlayer.asm], with each of them having a smaller list. This will cut down the loop iterations
; and limits to what group it should focus on.
;--Example: Instead of having 100 items in the list, I would have:
;---2 drag mario subroutine files, the original and [SSPDragMarioMode1.asm] (note the “1” appended to the file name before the extension)
;---2 blocks to enter drag mode, the original and [DragPlayer1.asm] (duplicates should have [%SSPDragMarioMode1()])
;---And have 50 in each of the subroutine files.
;
;Remember, each nth item in the table is associated with another item from one another table also the nth item starting from the top, meaning
;that the first item (topmost, index 0) means all the first items in each table, the second is second for all other tables and so on.
;
;I recommend using comments, and labeling each item in the table with their index number so that you can track, and debug if anything goes wrong.
;You can automate this by making use of Notepad++ ( https://notepad-plus-plus.org/downloads/ )'s column select (alt + shift + click elsewhere),
;then on the menubar:
;Edit -> Column Editor, on that window, have [number to insert] be checked, and:
;Inital number: 0
;Increase by: 1 or 2 (1 for db table, 2 for dw table)
;Format: Hex or Dec.
	;These determine which warp the player will take:
		;Direction to enter warp mode (traveling in other directions into
		;the warp will do nothing). Only use values $01-$04:
		;-$01 = Up
		;-$02 = Right
		;-$03 = Down
		;-$04 = Left
			?CorrectDirection
				;Keep all your numbers in between the label [?CorrectDirection] and [?.End]. This is needed to determine
				;during assembly on how may indexes, which determines what number the index will start at to count down.
					db $01			;>Index 0
					db $03			;>Index 1
					db $02			;>Index 2
					db $03			;>Index 3
					db $03			;>Index 4
					db $04			;>Index 5
					db $03			;>Index 6
					?.End			;>Keep this here!
		;Level the start wrap points are in.
			?LevelNumberTable
				dw $0105		;>Index 0 (Index 0 * 2)
				dw $0105		;>Index 2 (Index 1 * 2)
				dw $0105		;>Index 4 (Index 2 * 2)
				dw $0105		;>Index 6 (Index 3 * 2)
				dw $0105		;>Index 8 (Index 4 * 2)
				dw $0105		;>Index 10 (Index 5 * 2)
				dw $0105		;>Index 12 (Index 6 * 2)
		
		;These is the current block position (block coordinates, in units of 16x16, not pixels)
		;where Mario comes from.
			?StartPositionX
				dw $0003		;>Index 0 (Index 0 * 2)
				dw $009A		;>Index 2 (Index 1 * 2)
				dw $009A		;>Index 4 (Index 2 * 2)
				dw $00B9		;>Index 6 (Index 3 * 2)
				dw $00AF		;>Index 8 (Index 4 * 2)
				dw $00C2		;>Index 10 (Index 5 * 2)
				dw $00D4		;>Index 12 (Index 6 * 2)
			?StartPositionY
				dw $0013		;>Index 0 (Index 0 * 2)
				dw $0022		;>Index 2 (Index 1 * 2)
				dw $0022		;>Index 4 (Index 2 * 2)
				dw $001E		;>Index 6 (Index 3 * 2)
				dw $0008		;>Index 8 (Index 4 * 2)
				dw $0014		;>Index 10 (Index 5 * 2)
				dw $0022		;>Index 12 (Index 6 * 2)
	;These are the destination positions, in pixels (why not block positions, then LSR #4?,
	;well, because it is possible that the player must be centered horizontally between 2 blocks
	;than 16x16 grid-aligned as in the case with traveling through normal-sized vertical pipes).
	;
	;You can easily convert them into pixel coordinate via this formula:
	;	dw (BlockPos*$10)+HalfBlock
	;	
	;	-BlockPos = the X or Y position, in units of 16x16 (the coordinates of the block seen in Lunar Magic).
	;	-HalfBlock = $00 (16x16 aligned) or $08 (half-block aligned, with vertical normal-sized pipes, you
	;	 normally do this for X position though).

	;These positions are “feet” position of the player, rather than the head position.
	;When riding on yoshi, it is the position of Yoshi's saddle part, not the player's feet.
	;Therefore, to get the correct position in a pipe:
	;
	;-For Small horizontal pipes, it is the tile of the stem part, nuff said, same goes with vertical small pipe.
	;-For regular sized horizontal pipes, it is the bottom half of the stem.
	;-For regular sized vertical pipes, it is the bottom-left tile of the 2x2 16x16 block space the player is at least
	; touching, assuming you are using the [(BlockPos*$10)+HalfBlock] formula.


		?EndPositionX
			dw ($009A*$10)+$08	;>Index 0 (Index 0 * 2)
			dw ($0003*$10)+$08	;>Index 2 (Index 1 * 2)
			dw ($00AC*$10)+$00	;>Index 4 (Index 2 * 2)
			dw ($00AF*$10)+$08	;>Index 6 (Index 3 * 2)
			dw ($00B9*$10)+$08	;>Index 8 (Index 4 * 2)
			dw ($00D4*$10)+$08	;>Index 10 (Index 5 * 2)
			dw ($00C2*$10)+$00	;>Index 12 (Index 6 * 2)
		?EndPositionY
			dw ($0022*$10)		;>Index 0 (Index 0 * 2)
			dw ($0013*$10)		;>Index 2 (Index 1 * 2)
			dw ($0019*$10)		;>Index 4 (Index 2 * 2)
			dw ($0008*$10)		;>Index 6 (Index 3 * 2)
			dw ($001E*$10)		;>Index 8 (Index 4 * 2)
			dw ($0022*$10)		;>Index 10 (Index 5 * 2)
			dw ($0014*$10)		;>Index 12 (Index 6 * 2)
	;This is the prep direction to set to that the player will start moving in that direction
	;upon reaching his destination.
	;Only use these values
	;-$00 = Revert to normal mode (“exit” the pipe with no animation nor sound)
	;-$10 = up
	;-$20 = right
	;-$30 = down
	;-$40 = left
		?DestinationDirection
			db $10			;>Index 0
			db $30			;>Index 1
			db $20			;>Index 2
			db $10			;>Index 3
			db $10			;>Index 4
			db $10			;>Index 5
			db $20			;>Index 6