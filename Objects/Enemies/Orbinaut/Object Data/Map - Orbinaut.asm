; ---------------------------------------------------------------------------
; Sprite mappings - Orbinaut enemy (LZ, SLZ, SBZ)
; ---------------------------------------------------------------------------

Map_Orbinaut:
		dc.w Map_Orbinaut_8-Map_Orbinaut
		dc.w Map_Orbinaut_10-Map_Orbinaut
		dc.w Map_Orbinaut_18-Map_Orbinaut
Map_Orbinaut_8:	dc.b 0, 1
		dc.b $F4, $A, 0, 0, $FF, $F4
Map_Orbinaut_10:	dc.b 0, 1
		dc.b $F4, $A, $20, 9, $FF, $F4
Map_Orbinaut_18:	dc.b 0, 1
		dc.b $F4, $A, 0, $12, $FF, $F4
	even
