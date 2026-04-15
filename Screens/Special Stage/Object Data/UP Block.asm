; ---------------------------------------------------------------------------
; Sprite mappings - special stage "UP" block
; ---------------------------------------------------------------------------

Map_SpecialStage_Up:
		dc.w Map_SpecialStage_Up_4-Map_SpecialStage_Up
		dc.w Map_SpecialStage_Up_C-Map_SpecialStage_Up
Map_SpecialStage_Up_4:
		dc.w 1
		dc.b $F4, $A, 0, 0, $FF, $F4
Map_SpecialStage_Up_C:
		dc.w 1
		dc.b $F4, $A, 0, $12, $FF, $F4
	even
