; ---------------------------------------------------------------------------
; Sprite mappings - pushable blocks (MZ, LZ)
; ---------------------------------------------------------------------------

Map_PushableBlock:
		dc.w Map_PushableBlock_4-Map_PushableBlock, Map_PushableBlock_C-Map_PushableBlock
Map_PushableBlock_4:	dc.b 0, 1
		dc.b $F0, $F, 0, 8, $FF, $F0
Map_PushableBlock_C:	dc.b 0, 4
		dc.b $F0, $F, 0, 8, $FF, $C0
		dc.b $F0, $F, 0, 8, $FF, $E0
		dc.b $F0, $F, 0, 8, 0, 0
		dc.b $F0, $F, 0, 8, 0, $20
		even
