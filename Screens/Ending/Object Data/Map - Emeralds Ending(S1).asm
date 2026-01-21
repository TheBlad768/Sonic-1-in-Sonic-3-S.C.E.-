; ---------------------------------------------------------------------------
; Sprite mappings - chaos emeralds on the ending sequence
; ---------------------------------------------------------------------------

Map_ECha:
		dc.w Map_ECha_E-Map_ECha, Map_ECha_16-Map_ECha
		dc.w Map_ECha_1E-Map_ECha, Map_ECha_26-Map_ECha
		dc.w Map_ECha_2E-Map_ECha, Map_ECha_36-Map_ECha
		dc.w Map_ECha_3E-Map_ECha
Map_ECha_E:	dc.b 0, 1
		dc.b $F8, 5, $60, 4, $FF, $F8
Map_ECha_16:	dc.b 0, 1
		dc.b $F8, 5, $40, 8, $FF, $F8
Map_ECha_1E:	dc.b 0, 1
		dc.b $F8, 5, $20, $10, $FF, $F8
Map_ECha_26:	dc.b 0, 1
		dc.b $F8, 5, $40, $C, $FF, $F8
Map_ECha_2E:	dc.b 0, 1
		dc.b $F8, 5, 0, 0, $FF, $F8
Map_ECha_36:	dc.b 0, 1
		dc.b $F8, 5, 0, $14, $FF, $F8
Map_ECha_3E:	dc.b 0, 1
		dc.b $F8, 5, $60, $18, $FF, $F8
		even
