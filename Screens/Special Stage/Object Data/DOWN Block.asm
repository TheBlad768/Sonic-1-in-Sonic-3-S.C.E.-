; ---------------------------------------------------------------------------
; Sprite mappings - special stage "DOWN" block
; ---------------------------------------------------------------------------

Map_SpecialStage_Down:
		dc.w Map_SpecialStage_Down_4-Map_SpecialStage_Down
		dc.w Map_SpecialStage_Down_C-Map_SpecialStage_Down
Map_SpecialStage_Down_4:
		dc.w 1
		dc.b $F4, $A, 0, 9, $FF, $F4
Map_SpecialStage_Down_C:
		dc.w 1
		dc.b $F4, $A, 0, $12, $FF, $F4
	even
