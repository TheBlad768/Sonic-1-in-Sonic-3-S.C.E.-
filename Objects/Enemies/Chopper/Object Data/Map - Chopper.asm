; ---------------------------------------------------------------------------
; Sprite mappings - Chopper enemy (GHZ)
; ---------------------------------------------------------------------------

Map_Chopper:
		dc.w Map_Chopper_4-Map_Chopper
		dc.w Map_Chopper_C-Map_Chopper
Map_Chopper_4:
		dc.w 1
		dc.b $F0, $F, 0, 0, $FF, $F0
Map_Chopper_C:
		dc.w 1
		dc.b $F0, $F, 0, $10, $FF, $F0
	even
