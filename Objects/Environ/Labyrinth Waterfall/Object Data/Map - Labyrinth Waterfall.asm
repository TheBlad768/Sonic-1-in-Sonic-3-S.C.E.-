; ---------------------------------------------------------------------------
; Sprite mappings - waterfalls (LZ)
; ---------------------------------------------------------------------------

Map_Waterfall:
		dc.w Map_Waterfall_18-Map_Waterfall, Map_Waterfall_20-Map_Waterfall
		dc.w Map_Waterfall_2E-Map_Waterfall, Map_Waterfall_3C-Map_Waterfall
		dc.w Map_Waterfall_44-Map_Waterfall, Map_Waterfall_52-Map_Waterfall
		dc.w Map_Waterfall_5A-Map_Waterfall, Map_Waterfall_62-Map_Waterfall
		dc.w Map_Waterfall_6A-Map_Waterfall, Map_Waterfall_78-Map_Waterfall
		dc.w Map_Waterfall_86-Map_Waterfall, Map_Waterfall_94-Map_Waterfall
Map_Waterfall_18:	dc.b 0, 1
		dc.b $F0, 7, 0, 0, $FF, $F8
Map_Waterfall_20:	dc.b 0, 2
		dc.b $F8, 4, 0, 8, $FF, $FC
		dc.b 0, 8, 0, $A, $FF, $F4
Map_Waterfall_2E:	dc.b 0, 2
		dc.b $F8, 0, 0, 8, 0, 0
		dc.b 0, 4, 0, $D, $FF, $F8
Map_Waterfall_3C:	dc.b 0, 1
		dc.b $F8, 1, 0, $F, 0, 0
Map_Waterfall_44:	dc.b 0, 2
		dc.b $F8, 0, 0, 8, 0, 0
		dc.b 0, 4, 0, $D, $FF, $F8
Map_Waterfall_52:	dc.b 0, 1
		dc.b $F8, 1, 0, $11, 0, 0
Map_Waterfall_5A:	dc.b 0, 1
		dc.b $F8, 1, 0, $13, 0, 0
Map_Waterfall_62:	dc.b 0, 1
		dc.b $F0, 7, 0, $15, $FF, $F8
Map_Waterfall_6A:	dc.b 0, 2
		dc.b $F8, $C, 0, $1D, $FF, $F6
		dc.b 0, $C, 0, $21, $FF, $E8
Map_Waterfall_78:	dc.b 0, 2
		dc.b $F0, $B, 0, $25, $FF, $E8
		dc.b $F0, $B, 0, $31, 0, 0
Map_Waterfall_86:	dc.b 0, 2
		dc.b $F0, $B, 0, $3D, $FF, $E8
		dc.b $F0, $B, 0, $49, 0, 0
Map_Waterfall_94:	dc.b 0, 2
		dc.b $F0, $B, 0, $55, $FF, $E8
		dc.b $F0, $B, 0, $61, 0, 0
		even
