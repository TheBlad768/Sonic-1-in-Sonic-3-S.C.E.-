; ---------------------------------------------------------------------------
; Sprite mappings - flapping door (LZ)
; ---------------------------------------------------------------------------

Map_FlapDoor:
		dc.w Map_FlapDoor_6-Map_FlapDoor
		dc.w Map_FlapDoor_14-Map_FlapDoor
		dc.w Map_FlapDoor_22-Map_FlapDoor
Map_FlapDoor_6:	dc.b 0, 2
		dc.b $E0, 7, 0, 0, $FF, $F8
		dc.b 0, 7, $10, 0, $FF, $F8
Map_FlapDoor_14:	dc.b 0, 2
		dc.b $DA, $F, 0, 8, $FF, $FB
		dc.b 6, $F, $10, 8, $FF, $FB
Map_FlapDoor_22:	dc.b 0, 2
		dc.b $D8, $D, 0, $18, 0, 0
		dc.b $18, $D, $10, $18, 0, 0
		even
