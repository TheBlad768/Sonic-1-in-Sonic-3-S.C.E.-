; ---------------------------------------------------------------------------
; Sprite mappings - Crabmeat enemy (GHZ, SYZ)
; ---------------------------------------------------------------------------

Map_Crab:
Map_Crab_0: 	dc.w Map_Crab_14-Map_Crab
Map_Crab_2: 	dc.w Map_Crab_2E-Map_Crab
Map_Crab_4: 	dc.w Map_Crab_48-Map_Crab
Map_Crab_6: 	dc.w Map_Crab_62-Map_Crab
Map_Crab_8: 	dc.w Map_Crab_7C-Map_Crab
Map_Crab_A: 	dc.w Map_Crab_96-Map_Crab
Map_Crab_C: 	dc.w Map_Crab_B0-Map_Crab
Map_Crab_E: 	dc.w Map_Crab_CA-Map_Crab
Map_Crab_10: 	dc.w Map_Crab_F0-Map_Crab
Map_Crab_12: 	dc.w Map_Crab_F8-Map_Crab
Map_Crab_14: 	dc.b $0, $4
	dc.b $F0, $9, $0, $0, $FF, $E8
	dc.b $F0, $9, $8, $0, $0, $0
	dc.b $0, $5, $0, $6, $FF, $F0
	dc.b $0, $5, $8, $6, $0, $0
Map_Crab_2E: 	dc.b $0, $4
	dc.b $F0, $9, $0, $A, $FF, $E8
	dc.b $F0, $9, $0, $10, $0, $0
	dc.b $0, $5, $0, $16, $FF, $F0
	dc.b $0, $9, $0, $1A, $0, $0
Map_Crab_48: 	dc.b $0, $4
	dc.b $EC, $9, $0, $A, $FF, $E8
	dc.b $EC, $9, $0, $10, $0, $0
	dc.b $FC, $9, $0, $26, $0, $0
	dc.b $FC, $6, $0, $2C, $FF, $F0
Map_Crab_62: 	dc.b $0, $4
	dc.b $EC, $9, $0, $0, $FF, $E8
	dc.b $EC, $9, $8, $0, $0, $0
	dc.b $FC, $5, $8, $6, $0, $0
	dc.b $FC, $6, $0, $20, $FF, $F0
Map_Crab_7C: 	dc.b $0, $4
	dc.b $F0, $9, $8, $A, $0, $0
	dc.b $F0, $9, $8, $10, $FF, $E8
	dc.b $0, $5, $8, $16, $0, $0
	dc.b $0, $9, $8, $1A, $FF, $E8
Map_Crab_96: 	dc.b $0, $4
	dc.b $EC, $9, $8, $A, $0, $0
	dc.b $EC, $9, $8, $10, $FF, $E8
	dc.b $FC, $9, $8, $26, $FF, $E8
	dc.b $FC, $6, $8, $2C, $0, $0
Map_Crab_B0: 	dc.b $0, $4
	dc.b $EC, $9, $8, $0, $0, $0
	dc.b $EC, $9, $0, $0, $FF, $E8
	dc.b $FC, $5, $0, $6, $FF, $F0
	dc.b $FC, $6, $8, $20, $0, $0
Map_Crab_CA: 	dc.b $0, $6
	dc.b $F0, $4, $0, $32, $FF, $F0
	dc.b $F0, $4, $8, $32, $0, $0
	dc.b $F8, $9, $0, $34, $FF, $E8
	dc.b $F8, $9, $8, $34, $0, $0
	dc.b $8, $4, $0, $3A, $FF, $F0
	dc.b $8, $4, $8, $3A, $0, $0
Map_Crab_F0: 	dc.b $0, $1
	dc.b $F8, $5, $0, $3C, $FF, $F8
Map_Crab_F8: 	dc.b $0, $1
	dc.b $F8, $5, $0, $40, $FF, $F8
	even
