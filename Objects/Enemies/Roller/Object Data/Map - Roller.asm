; ---------------------------------------------------------------------------
; Sprite mappings - Roller enemy (SYZ)
; ---------------------------------------------------------------------------

Map_Roll:
		dc.w Map_Roll_A-Map_Roll, Map_Roll_18-Map_Roll
		dc.w Map_Roll_26-Map_Roll, Map_Roll_2E-Map_Roll
		dc.w Map_Roll_36-Map_Roll
Map_Roll_A:	dc.b 0, 2
		dc.b $DE, $E, 0, 0, $FF, $F0
		dc.b $F6, $E, 0, $C, $FF, $F0
Map_Roll_18:	dc.b 0, 2
		dc.b $E6, $E, 0, 0, $FF, $F0
		dc.b $FE, $D, 0, $18, $FF, $F0
Map_Roll_26:	dc.b 0, 1
		dc.b $F0, $F, 0, $20, $FF, $F0
Map_Roll_2E:	dc.b 0, 1
		dc.b $F0, $F, 0, $30, $FF, $F0
Map_Roll_36:	dc.b 0, 1
		dc.b $F0, $F, 0, $40, $FF, $F0
		even
