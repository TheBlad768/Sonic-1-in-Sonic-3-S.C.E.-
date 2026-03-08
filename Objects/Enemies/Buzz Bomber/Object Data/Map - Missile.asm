; ---------------------------------------------------------------------------
; Sprite mappings - missile that Buzz Bomber throws
; ---------------------------------------------------------------------------

Map_Missile:
		dc.w Map_Missile_8-Map_Missile, Map_Missile_10-Map_Missile
		dc.w Map_Missile_18-Map_Missile, Map_Missile_20-Map_Missile
Map_Missile_8:	dc.b 0, 1
		dc.b $F8, 5, 0, $24, $FF, $F8
Map_Missile_10:	dc.b 0, 1
		dc.b $F8, 5, 0, $28, $FF, $F8
Map_Missile_18:	dc.b 0, 1
		dc.b $F8, 5, 0, $2C, $FF, $F8
Map_Missile_20:	dc.b 0, 1
		dc.b $F8, 5, 0, $33, $FF, $F8
		even
