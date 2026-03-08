; ---------------------------------------------------------------------------
; Sprite mappings - gargoyle head (LZ)
; ---------------------------------------------------------------------------

Map_Gargoyle:
		dc.w Map_Gargoyle_8-Map_Gargoyle
		dc.w Map_Gargoyle_8-Map_Gargoyle
		dc.w Map_Gargoyle_30-Map_Gargoyle
		dc.w Map_Gargoyle_38-Map_Gargoyle
Map_Gargoyle_8:	dc.b 0, 3
		dc.b $F0, 4, 0, 0, 0, 0
		dc.b $F8, $D, 0, 2, $FF, $F0
		dc.b 8, 8, 0, $A, $FF, $F8
Map_Gargoyle_30:	dc.b 0, 1
		dc.b $FC, 4, 0, $D, $FF, $F8
Map_Gargoyle_38:	dc.b 0, 1
		dc.b $FC, 4, 0, $F, $FF, $F8
		even
