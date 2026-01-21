; ---------------------------------------------------------------------------
; Sprite mappings - Ball Hog enemy (SBZ)
; ---------------------------------------------------------------------------

Map_Hog:
		dc.w Map_Hog_C-Map_Hog, Map_Hog_1A-Map_Hog
		dc.w Map_Hog_28-Map_Hog, Map_Hog_36-Map_Hog
		dc.w Map_Hog_44-Map_Hog, Map_Hog_4C-Map_Hog
Map_Hog_C:	dc.b 0, 2
		dc.b $EF, 9, 0, 0, $FF, $F4
		dc.b $FF, $A, 0, 6, $FF, $F4
Map_Hog_1A:	dc.b 0, 2
		dc.b $EF, 9, 0, 0, $FF, $F4
		dc.b $FF, $A, 0, $F, $FF, $F4
Map_Hog_28:	dc.b 0, 2
		dc.b $F4, 9, 0, 0, $FF, $F4
		dc.b 4, 9, 0, $18, $FF, $F4
Map_Hog_36:	dc.b 0, 2
		dc.b $E4, 9, 0, 0, $FF, $F4
		dc.b $F4, $A, 0, $1E, $FF, $F4
Map_Hog_44:	dc.b 0, 1
		dc.b $F8, 5, 0, $27, $FF, $F8
Map_Hog_4C:	dc.b 0, 1
		dc.b $F8, 5, 0, $2B, $FF, $F8
		even
