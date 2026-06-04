; ---------------------------------------------------------------------------
; Sprite mappings - block pieces that disintegrate when Eggman presses a switch
; ---------------------------------------------------------------------------

Map_FFloor_Pieces:	mappingsTable
	mappingsTableEntry.w Map_FFloor_12
	mappingsTableEntry.w Map_FFloor_20
	mappingsTableEntry.w Map_FFloor_2E
	mappingsTableEntry.w Map_FFloor_3C

Map_FFloor_12:	spriteHeader
	spritePiece	-8, -8, 1, 2, 0, 0, 0, 0, 0
	spritePiece	0, -8, 1, 2, 4, 0, 0, 0, 0
Map_FFloor_12_End

Map_FFloor_20:	spriteHeader
	spritePiece	-8, -8, 1, 2, 8, 0, 0, 0, 0
	spritePiece	0, -8, 1, 2, $C, 0, 0, 0, 0
Map_FFloor_20_End

Map_FFloor_2E:	spriteHeader
	spritePiece	-8, -8, 1, 2, 2, 0, 0, 0, 0
	spritePiece	0, -8, 1, 2, 6, 0, 0, 0, 0
Map_FFloor_2E_End

Map_FFloor_3C:	spriteHeader
	spritePiece	-8, -8, 1, 2, $A, 0, 0, 0, 0
	spritePiece	0, -8, 1, 2, $E, 0, 0, 0, 0
Map_FFloor_3C_End

	even
