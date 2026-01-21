; ---------------------------------------------------------------------------
; Sprite mappings - Yadrin enemy (SYZ)
; ---------------------------------------------------------------------------

Map_Yad:
		dc.w Map_Yad_C-Map_Yad, Map_Yad_2C-Map_Yad
		dc.w Map_Yad_4C-Map_Yad, Map_Yad_6C-Map_Yad
		dc.w Map_Yad_8C-Map_Yad, Map_Yad_AC-Map_Yad
Map_Yad_C:	dc.b 0, 5
		dc.b $F4, 8, 0, 0, $FF, $F4
		dc.b $FC, $E, 0, 3, $FF, $EC
		dc.b $EC, 4, 0, $F, $FF, $FC
		dc.b $F4, 2, 0, $11, 0, $C
		dc.b 4, 9, 0, $31, $FF, $FC
Map_Yad_2C:	dc.b 0, 5
		dc.b $F4, 8, 0, $14, $FF, $F4
		dc.b $FC, $E, 0, $17, $FF, $EC
		dc.b $EC, 4, 0, $F, $FF, $FC
		dc.b $F4, 2, 0, $11, 0, $C
		dc.b 4, 9, 0, $31, $FF, $FC
Map_Yad_4C:	dc.b 0, 5
		dc.b $F4, 9, 0, $23, $FF, $F4
		dc.b 4, $D, 0, $29, $FF, $EC
		dc.b $EC, 4, 0, $F, $FF, $FC
		dc.b $F4, 2, 0, $11, 0, $C
		dc.b 4, 9, 0, $31, $FF, $FC
Map_Yad_6C:	dc.b 0, 5
		dc.b $F4, 8, 0, 0, $FF, $F4
		dc.b $FC, $E, 0, 3, $FF, $EC
		dc.b $EC, 4, 0, $F, $FF, $FC
		dc.b $F4, 2, 0, $11, 0, $C
		dc.b 4, 9, 0, $37, $FF, $FC
Map_Yad_8C:	dc.b 0, 5
		dc.b $F4, 8, 0, $14, $FF, $F4
		dc.b $FC, $E, 0, $17, $FF, $EC
		dc.b $EC, 4, 0, $F, $FF, $FC
		dc.b $F4, 2, 0, $11, 0, $C
		dc.b 4, 9, 0, $37, $FF, $FC
Map_Yad_AC:	dc.b 0, 5
		dc.b $F4, 9, 0, $23, $FF, $F4
		dc.b 4, $D, 0, $29, $FF, $EC
		dc.b $EC, 4, 0, $F, $FF, $FC
		dc.b $F4, 2, 0, $11, 0, $C
		dc.b 4, 9, 0, $37, $FF, $FC
		even
