; ---------------------------------------------------------------------------
; Sprite mappings - Chopper enemy (GHZ)
; ---------------------------------------------------------------------------

Map_Chopper:	mappingsTable
	mappingsTableEntry.w Map_Chopper_4
	mappingsTableEntry.w Map_Chopper_C

Map_Chopper_4:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0
Map_Chopper_4_End

Map_Chopper_C:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $10, 0, 0, 0, 0
Map_Chopper_C_End

	even
