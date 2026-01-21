; ---------------------------------------------------------------------------
; Sprite mappings - fire balls (MZ, SLZ)
; ---------------------------------------------------------------------------

Map_Fire:
Map_Fire_0: 	dc.w Map_Fire_14-Map_Fire
Map_Fire_2: 	dc.w Map_Fire_1C-Map_Fire
Map_Fire_4: 	dc.w Map_Fire_24-Map_Fire
Map_Fire_6: 	dc.w Map_Fire_2C-Map_Fire
Map_Fire_8: 	dc.w Map_Fire_34-Map_Fire
Map_Fire_A: 	dc.w Map_Fire_3C-Map_Fire
Map_Fire_C: 	dc.w Map_Fire_44-Map_Fire
Map_Fire_E: 	dc.w Map_Fire_4C-Map_Fire
Map_Fire_10: 	dc.w Map_Fire_54-Map_Fire
Map_Fire_12: 	dc.w Map_Fire_5C-Map_Fire
Map_Fire_14: 	dc.b $0, $1
	dc.b $E8, $7, $0, $0, $FF, $F8
Map_Fire_1C: 	dc.b $0, $1
	dc.b $E8, $7, $8, $0, $FF, $F8
Map_Fire_24: 	dc.b $0, $1
	dc.b $E8, $7, $0, $8, $FF, $F8
Map_Fire_2C: 	dc.b $0, $1
	dc.b $E8, $7, $8, $8, $FF, $F8
Map_Fire_34: 	dc.b $0, $1
	dc.b $F0, $6, $0, $10, $FF, $F8
Map_Fire_3C: 	dc.b $0, $1
	dc.b $F8, $D, $0, $16, $FF, $E8
Map_Fire_44: 	dc.b $0, $1
	dc.b $F8, $D, $10, $16, $FF, $E8
Map_Fire_4C: 	dc.b $0, $1
	dc.b $F8, $D, $0, $1E, $FF, $E8
Map_Fire_54: 	dc.b $0, $1
	dc.b $F8, $D, $10, $1E, $FF, $E8
Map_Fire_5C: 	dc.b $0, $1
	dc.b $F8, $9, $0, $26, $FF, $F0
	even
