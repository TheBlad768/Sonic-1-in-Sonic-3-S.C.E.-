; ---------------------------------------------------------------------------
; Sprite mappings - switches (MZ, SYZ, LZ, SBZ)
; ---------------------------------------------------------------------------

Map_Button:
		dc.w Map_Button_8-Map_Button, Map_Button_16-Map_Button
		dc.w Map_Button_24-Map_Button, Map_Button_32-Map_Button
Map_Button_8:	dc.b 0, 2
		dc.b $F5, 5, 0, 0, $FF, $F0
		dc.b $F5, 5, 8, 0, 0, 0
Map_Button_16:	dc.b 0, 2
		dc.b $F5, 5, 0, 4, $FF, $F0
		dc.b $F5, 5, 8, 4, 0, 0
Map_Button_24:	dc.b 0, 2
		dc.b $F5, 5, $FF, $FC, $FF, $F0
		dc.b $F5, 5, 7, $FC, 0, 0
Map_Button_32:	dc.b 0, 2
		dc.b $F5, 5, 0, 4, $FF, $F0
		dc.b $F5, 5, 8, 4, 0, 0
		even
