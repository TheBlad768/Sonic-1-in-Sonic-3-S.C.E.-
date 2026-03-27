; ---------------------------------------------------------------------------
; Sprite mappings - signpost
; ---------------------------------------------------------------------------

Map_Signpost:
Map_Signpost_0: 	dc.w Map_Signpost_10-Map_Signpost
Map_Signpost_2: 	dc.w Map_Signpost_1E-Map_Signpost
Map_Signpost_4: 	dc.w Map_Signpost_2C-Map_Signpost
Map_Signpost_6: 	dc.w Map_Signpost_3A-Map_Signpost
Map_Signpost_8: 	dc.w Map_Signpost_48-Map_Signpost
Map_Signpost_A: 	dc.w Map_Signpost_56-Map_Signpost
Map_Signpost_C: 	dc.w Map_Signpost_5E-Map_Signpost
Map_Signpost_E: 	dc.w Map_Signpost_66-Map_Signpost
Map_Signpost_10: 	dc.b $0, $2
	dc.b $F0, $B, $0, $0, $FF, $E8
	dc.b $F0, $B, $0, $C, $0, $0
Map_Signpost_1E: 	dc.b $0, $2
	dc.b $F0, $B, $0, $0, $FF, $E8
	dc.b $F0, $B, $0, $C, $0, $0
Map_Signpost_2C: 	dc.b $0, $2
	dc.b $F0, $B, $0, $0, $FF, $E8
	dc.b $F0, $B, $0, $C, $0, $0
Map_Signpost_3A: 	dc.b $0, $2
	dc.b $F0, $B, $0, $0, $FF, $E8
	dc.b $F0, $B, $8, $C, $0, $0
Map_Signpost_48: 	dc.b $0, $2
	dc.b $F0, $B, $0, $0, $FF, $E8
	dc.b $F0, $B, $8, $C, $0, $0
Map_Signpost_56: 	dc.b $0, $1
	dc.b $F0, $F, $0, $0, $FF, $F0
Map_Signpost_5E: 	dc.b $0, $1
	dc.b $F0, $3, $0, $0, $FF, $FC
Map_Signpost_66: 	dc.b $0, $1
	dc.b $F0, $F, $8, $0, $FF, $F0
	even
