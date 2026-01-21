; ---------------------------------------------------------------------------
; Sprite mappings - pushable blocks (MZ, LZ)
; ---------------------------------------------------------------------------

Map_Push:
		dc.w Map_Push_4-Map_Push, Map_Push_C-Map_Push
Map_Push_4:	dc.b 0, 1
		dc.b $F0, $F, 0, 8, $FF, $F0
Map_Push_C:	dc.b 0, 4
		dc.b $F0, $F, 0, 8, $FF, $C0
		dc.b $F0, $F, 0, 8, $FF, $E0
		dc.b $F0, $F, 0, 8, 0, 0
		dc.b $F0, $F, 0, 8, 0, $20
		even
