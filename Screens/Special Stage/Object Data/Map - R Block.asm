; ---------------------------------------------------------------------------
; Sprite mappings - special stage "R" block
; ---------------------------------------------------------------------------

Map_SpecialStage_R:	mappingsTable
	mappingsTableEntry.w Map_SpecialStage_R_6
	mappingsTableEntry.w Map_SpecialStage_R_E
	mappingsTableEntry.w Map_SpecialStage_R_16

Map_SpecialStage_R_6:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 0, 0, 0, 0, 0
Map_SpecialStage_R_6_End

Map_SpecialStage_R_E:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 9, 0, 0, 0, 0
Map_SpecialStage_R_E_End

Map_SpecialStage_R_16:	spriteHeader
Map_SpecialStage_R_16_End

	even
