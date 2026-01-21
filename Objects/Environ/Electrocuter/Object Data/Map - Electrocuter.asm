; ---------------------------------------------------------------------------
; Sprite mappings - electrocution orbs (SBZ)
; ---------------------------------------------------------------------------

Map_Elec:
		dc.w Map_Elec_C-Map_Elec
		dc.w Map_Elec_1A-Map_Elec
		dc.w Map_Elec_2E-Map_Elec
		dc.w Map_Elec_4E-Map_Elec
		dc.w Map_Elec_68-Map_Elec
		dc.w Map_Elec_8E-Map_Elec
Map_Elec_C:	dc.b 0, 2
		dc.b $F8, 4, $60, 0, $FF, $F8
		dc.b 0, 6, $40, 2, $FF, $F8
Map_Elec_1A:	dc.b 0, 3
		dc.b $F8, 5, 0, 8, $FF, $F8
		dc.b $F8, 4, $60, 0, $FF, $F8
		dc.b 0, 6, $40, 2, $FF, $F8
Map_Elec_2E:	dc.b 0, 5
		dc.b $F8, 5, 0, 8, $FF, $F8
		dc.b $F8, 4, $60, 0, $FF, $F8
		dc.b 0, 6, $40, 2, $FF, $F8
		dc.b $F6, $D, 0, $C, 0, 8
		dc.b $F6, $D, 8, $C, $FF, $DC
Map_Elec_4E:	dc.b 0, 4
		dc.b $F8, 4, $60, 0, $FF, $F8
		dc.b 0, 6, $40, 2, $FF, $F8
		dc.b $F6, $D, 0, $C, 0, 8
		dc.b $F6, $D, 8, $C, $FF, $DC
Map_Elec_68:	dc.b 0, 6
		dc.b $F8, 4, $60, 0, $FF, $F8
		dc.b 0, 6, $40, 2, $FF, $F8
		dc.b $F6, $D, $10, $C, 0, 8
		dc.b $F6, $D, $18, $C, $FF, $DC
		dc.b $F6, $D, 0, $C, 0, $24
		dc.b $F6, $D, 8, $C, $FF, $C0
Map_Elec_8E:	dc.b 0, 4
		dc.b $F8, 4, $60, 0, $FF, $F8
		dc.b 0, 6, $40, 2, $FF, $F8
		dc.b $F6, $D, $10, $C, 0, $24
		dc.b $F6, $D, $18, $C, $FF, $C0
		even
