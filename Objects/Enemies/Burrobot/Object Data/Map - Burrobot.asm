; ---------------------------------------------------------------------------
; Sprite mappings - Burrobot enemy (LZ)
; ---------------------------------------------------------------------------

Map_Burrobot:
Map_Burrobot_0: 	dc.w Map_Burrobot_C-Map_Burrobot
Map_Burrobot_2: 	dc.w Map_Burrobot_1A-Map_Burrobot
Map_Burrobot_4: 	dc.w Map_Burrobot_28-Map_Burrobot
Map_Burrobot_6: 	dc.w Map_Burrobot_36-Map_Burrobot
Map_Burrobot_8: 	dc.w Map_Burrobot_44-Map_Burrobot
Map_Burrobot_A: 	dc.w Map_Burrobot_52-Map_Burrobot
Map_Burrobot_C: 	dc.b $0, $2
	dc.b $EC, $A, $0, $0, $FF, $F0
	dc.b $4, $9, $0, $9, $FF, $F4
Map_Burrobot_1A: 	dc.b $0, $2
	dc.b $EC, $A, $0, $F, $FF, $F0
	dc.b $4, $9, $0, $18, $FF, $F4
Map_Burrobot_28: 	dc.b $0, $2
	dc.b $E8, $A, $0, $1E, $FF, $F4
	dc.b $0, $A, $0, $27, $FF, $F4
Map_Burrobot_36: 	dc.b $0, $2
	dc.b $E8, $A, $0, $30, $FF, $F4
	dc.b $0, $A, $0, $39, $FF, $F4
Map_Burrobot_44: 	dc.b $0, $2
	dc.b $E8, $A, $0, $F, $FF, $F0
	dc.b $0, $A, $0, $42, $FF, $F4
Map_Burrobot_52: 	dc.b $0, $2
	dc.b $EC, $A, $0, $F, $FF, $F0
	dc.b $4, $9, $0, $9, $FF, $F4
	even
