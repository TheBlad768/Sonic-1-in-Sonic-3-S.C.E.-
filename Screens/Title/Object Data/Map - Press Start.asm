; ---------------------------------------------------------------------------
; Sprite mappings - "PRESS START BUTTON" and "TM" from title screen
; ---------------------------------------------------------------------------

Map_TPSB:
		dc.w Map_TPSB_2-Map_TPSB
Map_TPSB_2:
		dc.b 0, 6
		dc.b 0, $C, 0, $F0, 0, 0
		dc.b 0, 0, 0, $F3, 0, $20
		dc.b 0, 0, 0, $F3, 0, $30
		dc.b 0, $C, 0, $F4, 0, $38
		dc.b 0, 8, 0, $F8, 0, $60
		dc.b 0, 8, 0, $FB, 0, $78
	even
