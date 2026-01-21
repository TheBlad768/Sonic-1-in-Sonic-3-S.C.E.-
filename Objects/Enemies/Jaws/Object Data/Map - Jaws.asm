; ---------------------------------------------------------------------------
; Sprite mappings - Jaws enemy (LZ)
; ---------------------------------------------------------------------------

Map_Jaws:
		dc.w Map_Jaws_8-Map_Jaws, Map_Jaws_16-Map_Jaws
		dc.w Map_Jaws_24-Map_Jaws, Map_Jaws_32-Map_Jaws
Map_Jaws_8:	dc.b 0, 2
		dc.b $F4, $E, 0, 0, $FF, $F0
		dc.b $F5, 5, 0, $18, 0, $10
Map_Jaws_16:	dc.b 0, 2
		dc.b $F4, $E, 0, $C, $FF, $F0
		dc.b $F5, 5, 0, $1C, 0, $10
Map_Jaws_24:	dc.b 0, 2
		dc.b $F4, $E, 0, 0, $FF, $F0
		dc.b $F5, 5, $10, $18, 0, $10
Map_Jaws_32:	dc.b 0, 2
		dc.b $F4, $E, 0, $C, $FF, $F0
		dc.b $F5, 5, $10, $1C, 0, $10
		even
