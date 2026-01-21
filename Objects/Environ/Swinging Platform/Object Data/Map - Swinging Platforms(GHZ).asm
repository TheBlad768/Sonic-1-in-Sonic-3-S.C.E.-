; ---------------------------------------------------------------------------
; Sprite mappings - GHZ and MZ swinging platforms
; ---------------------------------------------------------------------------

Map_Swing_GHZ:
		dc.w Map_Swing_GHZ_6-Map_Swing_GHZ
		dc.w Map_Swing_GHZ_14-Map_Swing_GHZ
		dc.w Map_Swing_GHZ_1C-Map_Swing_GHZ
Map_Swing_GHZ_6:	dc.b 0, 2
		dc.b $F8, 9, $40, 4, $FF, $E8
		dc.b $F8, 9, $40, 4, 0, 0
Map_Swing_GHZ_14:	dc.b 0, 1
		dc.b $F8, 5, 0, 0, $FF, $F8
Map_Swing_GHZ_1C:	dc.b 0, 1
		dc.b $F8, 5, $40, $A, $FF, $F8
		even
