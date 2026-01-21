; ---------------------------------------------------------------------------
; Sprite mappings - platforms that move in circles (SLZ)
; ---------------------------------------------------------------------------

Map_Circ:
		dc.w Map_Circ_2-Map_Circ
Map_Circ_2:	dc.b 0, 2
		dc.b $F8, 9, 0, $51, $FF, $E8
		dc.b $F8, 9, 8, $51, 0, 0
	even
