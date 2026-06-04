; ---------------------------------------------------------------------------
; Sprite mappings - Splats enemy (MZ)
; ---------------------------------------------------------------------------

Map_Splats:	mappingsTable
	mappingsTableEntry.w Map_Splats_4
	mappingsTableEntry.w Map_Splats_12

Map_Splats_4:	spriteHeader
	spritePiece	-$C, -$14, 3, 4, 0, 0, 0, 0, 0
	spritePiece	-$C, $C, 3, 1, $C, 0, 0, 0, 0
Map_Splats_4_End

Map_Splats_12:	spriteHeader
	spritePiece	-$C, -$14, 3, 4, $F, 0, 0, 0, 0
	spritePiece	-5, $C, 2, 1, $1B, 0, 0, 0, 0
Map_Splats_12_End

	even
