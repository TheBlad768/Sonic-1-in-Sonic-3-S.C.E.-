; ---------------------------------------------------------------------------
; Sprite mappings - smashable green block (MZ)
; ---------------------------------------------------------------------------

Map_SmashBlock:	mappingsTable
	mappingsTableEntry.w Map_SmashBlock_4
	mappingsTableEntry.w Map_SmashBlock_12

Map_SmashBlock_4:	spriteHeader
	spritePiece	-$10, -$10, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 2, 0, 0, 0, 0, 0
Map_SmashBlock_4_End

Map_SmashBlock_12:	spriteHeader
	spritePiece	-$10, -$10, 2, 2, 0, 0, 0, 0, 0
	spritePiece	0, -$10, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, 0, 0, 0, 0, 0
	spritePiece	0, 0, 2, 2, 0, 0, 0, 0, 0
Map_SmashBlock_12_End

		even
