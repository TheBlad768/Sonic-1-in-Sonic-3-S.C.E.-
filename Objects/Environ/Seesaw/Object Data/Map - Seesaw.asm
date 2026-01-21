; ---------------------------------------------------------------------------
; Sprite mappings - seesaws (SLZ)
; ---------------------------------------------------------------------------

Map_Seesaw:
		dc.w Map_Seesaw_8-Map_Seesaw
		dc.w Map_Seesaw_34-Map_Seesaw
		dc.w Map_Seesaw_8-Map_Seesaw
		dc.w Map_Seesaw_34-Map_Seesaw
Map_Seesaw_8:
		dc.w 7
		dc.b $D4, 6, 0, 0, $FF, $D3
		dc.b $DC, 6, 0, 6, $FF, $E3
		dc.b $E4, 4, 0, $C, $FF, $F3
		dc.b $EC, $D, 0, $E, $FF, $F3
		dc.b $FC, 8, 0, $16, $FF, $FB
		dc.b $F4, 6, 0, 6, 0, $13
		dc.b $FC, 5, 0, $19, 0, $23
Map_Seesaw_34:
		dc.w 4
		dc.b $E6, $A, 0, $1D, $FF, $D0
		dc.b $E6, $A, 0, $23, $FF, $E8
		dc.b $E6, $A, 8, $23, 0, 0
		dc.b $E6, $A, 8, $1D, 0, $18
	even
