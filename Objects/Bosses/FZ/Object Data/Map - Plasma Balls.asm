; ---------------------------------------------------------------------------
; Sprite mappings - energy balls (FZ)
; ---------------------------------------------------------------------------

Map_Plasma:
		dc.w Map_Plasma_16-Map_Plasma, Map_Plasma_24-Map_Plasma
		dc.w Map_Plasma_32-Map_Plasma, Map_Plasma_40-Map_Plasma
		dc.w Map_Plasma_4E-Map_Plasma, Map_Plasma_5C-Map_Plasma
		dc.w Map_Plasma_6A-Map_Plasma, Map_Plasma_72-Map_Plasma
		dc.w Map_Plasma_7A-Map_Plasma, Map_Plasma_88-Map_Plasma
		dc.w Map_Plasma_96-Map_Plasma
Map_Plasma_16:	dc.b 0, 2
		dc.b $F0, $D, 0, $7A, $FF, $F0
		dc.b 0, $D, $18, $7A, $FF, $F0
Map_Plasma_24:	dc.b 0, 2
		dc.b $F4, 6, 0, $82, $FF, $F4
		dc.b $F4, 2, $18, $82, 0, 4
Map_Plasma_32:	dc.b 0, 2
		dc.b $F8, 4, 0, $88, $FF, $F8
		dc.b 0, 4, $10, $88, $FF, $F8
Map_Plasma_40:	dc.b 0, 2
		dc.b $F8, 4, 0, $8A, $FF, $F8
		dc.b 0, 4, $10, $8A, $FF, $F8
Map_Plasma_4E:	dc.b 0, 2
		dc.b $F8, 4, 0, $8C, $FF, $F8
		dc.b 0, 4, $10, $8C, $FF, $F8
Map_Plasma_5C:	dc.b 0, 2
		dc.b $F4, 6, 0, $8E, $FF, $F4
		dc.b $F4, 2, $18, $8E, 0, 4
Map_Plasma_6A:	dc.b 0, 1
		dc.b $F8, 5, 0, $94, $FF, $F8
Map_Plasma_72:	dc.b 0, 1
		dc.b $F8, 5, 0, $98, $FF, $F8
Map_Plasma_7A:	dc.b 0, 2
		dc.b $F0, $D, 8, $7A, $FF, $F0
		dc.b 0, $D, $10, $7A, $FF, $F0
Map_Plasma_88:	dc.b 0, 2
		dc.b $F4, 6, $10, $82, $FF, $F4
		dc.b $F4, 2, 8, $82, 0, 4
Map_Plasma_96:	dc.b 0, 0
		even
