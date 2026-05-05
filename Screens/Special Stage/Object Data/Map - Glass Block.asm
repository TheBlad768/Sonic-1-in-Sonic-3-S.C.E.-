; ---------------------------------------------------------------------------
; Sprite mappings - special stage breakable glass blocks and red-white blocks
; ---------------------------------------------------------------------------

Map_SpecialStage_Glass:
		dc.w Map_SpecialStage_Glass_8-Map_SpecialStage_Glass
		dc.w Map_SpecialStage_Glass_10-Map_SpecialStage_Glass
		dc.w Map_SpecialStage_Glass_18-Map_SpecialStage_Glass
		dc.w Map_SpecialStage_Glass_20-Map_SpecialStage_Glass
Map_SpecialStage_Glass_8:	dc.b 0, 1
		dc.b $F4, $A, 0, 0, $FF, $F4
Map_SpecialStage_Glass_10:	dc.b 0, 1
		dc.b $F4, $A, 8, 0, $FF, $F4
Map_SpecialStage_Glass_18:	dc.b 0, 1
		dc.b $F4, $A, $18, 0, $FF, $F4
Map_SpecialStage_Glass_20:	dc.b 0, 1
		dc.b $F4, $A, $10, 0, $FF, $F4
		even
