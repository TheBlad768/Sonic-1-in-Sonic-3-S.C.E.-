; ---------------------------------------------------------------------------
; Sprite mappings - lava balls (MZ, SLZ)
; ---------------------------------------------------------------------------

Map_LavaBall:
Map_LavaBall_0: 	dc.w Map_LavaBall_14-Map_LavaBall
Map_LavaBall_2: 	dc.w Map_LavaBall_1C-Map_LavaBall
Map_LavaBall_4: 	dc.w Map_LavaBall_24-Map_LavaBall
Map_LavaBall_6: 	dc.w Map_LavaBall_2C-Map_LavaBall
Map_LavaBall_8: 	dc.w Map_LavaBall_34-Map_LavaBall
Map_LavaBall_A: 	dc.w Map_LavaBall_3C-Map_LavaBall
Map_LavaBall_C: 	dc.w Map_LavaBall_44-Map_LavaBall
Map_LavaBall_E: 	dc.w Map_LavaBall_4C-Map_LavaBall
Map_LavaBall_10: 	dc.w Map_LavaBall_54-Map_LavaBall
Map_LavaBall_12: 	dc.w Map_LavaBall_5C-Map_LavaBall
Map_LavaBall_14: 	dc.b $0, $1
	dc.b $E8, $7, $0, $0, $FF, $F8
Map_LavaBall_1C: 	dc.b $0, $1
	dc.b $E8, $7, $8, $0, $FF, $F8
Map_LavaBall_24: 	dc.b $0, $1
	dc.b $E8, $7, $0, $8, $FF, $F8
Map_LavaBall_2C: 	dc.b $0, $1
	dc.b $E8, $7, $8, $8, $FF, $F8
Map_LavaBall_34: 	dc.b $0, $1
	dc.b $F0, $6, $0, $10, $FF, $F8
Map_LavaBall_3C: 	dc.b $0, $1
	dc.b $F8, $D, $0, $16, $FF, $E8
Map_LavaBall_44: 	dc.b $0, $1
	dc.b $F8, $D, $10, $16, $FF, $E8
Map_LavaBall_4C: 	dc.b $0, $1
	dc.b $F8, $D, $0, $1E, $FF, $E8
Map_LavaBall_54: 	dc.b $0, $1
	dc.b $F8, $D, $10, $1E, $FF, $E8
Map_LavaBall_5C: 	dc.b $0, $1
	dc.b $F8, $9, $0, $26, $FF, $F0
	even
