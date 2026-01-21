; ---------------------------------------------------------------------------
; Sprite mappings - blocks (LZ)
; ---------------------------------------------------------------------------

Map_LBlock:
		dc.w Map_LBlock_8-Map_LBlock, Map_LBlock_10-Map_LBlock
		dc.w Map_LBlock_1E-Map_LBlock, Map_LBlock_26-Map_LBlock
Map_LBlock_8:	dc.b 0, 1
		dc.b $F0, $F, 0, 0, $FF, $F0
Map_LBlock_10:	dc.b 0, 2
		dc.b $F4, $E, 0, $69, $FF, $E0
		dc.b $F4, $E, 0, $75, 0, 0
Map_LBlock_1E:	dc.b 0, 1
		dc.b $F0, $F, 0, $81, $FF, $F0
Map_LBlock_26:	dc.b 0, 1
		dc.b $F0, $F, $FD, $FA, $FF, $F0
		even
