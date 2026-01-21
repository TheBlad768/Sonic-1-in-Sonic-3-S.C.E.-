; ---------------------------------------------------------------------------
; Sprite mappings - special stage chaos emeralds
; ---------------------------------------------------------------------------

Map_SS_Chaos:
		dc.w Map_SS_Chaos_4-Map_SS_Chaos
		dc.w Map_SS_Chaos_C-Map_SS_Chaos
Map_SS_Chaos_4:	dc.b 0, 1
		dc.b $F8, 5, $20, 0, $FF, $F8
Map_SS_Chaos_C:	dc.b 0, 1
		dc.b $F8, 5, 0, 0, $FF, $F8
		even
