; ---------------------------------------------------------------------------
; Sprite mappings - blocks that Robotnik picks up (SYZ)
; ---------------------------------------------------------------------------

Map_BossSYZBlock:
		dc.w Map_BossSYZBlock_A-Map_BossSYZBlock
		dc.w Map_BossSYZBlock_12-Map_BossSYZBlock
		dc.w Map_BossSYZBlock_1A-Map_BossSYZBlock
		dc.w Map_BossSYZBlock_22-Map_BossSYZBlock
		dc.w Map_BossSYZBlock_2A-Map_BossSYZBlock
Map_BossSYZBlock_A:	dc.b 0, 1
		dc.b $F0, $F, 0, 0, $FF, $F0
Map_BossSYZBlock_12:	dc.b 0, 1
		dc.b $F0, 5, 0, $10, $FF, $F0
Map_BossSYZBlock_1A:	dc.b 0, 1
		dc.b $F0, 5, 0, $14, 0, 0
Map_BossSYZBlock_22:	dc.b 0, 1
		dc.b 0, 5, 0, $18, $FF, $F0
Map_BossSYZBlock_2A:	dc.b 0, 1
		dc.b 0, 5, 0, $1C, 0, 0
		even
