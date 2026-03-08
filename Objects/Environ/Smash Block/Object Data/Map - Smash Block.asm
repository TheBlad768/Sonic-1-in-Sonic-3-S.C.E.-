; ---------------------------------------------------------------------------
; Sprite mappings - smashable green block (MZ)
; ---------------------------------------------------------------------------

Map_SmashBlock:
		dc.w Map_SmashBlock_4-Map_SmashBlock, Map_SmashBlock_12-Map_SmashBlock
Map_SmashBlock_4:	dc.b 0, 2
		dc.b $F0, $D, 0, 0, $FF, $F0
		dc.b 0, $D, 0, 0, $FF, $F0
Map_SmashBlock_12:	dc.b 0, 4
		dc.b $F0, 5, 0, 0, $FF, $F0
		dc.b $F0, 5, 0, 0, 0, 0
		dc.b 0, 5, 0, 0, $FF, $F0
		dc.b 0, 5, 0, 0, 0, 0
		even
