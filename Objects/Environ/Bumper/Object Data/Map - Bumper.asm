; ---------------------------------------------------------------------------
; Sprite mappings - pinball bumper (SYZ)
; ---------------------------------------------------------------------------

Map_Bump:	mappingsTable
	mappingsTableEntry.w Map_Bump_6
	mappingsTableEntry.w Map_Bump_14
	mappingsTableEntry.w Map_Bump_22

Map_Bump_6:	spriteHeader
	spritePiece	-$10, -$10, 2, 4, 0, 0, 0, 0, 0
	spritePiece	0, -$10, 2, 4, 0, 1, 0, 0, 0
Map_Bump_6_End

Map_Bump_14:	spriteHeader
	spritePiece	-$C, -$C, 2, 3, 8, 0, 0, 0, 0
	spritePiece	4, -$C, 1, 3, 8, 1, 0, 0, 0
Map_Bump_14_End

Map_Bump_22:	spriteHeader
	spritePiece	-$10, -$10, 2, 4, $E, 0, 0, 0, 0
	spritePiece	0, -$10, 2, 4, $E, 1, 0, 0, 0
Map_Bump_22_End

		even
