; ---------------------------------------------------------------------------
; Sprite mappings - blocks that Robotnik picks up (SYZ)
; ---------------------------------------------------------------------------

Map_BossSYZBlock:	mappingsTable
	mappingsTableEntry.w Map_BossSYZBlock_A
	mappingsTableEntry.w Map_BossSYZBlock_12
	mappingsTableEntry.w Map_BossSYZBlock_1A
	mappingsTableEntry.w Map_BossSYZBlock_22
	mappingsTableEntry.w Map_BossSYZBlock_2A

Map_BossSYZBlock_A:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0
Map_BossSYZBlock_A_End

Map_BossSYZBlock_12:	spriteHeader
	spritePiece	-$10, -$10, 2, 2, $10, 0, 0, 0, 0
Map_BossSYZBlock_12_End

Map_BossSYZBlock_1A:	spriteHeader
	spritePiece	0, -$10, 2, 2, $14, 0, 0, 0, 0
Map_BossSYZBlock_1A_End

Map_BossSYZBlock_22:	spriteHeader
	spritePiece	-$10, 0, 2, 2, $18, 0, 0, 0, 0
Map_BossSYZBlock_22_End

Map_BossSYZBlock_2A:	spriteHeader
	spritePiece	0, 0, 2, 2, $1C, 0, 0, 0, 0
Map_BossSYZBlock_2A_End

		even
