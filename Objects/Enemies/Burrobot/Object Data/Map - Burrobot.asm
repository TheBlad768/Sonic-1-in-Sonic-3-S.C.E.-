; ---------------------------------------------------------------------------
; Sprite mappings - Burrobot enemy (LZ)
; ---------------------------------------------------------------------------

Map_Burro:
Map_Burro_0: 	dc.w Map_Burro_C-Map_Burro
Map_Burro_2: 	dc.w Map_Burro_1A-Map_Burro
Map_Burro_4: 	dc.w Map_Burro_28-Map_Burro
Map_Burro_6: 	dc.w Map_Burro_36-Map_Burro
Map_Burro_8: 	dc.w Map_Burro_44-Map_Burro
Map_Burro_A: 	dc.w Map_Burro_52-Map_Burro
Map_Burro_C: 	dc.b $0, $2
	dc.b $EC, $A, $0, $0, $FF, $F0
	dc.b $4, $9, $0, $9, $FF, $F4
Map_Burro_1A: 	dc.b $0, $2
	dc.b $EC, $A, $0, $F, $FF, $F0
	dc.b $4, $9, $0, $18, $FF, $F4
Map_Burro_28: 	dc.b $0, $2
	dc.b $E8, $A, $0, $1E, $FF, $F4
	dc.b $0, $A, $0, $27, $FF, $F4
Map_Burro_36: 	dc.b $0, $2
	dc.b $E8, $A, $0, $30, $FF, $F4
	dc.b $0, $A, $0, $39, $FF, $F4
Map_Burro_44: 	dc.b $0, $2
	dc.b $E8, $A, $0, $F, $FF, $F0
	dc.b $0, $A, $0, $42, $FF, $F4
Map_Burro_52: 	dc.b $0, $2
	dc.b $EC, $A, $0, $F, $FF, $F0
	dc.b $4, $9, $0, $9, $FF, $F4
	even
