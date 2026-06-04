; ---------------------------------------------------------------------------
; Sprite mappings - GHZ and MZ swinging platforms
; ---------------------------------------------------------------------------

Map_SwingingPlatform_GHZ:	mappingsTable
	mappingsTableEntry.w Map_SwingingPlatform_GHZ_6
	mappingsTableEntry.w Map_SwingingPlatform_GHZ_14
	mappingsTableEntry.w Map_SwingingPlatform_GHZ_1C

Map_SwingingPlatform_GHZ_6:	spriteHeader
	spritePiece	-$18, -8, 3, 2, 4, 0, 0, 2, 0
	spritePiece	0, -8, 3, 2, 4, 0, 0, 2, 0
Map_SwingingPlatform_GHZ_6_End

Map_SwingingPlatform_GHZ_14:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0
Map_SwingingPlatform_GHZ_14_End

Map_SwingingPlatform_GHZ_1C:	spriteHeader
	spritePiece	-8, -8, 2, 2, $A, 0, 0, 2, 0
Map_SwingingPlatform_GHZ_1C_End

		even
