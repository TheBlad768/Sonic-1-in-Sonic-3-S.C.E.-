; ---------------------------------------------------------------------------
; Sprite mappings - lava geyser / lava that falls from the ceiling (MZ)
; ---------------------------------------------------------------------------

Map_Geyser:
		dc.w Map_Geyser_28-Map_Geyser, Map_Geyser_36-Map_Geyser
		dc.w Map_Geyser_44-Map_Geyser, Map_Geyser_5E-Map_Geyser
		dc.w Map_Geyser_78-Map_Geyser, Map_Geyser_9E-Map_Geyser
		dc.w Map_Geyser_C4-Map_Geyser, Map_Geyser_D2-Map_Geyser
		dc.w Map_Geyser_E0-Map_Geyser, Map_Geyser_11E-Map_Geyser
		dc.w Map_Geyser_15C-Map_Geyser, Map_Geyser_19A-Map_Geyser
		dc.w Map_Geyser_1C0-Map_Geyser, Map_Geyser_1E6-Map_Geyser
		dc.w Map_Geyser_20C-Map_Geyser, Map_Geyser_26E-Map_Geyser
		dc.w Map_Geyser_2D0-Map_Geyser, Map_Geyser_332-Map_Geyser
		dc.w Map_Geyser_358-Map_Geyser, Map_Geyser_37E-Map_Geyser
Map_Geyser_28:	dc.b 0, 2
		dc.b $EC, $B, 0, 0, $FF, $E8
		dc.b $EC, $B, 8, 0, 0, 0
Map_Geyser_36:	dc.b 0, 2
		dc.b $EC, $B, 0, $18, $FF, $E8
		dc.b $EC, $B, 8, $18, 0, 0
Map_Geyser_44:	dc.b 0, 4
		dc.b $EC, $B, 0, 0, $FF, $C8
		dc.b $F4, $E, 0, $C, $FF, $E0
		dc.b $F4, $E, 8, $C, 0, 0
		dc.b $EC, $B, 8, 0, 0, $20
Map_Geyser_5E:	dc.b 0, 4
		dc.b $EC, $B, 0, $18, $FF, $C8
		dc.b $F4, $E, 0, $24, $FF, $E0
		dc.b $F4, $E, 8, $24, 0, 0
		dc.b $EC, $B, 8, $18, 0, $20
Map_Geyser_78:	dc.b 0, 6
		dc.b $EC, $B, 0, 0, $FF, $C8
		dc.b $F4, $E, 0, $C, $FF, $E0
		dc.b $F4, $E, 8, $C, 0, 0
		dc.b $EC, $B, 8, 0, 0, $20
		dc.b $E8, $E, 0, $90, $FF, $E0
		dc.b $E8, $E, 8, $90, 0, 0
Map_Geyser_9E:	dc.b 0, 6
		dc.b $EC, $B, 0, $18, $FF, $C8
		dc.b $F4, $E, 0, $24, $FF, $E0
		dc.b $F4, $E, 8, $24, 0, 0
		dc.b $EC, $B, 8, $18, 0, $20
		dc.b $E8, $E, 8, $90, $FF, $E0
		dc.b $E8, $E, 0, $90, 0, 0
Map_Geyser_C4:	dc.b 0, 2
		dc.b $E0, $F, 0, $30, $FF, $E0
		dc.b $E0, $F, 8, $30, 0, 0
Map_Geyser_D2:	dc.b 0, 2
		dc.b $E0, $F, 8, $30, $FF, $E0
		dc.b $E0, $F, 0, $30, 0, 0
Map_Geyser_E0:	dc.b 0, $A
		dc.b $90, $F, 0, $40, $FF, $E0
		dc.b $90, $F, 8, $40, 0, 0
		dc.b $B0, $F, 0, $40, $FF, $E0
		dc.b $B0, $F, 8, $40, 0, 0
		dc.b $D0, $F, 0, $40, $FF, $E0
		dc.b $D0, $F, 8, $40, 0, 0
		dc.b $F0, $F, 0, $40, $FF, $E0
		dc.b $F0, $F, 8, $40, 0, 0
		dc.b $10, $F, 0, $40, $FF, $E0
		dc.b $10, $F, 8, $40, 0, 0
Map_Geyser_11E:	dc.b 0, $A
		dc.b $90, $F, 0, $50, $FF, $E0
		dc.b $90, $F, 8, $50, 0, 0
		dc.b $B0, $F, 0, $50, $FF, $E0
		dc.b $B0, $F, 8, $50, 0, 0
		dc.b $D0, $F, 0, $50, $FF, $E0
		dc.b $D0, $F, 8, $50, 0, 0
		dc.b $F0, $F, 0, $50, $FF, $E0
		dc.b $F0, $F, 8, $50, 0, 0
		dc.b $10, $F, 0, $50, $FF, $E0
		dc.b $10, $F, 8, $50, 0, 0
Map_Geyser_15C:	dc.b 0, $A
		dc.b $90, $F, 0, $60, $FF, $E0
		dc.b $90, $F, 8, $60, 0, 0
		dc.b $B0, $F, 0, $60, $FF, $E0
		dc.b $B0, $F, 8, $60, 0, 0
		dc.b $D0, $F, 0, $60, $FF, $E0
		dc.b $D0, $F, 8, $60, 0, 0
		dc.b $F0, $F, 0, $60, $FF, $E0
		dc.b $F0, $F, 8, $60, 0, 0
		dc.b $10, $F, 0, $60, $FF, $E0
		dc.b $10, $F, 8, $60, 0, 0
