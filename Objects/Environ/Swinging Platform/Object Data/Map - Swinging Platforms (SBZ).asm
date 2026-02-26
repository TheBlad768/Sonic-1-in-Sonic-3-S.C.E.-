; ---------------------------------------------------------------------------
; Sprite mappings - SBZ swinging platforms
; ---------------------------------------------------------------------------

Map_Swing_SBZ:
		dc.w Map_Swing_SBZ_6-Map_Swing_SBZ
		dc.w Map_Swing_SBZ_26-Map_Swing_SBZ
		dc.w Map_Swing_SBZ_2E-Map_Swing_SBZ
Map_Swing_SBZ_6:	dc.b 0, 5
		dc.b $E8, 4, 0, 0, $FF, $F8
		dc.b $F0, $F, 0, 2, $FF, $F0
		dc.b $F8, 1, 0, $12, $FF, $E8
		dc.b $F8, 1, 0, $14, 0, $10
		dc.b $10, 4, 0, $16, $FF, $F8
Map_Swing_SBZ_26:	dc.b 0, 1
		dc.b $F8, 5, 0, $20, $FF, $F8
Map_Swing_SBZ_2E:	dc.b 0, 2
		dc.b $F8, $D, $40, $18, $FF, $F0
		dc.b $E8, $D, $50, $18, $FF, $F0
		even
