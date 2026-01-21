; ---------------------------------------------------------------------------
; Sprite mappings - energy ball launcher (FZ)
; ---------------------------------------------------------------------------

Map_PLaunch:
		dc.w Map_PLaunch_8-Map_PLaunch, Map_PLaunch_10-Map_PLaunch
		dc.w Map_PLaunch_18-Map_PLaunch, Map_PLaunch_20-Map_PLaunch
Map_PLaunch_8:	dc.b 0, 1
		dc.b $F8, 5, 0, $6E, $FF, $F8
Map_PLaunch_10:	dc.b 0, 1
		dc.b $F8, 5, 0, $76, $FF, $F8
Map_PLaunch_18:	dc.b 0, 1
		dc.b $F8, 5, 0, $72, $FF, $F8
Map_PLaunch_20:	dc.b 0, 1
		dc.b $F8, 5, $10, $72, $FF, $F8
		even
