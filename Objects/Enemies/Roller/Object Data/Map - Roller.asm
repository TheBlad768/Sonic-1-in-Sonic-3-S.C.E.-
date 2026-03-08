; ---------------------------------------------------------------------------
; Sprite mappings - Roller enemy (SYZ)
; ---------------------------------------------------------------------------

Map_Roller:
		dc.w Map_Roller_A-Map_Roller, Map_Roller_18-Map_Roller
		dc.w Map_Roller_26-Map_Roller, Map_Roller_2E-Map_Roller
		dc.w Map_Roller_36-Map_Roller
Map_Roller_A:	dc.b 0, 2
		dc.b $DE, $E, 0, 0, $FF, $F0
		dc.b $F6, $E, 0, $C, $FF, $F0
Map_Roller_18:	dc.b 0, 2
		dc.b $E6, $E, 0, 0, $FF, $F0
		dc.b $FE, $D, 0, $18, $FF, $F0
Map_Roller_26:	dc.b 0, 1
		dc.b $F0, $F, 0, $20, $FF, $F0
Map_Roller_2E:	dc.b 0, 1
		dc.b $F0, $F, 0, $30, $FF, $F0
Map_Roller_36:	dc.b 0, 1
		dc.b $F0, $F, 0, $40, $FF, $F0
		even
