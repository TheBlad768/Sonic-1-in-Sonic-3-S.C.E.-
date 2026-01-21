; ---------------------------------------------------------------------------
; Sprite mappings - spinning platforms (SBZ)
; ---------------------------------------------------------------------------

Map_Spin:
Map_Spin_0: 	dc.w Map_Spin_20-Map_Spin
Map_Spin_2: 	dc.w Map_Spin_2E-Map_Spin
Map_Spin_4: 	dc.w Map_Spin_3C-Map_Spin
Map_Spin_6: 	dc.w Map_Spin_4A-Map_Spin
Map_Spin_8: 	dc.w Map_Spin_58-Map_Spin
Map_Spin_A: 	dc.w Map_Spin_66-Map_Spin
Map_Spin_C: 	dc.w Map_Spin_74-Map_Spin
Map_Spin_E: 	dc.w Map_Spin_82-Map_Spin
Map_Spin_10: 	dc.w Map_Spin_90-Map_Spin
Map_Spin_12: 	dc.w Map_Spin_9E-Map_Spin
Map_Spin_14: 	dc.w Map_Spin_AC-Map_Spin
Map_Spin_16: 	dc.w Map_Spin_BA-Map_Spin
Map_Spin_18: 	dc.w Map_Spin_C8-Map_Spin
Map_Spin_1A: 	dc.w Map_Spin_D6-Map_Spin
Map_Spin_1C: 	dc.w Map_Spin_E4-Map_Spin
Map_Spin_1E: 	dc.w Map_Spin_F2-Map_Spin
Map_Spin_20: 	dc.b $0, $2
	dc.b $F8, $5, $0, $0, $FF, $F0
	dc.b $F8, $5, $8, $0, $0, $0
Map_Spin_2E: 	dc.b $0, $2
	dc.b $F0, $D, $0, $14, $FF, $F0
	dc.b $0, $D, $0, $1C, $FF, $F0
Map_Spin_3C: 	dc.b $0, $2
	dc.b $F0, $9, $0, $4, $FF, $F0
	dc.b $0, $9, $0, $A, $FF, $F8
Map_Spin_4A: 	dc.b $0, $2
	dc.b $F0, $9, $0, $24, $FF, $F0
	dc.b $0, $9, $0, $2A, $FF, $F8
Map_Spin_58: 	dc.b $0, $2
	dc.b $F0, $5, $0, $10, $FF, $F8
	dc.b $0, $5, $10, $10, $FF, $F8
Map_Spin_66: 	dc.b $0, $2
	dc.b $0, $9, $10, $24, $FF, $F0
	dc.b $F0, $9, $10, $2A, $FF, $F8
Map_Spin_74: 	dc.b $0, $2
	dc.b $0, $9, $10, $4, $FF, $F0
	dc.b $F0, $9, $10, $A, $FF, $F8
Map_Spin_82: 	dc.b $0, $2
	dc.b $0, $D, $10, $14, $FF, $F0
	dc.b $F0, $D, $10, $1C, $FF, $F0
Map_Spin_90: 	dc.b $0, $2
	dc.b $F8, $5, $10, $0, $FF, $F0
	dc.b $F8, $5, $18, $0, $0, $0
Map_Spin_9E: 	dc.b $0, $2
	dc.b $0, $D, $18, $14, $FF, $F0
	dc.b $F0, $D, $18, $1C, $FF, $F0
Map_Spin_AC: 	dc.b $0, $2
	dc.b $0, $9, $18, $4, $FF, $F8
	dc.b $F0, $9, $18, $A, $FF, $F0
Map_Spin_BA: 	dc.b $0, $2
	dc.b $0, $9, $18, $24, $FF, $F8
	dc.b $F0, $9, $18, $2A, $FF, $F0
Map_Spin_C8: 	dc.b $0, $2
	dc.b $F0, $5, $8, $10, $FF, $F8
	dc.b $0, $5, $18, $10, $FF, $F8
Map_Spin_D6: 	dc.b $0, $2
	dc.b $F0, $9, $8, $24, $FF, $F8
	dc.b $0, $9, $8, $2A, $FF, $F0
Map_Spin_E4: 	dc.b $0, $2
	dc.b $F0, $9, $8, $4, $FF, $F8
	dc.b $0, $9, $8, $A, $FF, $F0
Map_Spin_F2: 	dc.b $0, $2
	dc.b $F0, $D, $8, $14, $FF, $F0
	dc.b $0, $D, $8, $1C, $FF, $F0
	even
