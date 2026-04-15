; ---------------------------------------------------------------------------
; Sprite mappings - special stage "R" block
; ---------------------------------------------------------------------------

Map_SpecialStage_R:
		dc.w Map_SpecialStage_R_6-Map_SpecialStage_R
		dc.w Map_SpecialStage_R_E-Map_SpecialStage_R
		dc.w Map_SpecialStage_R_16-Map_SpecialStage_R
Map_SpecialStage_R_6:
		dc.w 1
		dc.b $F4, $A, 0, 0, $FF, $F4
Map_SpecialStage_R_E:
		dc.w 1
		dc.b $F4, $A, 0, 9, $FF, $F4
Map_SpecialStage_R_16:
		dc.w 0
	even
