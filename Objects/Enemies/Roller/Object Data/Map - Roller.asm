; ---------------------------------------------------------------------------
; Sprite mappings - Roller enemy (SYZ)
; ---------------------------------------------------------------------------

Map_Roller:	mappingsTable
	mappingsTableEntry.w Map_Roller_A
	mappingsTableEntry.w Map_Roller_18
	mappingsTableEntry.w Map_Roller_26
	mappingsTableEntry.w Map_Roller_2E
	mappingsTableEntry.w Map_Roller_36

Map_Roller_A:	spriteHeader
	spritePiece	-$10, -$22, 4, 3, 0, 0, 0, 0, 0
	spritePiece	-$10, -$A, 4, 3, $C, 0, 0, 0, 0
Map_Roller_A_End

Map_Roller_18:	spriteHeader
	spritePiece	-$10, -$1A, 4, 3, 0, 0, 0, 0, 0
	spritePiece	-$10, -2, 4, 2, $18, 0, 0, 0, 0
Map_Roller_18_End

Map_Roller_26:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $20, 0, 0, 0, 0
Map_Roller_26_End

Map_Roller_2E:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $30, 0, 0, 0, 0
Map_Roller_2E_End

Map_Roller_36:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $40, 0, 0, 0, 0
Map_Roller_36_End

		even
