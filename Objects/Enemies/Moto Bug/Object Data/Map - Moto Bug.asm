; ---------------------------------------------------------------------------
; Sprite mappings - Moto Bug enemy (GHZ)
; ---------------------------------------------------------------------------

Map_Moto:
		dc.w Map_Moto_E-Map_Moto
		dc.w Map_Moto_28-Map_Moto
		dc.w Map_Moto_42-Map_Moto
		dc.w Map_Moto_62-Map_Moto
		dc.w Map_Moto_6A-Map_Moto
		dc.w Map_Moto_72-Map_Moto
		dc.w Map_Moto_7A-Map_Moto
Map_Moto_E:	dc.b 0, 4
		dc.b $F0, $D, 0, 0, $FF, $EC
		dc.b 0, $C, 0, 8, $FF, $EC
		dc.b $F8, 1, 0, $C, 0, $C
		dc.b 8, 8, 0, $E, $FF, $F4
Map_Moto_28:	dc.b 0, 4
		dc.b $F1, $D, 0, 0, $FF, $EC
		dc.b 1, $C, 0, 8, $FF, $EC
		dc.b $F9, 1, 0, $C, 0, $C
		dc.b 9, 8, 0, $11, $FF, $F4
Map_Moto_42:	dc.b 0, 5
		dc.b $F0, $D, 0, 0, $FF, $EC
		dc.b 0, $C, 0, $14, $FF, $EC
		dc.b $F8, 1, 0, $C, 0, $C
		dc.b 8, 4, 0, $18, $FF, $EC
		dc.b 8, 4, 0, $12, $FF, $FC
Map_Moto_62:	dc.b 0, 1
		dc.b $FA, 0, 0, $1A, 0, $10
Map_Moto_6A:	dc.b 0, 1
		dc.b $FA, 0, 0, $1B, 0, $10
Map_Moto_72:	dc.b 0, 1
		dc.b $FA, 0, 0, $1C, 0, $10
Map_Moto_7A:	dc.b 0, 0
		even
