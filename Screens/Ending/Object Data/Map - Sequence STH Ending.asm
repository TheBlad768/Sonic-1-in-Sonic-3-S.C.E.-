; ---------------------------------------------------------------------------
; Sprite mappings - "SONIC THE HEDGEHOG" text on the ending sequence
; ---------------------------------------------------------------------------

Map_ESth:
		dc.w Map_ESth_A-Map_ESth, Map_ESth_30-Map_ESth
		dc.w Map_ESth_44-Map_ESth, Map_ESth_82-Map_ESth
		dc.w Map_ESth_AE-Map_ESth
Map_ESth_A:	dc.b 0, 6
		dc.b $F0, $F, 0, 0, $FF, $D0
		dc.b $F0, $F, 0, $10, $FF, $F0
		dc.b $F0, $F, 0, $20, 0, $10
		dc.b $10, 8, 0, $58, $FF, $D0
		dc.b $10, $C, 0, $53, 0, 8
		dc.b $10, 0, 0, $57, 0, $28
Map_ESth_30:	dc.b 0, 3
		dc.b $F0, $F, 0, 0, $FF, $D0
		dc.b $F0, $F, 0, $10, $FF, $F0
		dc.b $F0, $F, 0, $20, 0, $10
Map_ESth_44:	dc.b 0, $A
		dc.b $E0, $D, 0, $46, $FF, $D0
		dc.b $E0, 0, 0, $4E, $FF, $F0
		dc.b $E0, $C, 0, $52, $FF, $FB
		dc.b $E0, 4, 0, $56, 0, $1B
		dc.b $E0, 0, 0, $52, 0, $29
		dc.b $E8, 8, 0, $4F, $FF, $F0
		dc.b $E8, 4, 0, $44, 0, $20
		dc.b $F0, $F, 0, 0, $FF, $D0
		dc.b $F0, $F, 0, $10, $FF, $F0
		dc.b $F0, $F, 0, $20, 0, $10
Map_ESth_82:	dc.b 0, 7
		dc.b $E0, $D, 0, $30, $FF, $D0
		dc.b $E0, $D, 0, $38, $FF, $F0
		dc.b $E0, $C, 0, $40, 0, $10
		dc.b $E8, 4, 0, $44, 0, $20
		dc.b $F0, $F, 0, 0, $FF, $D0
		dc.b $F0, $F, 0, $10, $FF, $F0
		dc.b $F0, $F, 0, $20, 0, $10
Map_ESth_AE:	dc.b 0, $A
		dc.b $D8, $D, 0, $30, $FF, $D0
		dc.b $D8, $D, 0, $38, $FF, $F0
		dc.b $D8, $C, 0, $40, 0, $10
		dc.b $E0, 8, 0, $58, 0, $18
		dc.b $E8, $C, 0, $53, $FF, $CF
		dc.b $E8, 0, 0, $57, $FF, $EF
		dc.b $E8, 4, 0, $44, 0, $20
		dc.b $F0, $F, 0, 0, $FF, $D0
		dc.b $F0, $F, 0, $10, $FF, $F0
		dc.b $F0, $F, 0, $20, 0, $10
		even
