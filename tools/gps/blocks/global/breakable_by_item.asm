; act as 130

db $42
JMP ++ : JMP ++ : JMP ++
JMP SpriteV : JMP SpriteH : JMP ++ : JMP ++
JMP ++ : JMP ++

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
++	rtl

print "A block that shatters when a sprite is thrown at it."