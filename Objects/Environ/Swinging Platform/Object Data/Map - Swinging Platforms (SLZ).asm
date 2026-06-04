; ---------------------------------------------------------------------------
; Sprite mappings - SLZ swinging platforms
; ---------------------------------------------------------------------------

Map_SwingingPlatform_SLZ:	mappingsTable
	mappingsTableEntry.w Map_SwingingPlatform_SLZ_6
	mappingsTableEntry.w Map_SwingingPlatform_SLZ_38
	mappingsTableEntry.w Map_SwingingPlatform_SLZ_40

Map_SwingingPlatform_SLZ_6:	spriteHeader
	spritePiece	-$20, -$10, 4, 4, 4, 0, 0, 0, 0
	spritePiece	0, -$10, 4, 4, 4, 1, 0, 0, 0
	spritePiece	-$30, -$10, 2, 2, $14, 0, 0, 0, 0
	spritePiece	$20, -$10, 2, 2, $14, 1, 0, 0, 0
	spritePiece	-$20, $10, 2, 1, $18, 0, 0, 0, 0
	spritePiece	$10, $10, 2, 1, $18, 1, 0, 0, 0
	spritePiece	-8, $10, 1, 2, $1A, 0, 0, 0, 0
	spritePiece	0, $10, 1, 2, $1A, 1, 0, 0, 0
Map_SwingingPlatform_SLZ_6_End

Map_SwingingPlatform_SLZ_38:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0
Map_SwingingPlatform_SLZ_38_End

Map_SwingingPlatform_SLZ_40:	spriteHeader
	spritePiece	-8, -8, 2, 2, $1C, 0, 0, 0, 0
Map_SwingingPlatform_SLZ_40_End

		even
