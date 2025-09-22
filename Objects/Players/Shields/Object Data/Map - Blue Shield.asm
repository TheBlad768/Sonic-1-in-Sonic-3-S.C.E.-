; ---------------------------------------------------------------------------
; Sprite mappings - blue shield
; ---------------------------------------------------------------------------

Map_BlueShield:
Map_BlueShield_0: 	dc.w Map_BlueShield_C-Map_BlueShield
Map_BlueShield_2: 	dc.w Map_BlueShield_C-Map_BlueShield
Map_BlueShield_4: 	dc.w Map_BlueShield_C-Map_BlueShield
Map_BlueShield_6: 	dc.w Map_BlueShield_C-Map_BlueShield
Map_BlueShield_8: 	dc.w Map_BlueShield_C-Map_BlueShield
Map_BlueShield_A: 	dc.w Map_BlueShield_26-Map_BlueShield
Map_BlueShield_C: 	dc.b $0, $4
	dc.b $F0, $5, $0, $0, $FF, $F0
	dc.b $F0, $5, $8, $0, $0, $0
	dc.b $0, $5, $10, $0, $FF, $F0
	dc.b $0, $5, $18, $0, $0, $0
Map_BlueShield_26: 	dc.b $0, $4
	dc.b $E0, $B, $0, $0, $FF, $E8
	dc.b $E0, $B, $8, $0, $0, $0
	dc.b $0, $B, $10, $0, $FF, $E8
	dc.b $0, $B, $18, $0, $0, $0
	even