; ---------------------------------------------------------------------------
; Sprite mappings - walking bomb enemy (SLZ, SBZ)
; ---------------------------------------------------------------------------

Map_Bomb:
		dc.w Map_Bomb_18-Map_Bomb, Map_Bomb_2C-Map_Bomb
		dc.w Map_Bomb_40-Map_Bomb, Map_Bomb_54-Map_Bomb
		dc.w Map_Bomb_68-Map_Bomb, Map_Bomb_7C-Map_Bomb
		dc.w Map_Bomb_90-Map_Bomb, Map_Bomb_9E-Map_Bomb
		dc.w Map_Bomb_AC-Map_Bomb, Map_Bomb_B4-Map_Bomb
		dc.w Map_Bomb_BC-Map_Bomb, Map_Bomb_C4-Map_Bomb
Map_Bomb_18:	dc.b 0, 3
		dc.b $F1, $A, 0, 0, $FF, $F4
		dc.b 9, 8, 0, $12, $FF, $F4
		dc.b $E7, 1, 0, $21, $FF, $FC
Map_Bomb_2C:	dc.b 0, 3
		dc.b $F1, $A, 0, 9, $FF, $F4
		dc.b 9, 8, 0, $12, $FF, $F4
		dc.b $E7, 1, 0, $21, $FF, $FC
Map_Bomb_40:	dc.b 0, 3
		dc.b $F0, $A, 0, 0, $FF, $F4
		dc.b 8, 8, 0, $15, $FF, $F4
		dc.b $E6, 1, 0, $21, $FF, $FC
Map_Bomb_54:	dc.b 0, 3
		dc.b $F1, $A, 0, 9, $FF, $F4
		dc.b 9, 8, 0, $18, $FF, $F4
		dc.b $E7, 1, 0, $21, $FF, $FC
Map_Bomb_68:	dc.b 0, 3
		dc.b $F0, $A, 0, 0, $FF, $F4
		dc.b 8, 8, 0, $1B, $FF, $F4
		dc.b $E6, 1, 0, $21, $FF, $FC
Map_Bomb_7C:	dc.b 0, 3
		dc.b $F1, $A, 0, 9, $FF, $F4
		dc.b 9, 8, 0, $1E, $FF, $F4
		dc.b $E7, 1, 0, $21, $FF, $FC
Map_Bomb_90:	dc.b 0, 2
		dc.b $F1, $A, 0, 0, $FF, $F4
		dc.b 9, 8, 0, $12, $FF, $F4
Map_Bomb_9E:	dc.b 0, 2
		dc.b $F1, $A, 0, 9, $FF, $F4
		dc.b 9, 8, 0, $12, $FF, $F4
Map_Bomb_AC:	dc.b 0, 1
		dc.b $E7, 1, 0, $23, $FF, $FC
Map_Bomb_B4:	dc.b 0, 1
		dc.b $E7, 1, 0, $25, $FF, $FC
Map_Bomb_BC:	dc.b 0, 1
		dc.b $FC, 0, 0, $27, $FF, $FC
Map_Bomb_C4:	dc.b 0, 1
		dc.b $FC, 0, 0, $28, $FF, $FC
		even
