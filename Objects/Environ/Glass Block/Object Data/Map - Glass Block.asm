; ---------------------------------------------------------------------------
; Sprite mappings - large green glassy blocks (MZ)
; ---------------------------------------------------------------------------

Map_Glass:
		dc.w Map_Glass_6-Map_Glass
		dc.w Map_Glass_6-Map_Glass		; multi-draw
		dc.w Map_Glass_50-Map_Glass
		dc.w Map_Glass_5E-Map_Glass
Map_Glass_6:	dc.b 0, $C
		dc.b $B8, $C, 0, 0, $FF, $E0
		dc.b $B8, $C, 8, 0, 0, 0
		dc.b $C0, $F, 0, 4, $FF, $E0
		dc.b $C0, $F, 8, 4, 0, 0
		dc.b $E0, $F, 0, 4, $FF, $E0
		dc.b $E0, $F, 8, 4, 0, 0
		dc.b 0, $F, 0, 4, $FF, $E0
		dc.b 0, $F, 8, 4, 0, 0
		dc.b $20, $F, 0, 4, $FF, $E0
		dc.b $20, $F, 8, 4, 0, 0
		dc.b $40, $C, $10, 0, $FF, $E0
		dc.b $40, $C, $18, 0, 0, 0
Map_Glass_50:	dc.b 0, 2
		dc.b 8, 6, 0, $14, $FF, $F0
		dc.b 0, 6, 0, $14, 0, 0
Map_Glass_5E:	dc.b 0, $A
		dc.b $C8, $C, 0, 0, $FF, $E0
		dc.b $C8, $C, 8, 0, 0, 0
		dc.b $D0, $F, 0, 4, $FF, $E0
		dc.b $D0, $F, 8, 4, 0, 0
		dc.b $F0, $F, 0, 4, $FF, $E0
		dc.b $F0, $F, 8, 4, 0, 0
		dc.b $10, $F, 0, 4, $FF, $E0
		dc.b $10, $F, 8, 4, 0, 0
		dc.b $30, $C, $10, 0, $FF, $E0
		dc.b $30, $C, $18, 0, 0, 0
		even
