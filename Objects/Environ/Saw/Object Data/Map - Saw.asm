; ---------------------------------------------------------------------------
; Sprite mappings - ground saws	and pizza cutters (SBZ)
; ---------------------------------------------------------------------------

Map_Saw:
		dc.w Map_Saw_8-Map_Saw, Map_Saw_34-Map_Saw
		dc.w Map_Saw_60-Map_Saw, Map_Saw_7A-Map_Saw
Map_Saw_8:	dc.b 0, 7
		dc.b $C4, 1, 0, $20, $FF, $FC
		dc.b $D4, 1, 0, $20, $FF, $FC
		dc.b $E4, 3, 0, $20, $FF, $FC
		dc.b $E0, $F, 0, 0, $FF, $E0
		dc.b $E0, $F, 8, 0, 0, 0
		dc.b 0, $F, $10, 0, $FF, $E0
		dc.b 0, $F, $18, 0, 0, 0
Map_Saw_34:	dc.b 0, 7
		dc.b $C4, 1, 0, $20, $FF, $FC
		dc.b $D4, 1, 0, $20, $FF, $FC
		dc.b $E4, 3, 0, $20, $FF, $FC
		dc.b $E0, $F, 0, $10, $FF, $E0
		dc.b $E0, $F, 8, $10, 0, 0
		dc.b 0, $F, $10, $10, $FF, $E0
		dc.b 0, $F, $18, $10, 0, 0
Map_Saw_60:	dc.b 0, 4
		dc.b $E0, $F, 0, 0, $FF, $E0
		dc.b $E0, $F, 8, 0, 0, 0
		dc.b 0, $F, $10, 0, $FF, $E0
		dc.b 0, $F, $18, 0, 0, 0
Map_Saw_7A:	dc.b 0, 4
		dc.b $E0, $F, 0, $10, $FF, $E0
		dc.b $E0, $F, 8, $10, 0, 0
		dc.b 0, $F, $10, $10, $FF, $E0
		dc.b 0, $F, $18, $10, 0, 0
		even
