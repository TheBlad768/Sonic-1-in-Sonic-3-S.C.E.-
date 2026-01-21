; ---------------------------------------------------------------------------
; Sprite mappings - Chopper enemy (GHZ)
; ---------------------------------------------------------------------------

Map_Chop:
		dc.w Map_Chop_4-Map_Chop
		dc.w Map_Chop_C-Map_Chop
Map_Chop_4:
		dc.w 1
		dc.b $F0, $F, 0, 0, $FF, $F0
Map_Chop_C:
		dc.w 1
		dc.b $F0, $F, 0, $10, $FF, $F0
	even
