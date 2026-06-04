; ---------------------------------------------------------------------------
; Sprite mappings - still sprites
; ---------------------------------------------------------------------------

Map_StillSprites:	mappingsTable
	mappingsTableEntry.w Map_StillSprites_A
	mappingsTableEntry.w Map_StillSprites_18
	mappingsTableEntry.w Map_StillSprites_20
	mappingsTableEntry.w Map_StillSprites_28
	mappingsTableEntry.w Map_StillSprites_30

Map_StillSprites_A:	spriteHeader
	spritePiece	-$10, -8, 2, 1, 0, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 1, 2, 0, 0, 0, 0
Map_StillSprites_A_End

Map_StillSprites_18:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0
Map_StillSprites_18_End

Map_StillSprites_20:	spriteHeader
	spritePiece	-$10, -8, 4, 2, 0, 0, 0, 0, 0
Map_StillSprites_20_End

Map_StillSprites_28:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0
Map_StillSprites_28_End

Map_StillSprites_30:	spriteHeader
	spritePiece	-8, -$10, 2, 4, 0, 0, 0, 0, 0
Map_StillSprites_30_End

	even
