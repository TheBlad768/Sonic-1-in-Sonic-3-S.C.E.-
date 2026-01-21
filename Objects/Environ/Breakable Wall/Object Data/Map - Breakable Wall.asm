; ---------------------------------------------------------------------------
; Sprite mappings - breakable walls (GHZ, SLZ)
; ---------------------------------------------------------------------------

Map_BreakableWall:
		dc.w Map_BreakableWall_6-Map_BreakableWall
		dc.w Map_BreakableWall_38-Map_BreakableWall
		dc.w Map_BreakableWall_6A-Map_BreakableWall
Map_BreakableWall_6:	dc.b 0, 8
		dc.b $E0, 5, 0, 0, $FF, $F0
		dc.b $F0, 5, 0, 0, $FF, $F0
		dc.b 0, 5, 0, 0, $FF, $F0
		dc.b $10, 5, 0, 0, $FF, $F0
		dc.b $E0, 5, 0, 4, 0, 0
		dc.b $F0, 5, 0, 4, 0, 0
		dc.b 0, 5, 0, 4, 0, 0
		dc.b $10, 5, 0, 4, 0, 0
Map_BreakableWall_38:	dc.b 0, 8
		dc.b $E0, 5, 0, 4, $FF, $F0
		dc.b $F0, 5, 0, 4, $FF, $F0
		dc.b 0, 5, 0, 4, $FF, $F0
		dc.b $10, 5, 0, 4, $FF, $F0
		dc.b $E0, 5, 0, 4, 0, 0
		dc.b $F0, 5, 0, 4, 0, 0
		dc.b 0, 5, 0, 4, 0, 0
		dc.b $10, 5, 0, 4, 0, 0
Map_BreakableWall_6A:	dc.b 0, 8
		dc.b $E0, 5, 0, 4, $FF, $F0
		dc.b $F0, 5, 0, 4, $FF, $F0
		dc.b 0, 5, 0, 4, $FF, $F0
		dc.b $10, 5, 0, 4, $FF, $F0
		dc.b $E0, 5, 0, 8, 0, 0
		dc.b $F0, 5, 0, 8, 0, 0
		dc.b 0, 5, 0, 8, 0, 0
		dc.b $10, 5, 0, 8, 0, 0
		even
