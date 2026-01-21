; ---------------------------------------------------------------------------
; Sprite mappings - chaos emeralds from the special stage results screen
; ---------------------------------------------------------------------------

Map_SSRC:
		dc.w Map_SSRC_E-Map_SSRC, Map_SSRC_16-Map_SSRC
		dc.w Map_SSRC_1E-Map_SSRC, Map_SSRC_26-Map_SSRC
		dc.w Map_SSRC_2E-Map_SSRC, Map_SSRC_36-Map_SSRC
		dc.w Map_SSRC_3E-Map_SSRC
Map_SSRC_E:	dc.b 0, 1
		dc.b $F8, 5, $20, 4, $FF, $F8
Map_SSRC_16:	dc.b 0, 1
		dc.b $F8, 5, 0, 0, $FF, $F8
Map_SSRC_1E:	dc.b 0, 1
		dc.b $F8, 5, $40, 4, $FF, $F8
Map_SSRC_26:	dc.b 0, 1
		dc.b $F8, 5, $60, 4, $FF, $F8
Map_SSRC_2E:	dc.b 0, 1
		dc.b $F8, 5, $20, 8, $FF, $F8
Map_SSRC_36:	dc.b 0, 1
		dc.b $F8, 5, $20, $C, $FF, $F8
Map_SSRC_3E:	dc.b 0, 0
		even
