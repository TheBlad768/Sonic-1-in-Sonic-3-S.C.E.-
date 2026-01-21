; ---------------------------------------------------------------------------
; Sprite mappings - gargoyle head (LZ)
; ---------------------------------------------------------------------------

Map_Gar:
		dc.w Map_Gar_8-Map_Gar
		dc.w Map_Gar_8-Map_Gar
		dc.w Map_Gar_30-Map_Gar
		dc.w Map_Gar_38-Map_Gar
Map_Gar_8:	dc.b 0, 3
		dc.b $F0, 4, 0, 0, 0, 0
		dc.b $F8, $D, 0, 2, $FF, $F0
		dc.b 8, 8, 0, $A, $FF, $F8
Map_Gar_30:	dc.b 0, 1
		dc.b $FC, 4, 0, $D, $FF, $F8
Map_Gar_38:	dc.b 0, 1
		dc.b $FC, 4, 0, $F, $FF, $F8
		even
