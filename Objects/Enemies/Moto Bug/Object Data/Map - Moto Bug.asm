; ---------------------------------------------------------------------------
; Sprite mappings - Moto Bug enemy (GHZ)
; ---------------------------------------------------------------------------

Map_MotoBug:
		dc.w Map_MotoBug_E-Map_MotoBug
		dc.w Map_MotoBug_28-Map_MotoBug
		dc.w Map_MotoBug_42-Map_MotoBug
		dc.w Map_MotoBug_62-Map_MotoBug
		dc.w Map_MotoBug_6A-Map_MotoBug
		dc.w Map_MotoBug_72-Map_MotoBug
		dc.w Map_MotoBug_7A-Map_MotoBug
Map_MotoBug_E:	dc.b 0, 4
		dc.b $F0, $D, 0, 0, $FF, $EC
		dc.b 0, $C, 0, 8, $FF, $EC
		dc.b $F8, 1, 0, $C, 0, $C
		dc.b 8, 8, 0, $E, $FF, $F4
Map_MotoBug_28:	dc.b 0, 4
		dc.b $F1, $D, 0, 0, $FF, $EC
		dc.b 1, $C, 0, 8, $FF, $EC
		dc.b $F9, 1, 0, $C, 0, $C
		dc.b 9, 8, 0, $11, $FF, $F4
Map_MotoBug_42:	dc.b 0, 5
		dc.b $F0, $D, 0, 0, $FF, $EC
		dc.b 0, $C, 0, $14, $FF, $EC
		dc.b $F8, 1, 0, $C, 0, $C
		dc.b 8, 4, 0, $18, $FF, $EC
		dc.b 8, 4, 0, $12, $FF, $FC
Map_MotoBug_62:	dc.b 0, 1
		dc.b $FA, 0, 0, $1A, 0, $10
Map_MotoBug_6A:	dc.b 0, 1
		dc.b $FA, 0, 0, $1B, 0, $10
Map_MotoBug_72:	dc.b 0, 1
		dc.b $FA, 0, 0, $1C, 0, $10
Map_MotoBug_7A:	dc.b 0, 0
		even
