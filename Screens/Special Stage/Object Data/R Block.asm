; ---------------------------------------------------------------------------
; Sprite mappings - special stage "R" block
; ---------------------------------------------------------------------------

Map_SS_R:
		dc.w Map_SS_R_6-Map_SS_R
		dc.w Map_SS_R_E-Map_SS_R
		dc.w Map_SS_R_16-Map_SS_R
Map_SS_R_6:
		dc.w 1
		dc.b $F4, $A, 0, 0, $FF, $F4
Map_SS_R_E:
		dc.w 1
		dc.b $F4, $A, 0, 9, $FF, $F4
Map_SS_R_16:
		dc.w 0
	even
