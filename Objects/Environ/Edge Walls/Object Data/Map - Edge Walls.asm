; ---------------------------------------------------------------------------
; Sprite mappings - walls (GHZ)
; ---------------------------------------------------------------------------

Map_EdgeWalls:
		dc.w Map_EdgeWalls_6-Map_EdgeWalls
		dc.w Map_EdgeWalls_20-Map_EdgeWalls
		dc.w Map_EdgeWalls_3A-Map_EdgeWalls
Map_EdgeWalls_6:	dc.b 0, 4
		dc.b $E0, 5, 0, 4, $FF, $F8
		dc.b $F0, 5, 0, 8, $FF, $F8
		dc.b 0, 5, 0, 8, $FF, $F8
		dc.b $10, 5, 0, 8, $FF, $F8
Map_EdgeWalls_20:	dc.b 0, 4
		dc.b $E0, 5, 0, 8, $FF, $F8
		dc.b $F0, 5, 0, 8, $FF, $F8
		dc.b 0, 5, 0, 8, $FF, $F8
		dc.b $10, 5, 0, 8, $FF, $F8
Map_EdgeWalls_3A:	dc.b 0, 4
		dc.b $E0, 5, 0, 0, $FF, $F8
		dc.b $F0, 5, 0, 0, $FF, $F8
		dc.b 0, 5, 0, 0, $FF, $F8
		dc.b $10, 5, 0, 0, $FF, $F8
		even
