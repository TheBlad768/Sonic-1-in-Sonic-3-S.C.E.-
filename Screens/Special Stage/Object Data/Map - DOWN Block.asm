; ---------------------------------------------------------------------------
; Sprite mappings - special stage "DOWN" block
; ---------------------------------------------------------------------------

Map_SpecialStage_Down:	mappingsTable
	mappingsTableEntry.w Map_SpecialStage_Down_4
	mappingsTableEntry.w Map_SpecialStage_Down_C

Map_SpecialStage_Down_4:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 9, 0, 0, 0, 0
Map_SpecialStage_Down_4_End

Map_SpecialStage_Down_C:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, $12, 0, 0, 0, 0
Map_SpecialStage_Down_C_End

	even
