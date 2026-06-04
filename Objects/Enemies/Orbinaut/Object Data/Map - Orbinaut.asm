; ---------------------------------------------------------------------------
; Sprite mappings - Orbinaut enemy (LZ, SLZ, SBZ)
; ---------------------------------------------------------------------------

Map_Orbinaut:	mappingsTable
	mappingsTableEntry.w Map_Orbinaut_8
	mappingsTableEntry.w Map_Orbinaut_10
	mappingsTableEntry.w Map_Orbinaut_18

Map_Orbinaut_8:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 0, 0, 0, 0, 0
Map_Orbinaut_8_End

Map_Orbinaut_10:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 9, 0, 0, 1, 0
Map_Orbinaut_10_End

Map_Orbinaut_18:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, $12, 0, 0, 0, 0
Map_Orbinaut_18_End

	even
