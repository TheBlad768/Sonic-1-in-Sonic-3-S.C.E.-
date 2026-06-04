; ---------------------------------------------------------------------------
; Sprite mappings - cork floor
; ---------------------------------------------------------------------------

Map_CorkFloor:	mappingsTable
	mappingsTableEntry.w Map_CorkFloor_4
	mappingsTableEntry.w Map_CorkFloor_12

Map_CorkFloor_4:	spriteHeader
	spritePiece	-$10, -$30, 4, 1, $34, 0, 0, 0, 0
	spritePiece	-$10, -$28, 4, 2, $1C, 0, 0, 0, 0
	spritePiece	-$10, -$18, 4, 2, $24, 1, 0, 0, 0
	spritePiece	-$10, -8, 4, 2, $24, 1, 0, 0, 0
	spritePiece	-$10, 8, 4, 2, $24, 1, 0, 0, 0
	spritePiece	-$10, $18, 4, 2, $2C, 0, 0, 0, 0
Map_CorkFloor_4_End

Map_CorkFloor_12:	spriteHeader
	spritePiece	-$10, -$30, 2, 1, $34, 0, 0, 0, 0
	spritePiece	0, -$30, 2, 1, $36, 0, 0, 0, 0
	spritePiece	-$10, -$28, 2, 2, $1C, 0, 0, 0, 0
	spritePiece	0, -$28, 2, 2, $20, 0, 0, 0, 0
	spritePiece	-$10, -$18, 2, 2, $28, 1, 0, 0, 0
	spritePiece	0, -$18, 2, 2, $24, 1, 0, 0, 0
	spritePiece	-$10, -8, 2, 2, $28, 1, 0, 0, 0
	spritePiece	0, -8, 2, 2, $24, 1, 0, 0, 0
	spritePiece	-$10, 8, 2, 2, $28, 1, 0, 0, 0
	spritePiece	0, 8, 2, 2, $24, 1, 0, 0, 0
	spritePiece	-$10, $18, 2, 2, $2C, 0, 0, 0, 0
	spritePiece	0, $18, 2, 2, $30, 0, 0, 0, 0
Map_CorkFloor_12_End

	even
