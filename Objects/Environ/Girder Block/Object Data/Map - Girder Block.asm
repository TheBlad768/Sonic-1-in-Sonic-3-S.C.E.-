; ---------------------------------------------------------------------------
; Sprite mappings - large girder block (SBZ)
; ---------------------------------------------------------------------------

Map_Girder:
		dc.w Map_Girder_2-Map_Girder
Map_Girder_2:
		dc.b 0, $C
		dc.b $E8, $E, 0, 0, $FF, $A0
		dc.b 0, $E, $10, 0, $FF, $A0
		dc.b $E8, $E, 0, 6, $FF, $C0
		dc.b 0, $E, $10, 6, $FF, $C0
		dc.b $E8, $E, 0, 6, $FF, $E0
		dc.b 0, $E, $10, 6, $FF, $E0
		dc.b $E8, $E, 0, 6, 0, 0
		dc.b 0, $E, $10, 6, 0, 0
		dc.b $E8, $E, 0, 6, 0, $20
		dc.b 0, $E, $10, 6, 0, $20
		dc.b $E8, $E, 0, 6, 0, $40
		dc.b 0, $E, $10, 6, 0, $40
		even
