; ---------------------------------------------------------------------------
; Sprite mappings - Orbinaut enemy (LZ, SLZ, SBZ)
; ---------------------------------------------------------------------------

Map_Orb:
		dc.w Map_Orb_8-Map_Orb
		dc.w Map_Orb_10-Map_Orb
		dc.w Map_Orb_18-Map_Orb
Map_Orb_8:	dc.b 0, 1
		dc.b $F4, $A, 0, 0, $FF, $F4
Map_Orb_10:	dc.b 0, 1
		dc.b $F4, $A, $20, 9, $FF, $F4
Map_Orb_18:	dc.b 0, 1
		dc.b $F4, $A, 0, $12, $FF, $F4
	even
