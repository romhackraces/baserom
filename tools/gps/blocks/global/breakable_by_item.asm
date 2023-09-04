; act as 130

db $42
JMP Return : JMP Return : JMP Return
JMP SpriteV : JMP SpriteH : JMP Return : JMP Return
JMP Return : JMP Return

SpriteV:
	%check_sprite_kicked_vertical()
	bcs Shatter
	rtl
SpriteH:
	%check_sprite_kicked_horizontal()
	bcs Shatter
	rtl
Shatter:
	%sprite_block_position()
	%shatter_block()
Return:
	rtl

print "A block that shatters when a sprite is thrown at it."