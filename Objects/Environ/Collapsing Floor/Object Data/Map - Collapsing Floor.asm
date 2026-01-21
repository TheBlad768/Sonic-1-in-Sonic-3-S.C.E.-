; ---------------------------------------------------------------------------
; Sprite mappings - collapsing floors (MZ, SLZ, SBZ)
; ---------------------------------------------------------------------------

Map_CFlo:
		dc.w Map_CFlo_8-Map_CFlo, Map_CFlo_22-Map_CFlo
		dc.w Map_CFlo_54-Map_CFlo, Map_CFlo_6E-Map_CFlo
Map_CFlo_8:	dc.b 0, 4
		dc.b $F8, $D, 0, 0, $FF, $E0
		dc.b 8, $D, 0, 0, $FF, $E0
		dc.b $F8, $D, 0, 0, 0, 0
		dc.b 8, $D, 0, 0, 0, 0
Map_CFlo_22:	dc.b 0, 8
		dc.b $F8, 5, 0, 0, $FF, $E0
		dc.b $F8, 5, 0, 0, $FF, $F0
		dc.b $F8, 5, 0, 0, 0, 0
		dc.b $F8, 5, 0, 0, 0, $10
		dc.b 8, 5, 0, 0, $FF, $E0
		dc.b 8, 5, 0, 0, $FF, $F0
		dc.b 8, 5, 0, 0, 0, 0
		dc.b 8, 5, 0, 0, 0, $10
Map_CFlo_54:	dc.b 0, 4
		dc.b $F8, $D, 0, 0, $FF, $E0
		dc.b 8, $D, 0, 8, $FF, $E0
		dc.b $F8, $D, 0, 0, 0, 0
		dc.b 8, $D, 0, 8, 0, 0
Map_CFlo_6E:	dc.b 0, 8
		dc.b $F8, 5, 0, 0, $FF, $E0
		dc.b $F8, 5, 0, 4, $FF, $F0
		dc.b $F8, 5, 0, 0, 0, 0
		dc.b $F8, 5, 0, 4, 0, $10
		dc.b 8, 5, 0, 8, $FF, $E0
		dc.b 8, 5, 0, $C, $FF, $F0
		dc.b 8, 5, 0, 8, 0, 0
		dc.b 8, 5, 0, $C, 0, $10
		even