Map_Geyser_19A:	dc.b 0, 6
		dc.b $90, $F, 0, $40, $FF, $E0
		dc.b $90, $F, 8, $40, 0, 0
		dc.b $B0, $F, 0, $40, $FF, $E0
		dc.b $B0, $F, 8, $40, 0, 0
		dc.b $D0, $F, 0, $40, $FF, $E0
		dc.b $D0, $F, 8, $40, 0, 0
Map_Geyser_1C0:	dc.b 0, 6
		dc.b $90, $F, 0, $50, $FF, $E0
		dc.b $90, $F, 8, $50, 0, 0
		dc.b $B0, $F, 0, $50, $FF, $E0
		dc.b $B0, $F, 8, $50, 0, 0
		dc.b $D0, $F, 0, $50, $FF, $E0
		dc.b $D0, $F, 8, $50, 0, 0
Map_Geyser_1E6:	dc.b 0, 6
		dc.b $90, $F, 0, $60, $FF, $E0
		dc.b $90, $F, 8, $60, 0, 0
		dc.b $B0, $F, 0, $60, $FF, $E0
		dc.b $B0, $F, 8, $60, 0, 0
		dc.b $D0, $F, 0, $60, $FF, $E0
		dc.b $D0, $F, 8, $60, 0, 0
Map_Geyser_20C:	dc.b 0, $10
		dc.b $90, $F, 0, $40, $FF, $E0
		dc.b $90, $F, 8, $40, 0, 0
		dc.b $B0, $F, 0, $40, $FF, $E0
		dc.b $B0, $F, 8, $40, 0, 0
		dc.b $D0, $F, 0, $40, $FF, $E0
		dc.b $D0, $F, 8, $40, 0, 0
		dc.b $F0, $F, 0, $40, $FF, $E0
		dc.b $F0, $F, 8, $40, 0, 0
		dc.b $10, $F, 0, $40, $FF, $E0
		dc.b $10, $F, 8, $40, 0, 0
		dc.b $30, $F, 0, $40, $FF, $E0
		dc.b $30, $F, 8, $40, 0, 0
		dc.b $50, $F, 0, $40, $FF, $E0
		dc.b $50, $F, 8, $40, 0, 0
		dc.b $70, $F, 0, $40, $FF, $E0
		dc.b $70, $F, 8, $40, 0, 0
Map_Geyser_26E:	dc.b 0, $10
		dc.b $90, $F, 0, $50, $FF, $E0
		dc.b $90, $F, 8, $50, 0, 0
		dc.b $B0, $F, 0, $50, $FF, $E0
		dc.b $B0, $F, 8, $50, 0, 0
		dc.b $D0, $F, 0, $50, $FF, $E0
		dc.b $D0, $F, 8, $50, 0, 0
		dc.b $F0, $F, 0, $50, $FF, $E0
		dc.b $F0, $F, 8, $50, 0, 0
		dc.b $10, $F, 0, $50, $FF, $E0
		dc.b $10, $F, 8, $50, 0, 0
		dc.b $30, $F, 0, $50, $FF, $E0
		dc.b $30, $F, 8, $50, 0, 0
		dc.b $50, $F, 0, $50, $FF, $E0
		dc.b $50, $F, 8, $50, 0, 0
		dc.b $70, $F, 0, $50, $FF, $E0
		dc.b $70, $F, 8, $50, 0, 0
Map_Geyser_2D0:	dc.b 0, $10
		dc.b $90, $F, 0, $60, $FF, $E0
		dc.b $90, $F, 8, $60, 0, 0
		dc.b $B0, $F, 0, $60, $FF, $E0
		dc.b $B0, $F, 8, $60, 0, 0
		dc.b $D0, $F, 0, $60, $FF, $E0
		dc.b $D0, $F, 8, $60, 0, 0
		dc.b $F0, $F, 0, $60, $FF, $E0
		dc.b $F0, $F, 8, $60, 0, 0
		dc.b $10, $F, 0, $60, $FF, $E0
		dc.b $10, $F, 8, $60, 0, 0
		dc.b $30, $F, 0, $60, $FF, $E0
		dc.b $30, $F, 8, $60, 0, 0
		dc.b $50, $F, 0, $60, $FF, $E0
		dc.b $50, $F, 8, $60, 0, 0
		dc.b $70, $F, 0, $60, $FF, $E0
		dc.b $70, $F, 8, $60, 0, 0
Map_Geyser_332:	dc.b 0, 6
		dc.b $E0, $B, 0, 0, $FF, $C8
		dc.b $E8, $E, 0, $C, $FF, $E0
		dc.b $E8, $E, 8, $C, 0, 0
		dc.b $E0, $B, 8, 0, 0, $20
		dc.b $D8, $E, 0, $90, $FF, $E0
		dc.b $D8, $E, 8, $90, 0, 0
Map_Geyser_358:	dc.b 0, 6
		dc.b $E0, $B, 0, $18, $FF, $C8
		dc.b $E8, $E, 0, $24, $FF, $E0
		dc.b $E8, $E, 8, $24, 0, 0
		dc.b $E0, $B, 8, $18, 0, $20
		dc.b $D8, $E, 8, $90, $FF, $E0
		dc.b $D8, $E, 0, $90, 0, 0
Map_Geyser_37E:	dc.b 0, 0
		even
