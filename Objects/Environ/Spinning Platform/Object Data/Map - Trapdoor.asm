; ---------------------------------------------------------------------------
; Sprite mappings - trapdoor (SBZ)
; ---------------------------------------------------------------------------

Map_Trapdoor:
		dc.w Map_Trapdoor_6-Map_Trapdoor
		dc.w Map_Trapdoor_20-Map_Trapdoor
		dc.w Map_Trapdoor_52-Map_Trapdoor
Map_Trapdoor_6:	dc.b 0, 4
		dc.b $F4, $E, 0, 0, $FF, $C0
		dc.b $F4, $E, 8, 0, $FF, $E0
		dc.b $F4, $E, 0, 0, 0, 0
		dc.b $F4, $E, 8, 0, 0, $20
Map_Trapdoor_20:	dc.b 0, 8
		dc.b $F2, $F, 0, $C, $FF, $B6
		dc.b $1A, $F, $18, $C, $FF, $D6
		dc.b 2, $A, 0, $1C, $FF, $D6
		dc.b $12, $A, $18, $1C, $FF, $BE
		dc.b $F2, $F, 8, $C, 0, $2A
		dc.b $1A, $F, $10, $C, 0, $A
		dc.b 2, $A, 8, $1C, 0, $12
		dc.b $12, $A, $10, $1C, 0, $2A
Map_Trapdoor_52:	dc.b 0, 4
		dc.b 0, $B, 0, $25, $FF, $B4
		dc.b $20, $B, $10, $25, $FF, $B4
		dc.b 0, $B, 0, $25, 0, $34
		dc.b $20, $B, $10, $25, 0, $34
		even
