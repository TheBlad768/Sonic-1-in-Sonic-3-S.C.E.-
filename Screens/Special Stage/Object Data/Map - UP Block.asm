; ---------------------------------------------------------------------------
; Sprite mappings - special stage "UP" block
; ---------------------------------------------------------------------------

Map_SpecialStage_Up:	mappingsTable
	mappingsTableEntry.w Map_SpecialStage_Up_4
	mappingsTableEntry.w Map_SpecialStage_Up_C

Map_SpecialStage_Up_4:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 0, 0, 0, 0, 0
Map_SpecialStage_Up_4_End

Map_SpecialStage_Up_C:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, $12, 0, 0, 0, 0
Map_SpecialStage_Up_C_End

	even
