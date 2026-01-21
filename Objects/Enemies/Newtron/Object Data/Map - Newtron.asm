; ---------------------------------------------------------------------------
; Sprite mappings - Newtron enemy (GHZ)
; ---------------------------------------------------------------------------

Map_Newt:
		dc.w Map_Newt_16-Map_Newt
		dc.w Map_Newt_2A-Map_Newt
		dc.w Map_Newt_3E-Map_Newt
		dc.w Map_Newt_52-Map_Newt
		dc.w Map_Newt_6C-Map_Newt
		dc.w Map_Newt_80-Map_Newt
		dc.w Map_Newt_8E-Map_Newt
		dc.w Map_Newt_A2-Map_Newt
		dc.w Map_Newt_B6-Map_Newt
		dc.w Map_Newt_CA-Map_Newt
		dc.w Map_Newt_DE-Map_Newt
Map_Newt_16:	dc.b 0, 3
		dc.b $EC, $D, 0, 0, $FF, $EC
		dc.b $F4, 0, 0, 8, 0, $C
		dc.b $FC, $E, 0, 9, $FF, $F4
Map_Newt_2A:	dc.b 0, 3
		dc.b $EC, 6, 0, $15, $FF, $EC
		dc.b $EC, 9, 0, $1B, $FF, $FC
		dc.b $FC, $A, 0, $21, $FF, $FC
Map_Newt_3E:	dc.b 0, 3
		dc.b $EC, 6, 0, $2A, $FF, $EC
		dc.b $EC, 9, 0, $1B, $FF, $FC
		dc.b $FC, $A, 0, $21, $FF, $FC
Map_Newt_52:	dc.b 0, 4
		dc.b $EC, 6, 0, $30, $FF, $EC
		dc.b $EC, 9, 0, $1B, $FF, $FC
		dc.b $FC, 9, 0, $36, $FF, $FC
		dc.b $C, 0, 0, $3C, 0, $C
Map_Newt_6C:	dc.b 0, 3
		dc.b $F4, $D, 0, $3D, $FF, $EC
		dc.b $FC, 0, 0, $20, 0, $C
		dc.b 4, 8, 0, $45, $FF, $FC
Map_Newt_80:	dc.b 0, 2
		dc.b $F8, $D, 0, $48, $FF, $EC
		dc.b $F8, 1, 0, $50, 0, $C
Map_Newt_8E:	dc.b 0, 3
		dc.b $F8, $D, 0, $48, $FF, $EC
		dc.b $F8, 1, 0, $50, 0, $C
		dc.b $FE, 0, 0, $52, 0, $14
Map_Newt_A2:	dc.b 0, 3
		dc.b $F8, $D, 0, $48, $FF, $EC
		dc.b $F8, 1, 0, $50, 0, $C
		dc.b $FE, 4, 0, $53, 0, $14
Map_Newt_B6:	dc.b 0, 3
		dc.b $F8, $D, 0, $48, $FF, $EC
		dc.b $F8, 1, 0, $50, 0, $C
		dc.b $FE, 0, $E0, $52, 0, $14
Map_Newt_CA:	dc.b 0, 3
		dc.b $F8, $D, 0, $48, $FF, $EC
		dc.b $F8, 1, 0, $50, 0, $C
		dc.b $FE, 4, $E0, $53, 0, $14
Map_Newt_DE:	dc.b 0, 0
		even
