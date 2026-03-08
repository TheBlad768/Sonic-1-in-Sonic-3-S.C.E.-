; ---------------------------------------------------------------------------
; Sprite mappings - moving blocks (MZ, SBZ)
; ---------------------------------------------------------------------------

Map_MovingBlock:
		dc.w Map_MovingBlock_A-Map_MovingBlock, Map_MovingBlock_12-Map_MovingBlock
		dc.w Map_MovingBlock_20-Map_MovingBlock, Map_MovingBlock_3A-Map_MovingBlock
		dc.w Map_MovingBlock_54-Map_MovingBlock
Map_MovingBlock_A:	dc.b 0, 1
		dc.b $F8, $F, 0, 8, $FF, $F0
Map_MovingBlock_12:	dc.b 0, 2
		dc.b $F8, $F, 0, 8, $FF, $E0
		dc.b $F8, $F, 0, 8, 0, 0
Map_MovingBlock_20:	dc.b 0, 4
		dc.b $F8, $C, $20, 0, $FF, $E0
		dc.b 0, $D, 0, 4, $FF, $E0
		dc.b $F8, $C, $20, 0, 0, 0
		dc.b 0, $D, 0, 4, 0, 0
Map_MovingBlock_3A:	dc.b 0, 4
		dc.b $F8, $E, 0, 0, $FF, $C0
		dc.b $F8, $E, 0, 3, $FF, $E0
		dc.b $F8, $E, 0, 3, 0, 0
		dc.b $F8, $E, 8, 0, 0, $20
Map_MovingBlock_54:	dc.b 0, 3
		dc.b $F8, $F, 0, 8, $FF, $D0
		dc.b $F8, $F, 0, 8, $FF, $F0
		dc.b $F8, $F, 0, 8, 0, $10
		even
