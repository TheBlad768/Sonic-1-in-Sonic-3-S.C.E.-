; ---------------------------------------------------------------------------
; Sprite mappings - vanishing platforms (SBZ)
; ---------------------------------------------------------------------------

Map_VanP:
		dc.w Map_VanP_8-Map_VanP
		dc.w Map_VanP_10-Map_VanP
		dc.w Map_VanP_18-Map_VanP
		dc.w Map_VanP_20-Map_VanP
Map_VanP_8:
		dc.b 0, 1
		dc.b $F8, $F, 0, 0, $FF, $F0
Map_VanP_10:
		dc.b 0, 1
		dc.b $F8, 7, 0, $10, $FF, $F8
Map_VanP_18:
		dc.b 0, 1
		dc.b $F8, 3, 0, $18, $FF, $FC
Map_VanP_20:
		dc.w 0
	even
