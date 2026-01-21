; ---------------------------------------------------------------------------
; Sprite mappings - rotating disc that grabs Sonic (SBZ)
; ---------------------------------------------------------------------------

Map_Jun:
		dc.w Map_Jun_22-Map_Jun
		dc.w Map_Jun_48-Map_Jun
		dc.w Map_Jun_6E-Map_Jun
		dc.w Map_Jun_94-Map_Jun
		dc.w Map_Jun_BA-Map_Jun
		dc.w Map_Jun_E0-Map_Jun
		dc.w Map_Jun_106-Map_Jun
		dc.w Map_Jun_12C-Map_Jun
		dc.w Map_Jun_152-Map_Jun
		dc.w Map_Jun_178-Map_Jun
		dc.w Map_Jun_19E-Map_Jun
		dc.w Map_Jun_1C4-Map_Jun
		dc.w Map_Jun_1EA-Map_Jun
		dc.w Map_Jun_210-Map_Jun
		dc.w Map_Jun_236-Map_Jun
		dc.w Map_Jun_25C-Map_Jun
		dc.w Map_Jun_282-Map_Jun
Map_Jun_22:	dc.b 0, 6
		dc.b $E8, 5, 0, $22, $FF, $D0
		dc.b 8, 5, $10, $22, $FF, $D0
		dc.b $E8, $A, 0, 0, $FF, $C8
		dc.b $E8, $A, 8, 0, $FF, $E0
		dc.b 0, $A, $10, 0, $FF, $C8
		dc.b 0, $A, $18, 0, $FF, $E0
Map_Jun_48:	dc.b 0, 6
		dc.b $F8, 3, 0, $26, $FF, $D0
		dc.b $18, 5, 0, $2A, $FF, $D8
		dc.b $F6, $A, 0, 0, $FF, $CA
		dc.b $F6, $A, 8, 0, $FF, $E2
		dc.b $E, $A, $10, 0, $FF, $CA
		dc.b $E, $A, $18, 0, $FF, $E2
Map_Jun_6E:	dc.b 0, 6
		dc.b 0, 6, 0, $2E, $FF, $D0
		dc.b $20, 9, 0, $34, $FF, $E8
		dc.b 0, $A, 0, 0, $FF, $D0
		dc.b 0, $A, 8, 0, $FF, $E8
		dc.b $18, $A, $10, 0, $FF, $D0
		dc.b $18, $A, $18, 0, $FF, $E8
Map_Jun_94:	dc.b 0, 6
		dc.b 8, 7, 0, $3A, $FF, $D8
		dc.b $28, 8, 0, $42, $FF, $F0
		dc.b 6, $A, 0, 0, $FF, $DA
		dc.b 6, $A, 8, 0, $FF, $F2
		dc.b $1E, $A, $10, 0, $FF, $DA
		dc.b $1E, $A, $18, 0, $FF, $F2
Map_Jun_BA:	dc.b 0, 6
		dc.b $20, 5, 0, $45, $FF, $E8
		dc.b $20, 5, 8, $45, 0, 8
		dc.b 8, $A, 0, 0, $FF, $E8
		dc.b 8, $A, 8, 0, 0, 0
		dc.b $20, $A, $10, 0, $FF, $E8
		dc.b $20, $A, $18, 0, 0, 0
Map_Jun_E0:	dc.b 0, 6
		dc.b $28, 8, 8, $42, $FF, $F8
		dc.b 8, 7, 8, $3A, 0, $18
		dc.b 6, $A, 0, 0, $FF, $F6
		dc.b 6, $A, 8, 0, 0, $E
		dc.b $1E, $A, $10, 0, $FF, $F6
		dc.b $1E, $A, $18, 0, 0, $E
Map_Jun_106:	dc.b 0, 6
		dc.b $20, 9, 8, $34, 0, 0
		dc.b 0, 6, 8, $2E, 0, $20
		dc.b 0, $A, 0, 0, 0, 0
		dc.b 0, $A, 8, 0, 0, $18
		dc.b $18, $A, $10, 0, 0, 0
		dc.b $18, $A, $18, 0, 0, $18
Map_Jun_12C:	dc.b 0, 6
		dc.b $18, 5, 8, $2A, 0, $18
		dc.b $F8, 3, 8, $26, 0, $28
		dc.b $F6, $A, 0, 0, 0, 6
		dc.b $F6, $A, 8, 0, 0, $1E
		dc.b $E, $A, $10, 0, 0, 6
		dc.b $E, $A, $18, 0, 0, $1E
