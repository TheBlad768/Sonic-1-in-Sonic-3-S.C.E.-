; ---------------------------------------------------------------------------
; Sprite mappings - vanishing platforms (SBZ)
; ---------------------------------------------------------------------------

Map_VanishPlatform:	mappingsTable
	mappingsTableEntry.w Map_VanishPlatform_8
	mappingsTableEntry.w Map_VanishPlatform_10
	mappingsTableEntry.w Map_VanishPlatform_18
	mappingsTableEntry.w Map_VanishPlatform_20

Map_VanishPlatform_8:	spriteHeader
	spritePiece	-$10, -8, 4, 4, 0, 0, 0, 0, 0
Map_VanishPlatform_8_End

Map_VanishPlatform_10:	spriteHeader
	spritePiece	-8, -8, 2, 4, $10, 0, 0, 0, 0
Map_VanishPlatform_10_End

Map_VanishPlatform_18:	spriteHeader
	spritePiece	-4, -8, 1, 4, $18, 0, 0, 0, 0
Map_VanishPlatform_18_End

Map_VanishPlatform_20:	spriteHeader
Map_VanishPlatform_20_End

	even
