; ---------------------------------------------------------------------------
; Sprite mappings - SBZ swinging platforms
; ---------------------------------------------------------------------------

Map_SwingingPlatform_SBZ:	mappingsTable
	mappingsTableEntry.w Map_SwingingPlatform_SBZ_6
	mappingsTableEntry.w Map_SwingingPlatform_SBZ_26
	mappingsTableEntry.w Map_SwingingPlatform_SBZ_2E

Map_SwingingPlatform_SBZ_6:	spriteHeader
	spritePiece	-8, -$18, 2, 1, 0, 0, 0, 0, 0
	spritePiece	-$10, -$10, 4, 4, 2, 0, 0, 0, 0
	spritePiece	-$18, -8, 1, 2, $12, 0, 0, 0, 0
	spritePiece	$10, -8, 1, 2, $14, 0, 0, 0, 0
	spritePiece	-8, $10, 2, 1, $16, 0, 0, 0, 0
Map_SwingingPlatform_SBZ_6_End

Map_SwingingPlatform_SBZ_26:	spriteHeader
	spritePiece	-8, -8, 2, 2, $20, 0, 0, 0, 0
Map_SwingingPlatform_SBZ_26_End

Map_SwingingPlatform_SBZ_2E:	spriteHeader
	spritePiece	-$10, -8, 4, 2, $18, 0, 0, 2, 0
	spritePiece	-$10, -$18, 4, 2, $18, 0, 1, 2, 0
Map_SwingingPlatform_SBZ_2E_End

		even
