; ---------------------------------------------------------------------------
; Sprite mappings - Splats enemy (MZ)
; ---------------------------------------------------------------------------

Map_Splats:
Map_Splats_0: 	dc.w Map_Splats_4-Map_Splats
Map_Splats_2: 	dc.w Map_Splats_12-Map_Splats
Map_Splats_4: 	dc.b $0, $2
	dc.b $EC, $B, $0, $0, $FF, $F4
	dc.b $C, $8, $0, $C, $FF, $F4
Map_Splats_12: 	dc.b $0, $2
	dc.b $EC, $B, $0, $F, $FF, $F4
	dc.b $C, $4, $0, $1B, $FF, $FB
	even