Map_Jun_152:	dc.b 0, 6
		dc.b $E8, 5, 8, $22, 0, $20
		dc.b 8, 5, $18, $22, 0, $20
		dc.b $E8, $A, 0, 0, 0, 8
		dc.b $E8, $A, 8, 0, 0, $20
		dc.b 0, $A, $10, 0, 0, 8
		dc.b 0, $A, $18, 0, 0, $20
Map_Jun_178:	dc.b 0, 6
		dc.b $D8, 5, $18, $2A, 0, $18
		dc.b $E8, 3, $18, $26, 0, $28
		dc.b $DA, $A, 0, 0, 0, 6
		dc.b $DA, $A, 8, 0, 0, $1E
		dc.b $F2, $A, $10, 0, 0, 6
		dc.b $F2, $A, $18, 0, 0, $1E
Map_Jun_19E:	dc.b 0, 6
		dc.b $D0, 9, $18, $34, 0, 0
		dc.b $E8, 6, $18, $2E, 0, $20
		dc.b $D0, $A, 0, 0, 0, 0
		dc.b $D0, $A, 8, 0, 0, $18
		dc.b $E8, $A, $10, 0, 0, 0
		dc.b $E8, $A, $18, 0, 0, $18
Map_Jun_1C4:	dc.b 0, 6
		dc.b $D0, 8, $18, $42, $FF, $F8
		dc.b $D8, 7, $18, $3A, 0, $18
		dc.b $CA, $A, 0, 0, $FF, $F6
		dc.b $CA, $A, 8, 0, 0, $E
		dc.b $E2, $A, $10, 0, $FF, $F6
		dc.b $E2, $A, $18, 0, 0, $E
Map_Jun_1EA:	dc.b 0, 6
		dc.b $D0, 5, $10, $45, $FF, $E8
		dc.b $D0, 5, $18, $45, 0, 8
		dc.b $C8, $A, 0, 0, $FF, $E8
		dc.b $C8, $A, 8, 0, 0, 0
		dc.b $E0, $A, $10, 0, $FF, $E8
		dc.b $E0, $A, $18, 0, 0, 0
Map_Jun_210:	dc.b 0, 6
		dc.b $D8, 7, $10, $3A, $FF, $D8
		dc.b $D0, 8, $10, $42, $FF, $F0
		dc.b $CA, $A, 0, 0, $FF, $DA
		dc.b $CA, $A, 8, 0, $FF, $F2
		dc.b $E2, $A, $10, 0, $FF, $DA
		dc.b $E2, $A, $18, 0, $FF, $F2
Map_Jun_236:	dc.b 0, 6
		dc.b $E8, 6, $10, $2E, $FF, $D0
		dc.b $D0, 9, $10, $34, $FF, $E8
		dc.b $D0, $A, 0, 0, $FF, $D0
		dc.b $D0, $A, 8, 0, $FF, $E8
		dc.b $E8, $A, $10, 0, $FF, $D0
		dc.b $E8, $A, $18, 0, $FF, $E8
Map_Jun_25C:	dc.b 0, 6
		dc.b $E8, 3, $10, $26, $FF, $D0
		dc.b $D8, 5, $10, $2A, $FF, $D8
		dc.b $DA, $A, 0, 0, $FF, $CA
		dc.b $DA, $A, 8, 0, $FF, $E2
		dc.b $F2, $A, $10, 0, $FF, $CA
		dc.b $F2, $A, $18, 0, $FF, $E2
Map_Jun_282:	dc.b 0, $C
		dc.b $C8, $D, 0, 9, $FF, $E0
		dc.b $D0, $A, 0, $11, $FF, $D0
		dc.b $E0, 7, 0, $1A, $FF, $C8
		dc.b $C8, $D, 8, 9, 0, 0
		dc.b $D0, $A, 8, $11, 0, $18
		dc.b $E0, 7, 8, $1A, 0, $28
		dc.b 0, 7, $10, $1A, $FF, $C8
		dc.b $18, $A, $10, $11, $FF, $D0
		dc.b $28, $D, $10, 9, $FF, $E0
		dc.b $28, $D, $18, 9, 0, 0
		dc.b $18, $A, $18, $11, 0, $18
		dc.b 0, 7, $18, $1A, 0, $28
		even
