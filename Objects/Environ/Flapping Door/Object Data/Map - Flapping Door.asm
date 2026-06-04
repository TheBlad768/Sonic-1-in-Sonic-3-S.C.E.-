; ---------------------------------------------------------------------------
; Sprite mappings - flapping door (LZ)
; ---------------------------------------------------------------------------

Map_FlapDoor:	mappingsTable
	mappingsTableEntry.w Map_FlapDoor_6
	mappingsTableEntry.w Map_FlapDoor_14
	mappingsTableEntry.w Map_FlapDoor_22

Map_FlapDoor_6:	spriteHeader
	spritePiece	-8, -$20, 2, 4, 0, 0, 0, 0, 0
	spritePiece	-8, 0, 2, 4, 0, 0, 1, 0, 0
Map_FlapDoor_6_End

Map_FlapDoor_14:	spriteHeader
	spritePiece	-5, -$26, 4, 4, 8, 0, 0, 0, 0
	spritePiece	-5, 6, 4, 4, 8, 0, 1, 0, 0
Map_FlapDoor_14_End

Map_FlapDoor_22:	spriteHeader
	spritePiece	0, -$28, 4, 2, $18, 0, 0, 0, 0
	spritePiece	0, $18, 4, 2, $18, 0, 1, 0, 0
Map_FlapDoor_22_End

		even
