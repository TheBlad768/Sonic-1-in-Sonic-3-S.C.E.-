; ---------------------------------------------------------------------------
; Sprite mappings - edge wall (GHZ)
; ---------------------------------------------------------------------------

Map_EdgeWall:
		dc.w Map_EdgeWall_6-Map_EdgeWall
		dc.w Map_EdgeWall_20-Map_EdgeWall
		dc.w Map_EdgeWall_3A-Map_EdgeWall
Map_EdgeWall_6:	dc.b 0, 4
		dc.b $E0, 5, 0, 4, $FF, $F8
		dc.b $F0, 5, 0, 8, $FF, $F8
		dc.b 0, 5, 0, 8, $FF, $F8
		dc.b $10, 5, 0, 8, $FF, $F8
Map_EdgeWall_20:	dc.b 0, 4
		dc.b $E0, 5, 0, 8, $FF, $F8
		dc.b $F0, 5, 0, 8, $FF, $F8
		dc.b 0, 5, 0, 8, $FF, $F8
		dc.b $10, 5, 0, 8, $FF, $F8
Map_EdgeWall_3A:	dc.b 0, 4
		dc.b $E0, 5, 0, 0, $FF, $F8
		dc.b $F0, 5, 0, 0, $FF, $F8
		dc.b 0, 5, 0, 0, $FF, $F8
		dc.b $10, 5, 0, 0, $FF, $F8
		even
