; ---------------------------------------------------------------------------
; Sprite mappings - pole that breaks (LZ)
; ---------------------------------------------------------------------------

Map_BreakablePole:
		dc.w Map_BreakablePole_4-Map_BreakablePole
		dc.w Map_BreakablePole_12-Map_BreakablePole
Map_BreakablePole_4:	dc.b 0, 2
		dc.b $E0, 3, 0, 0, $FF, $FC
		dc.b 0, 3, $10, 0, $FF, $FC
Map_BreakablePole_12:	dc.b 0, 4
		dc.b $E0, 1, 0, 0, $FF, $FC
		dc.b $F0, 5, 0, 4, $FF, $FC
		dc.b 0, 5, $10, 4, $FF, $FC
		dc.b $10, 1, $10, 0, $FF, $FC
		even
