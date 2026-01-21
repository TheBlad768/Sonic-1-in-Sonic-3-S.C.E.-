; ---------------------------------------------------------------------------
; Sprite mappings - pinball bumper (SYZ)
; ---------------------------------------------------------------------------

Map_Bump:
		dc.w Map_Bump_6-Map_Bump
		dc.w Map_Bump_14-Map_Bump
		dc.w Map_Bump_22-Map_Bump
Map_Bump_6:	dc.b 0, 2
		dc.b $F0, 7, 0, 0, $FF, $F0
		dc.b $F0, 7, 8, 0, 0, 0
Map_Bump_14:	dc.b 0, 2
		dc.b $F4, 6, 0, 8, $FF, $F4
		dc.b $F4, 2, 8, 8, 0, 4
Map_Bump_22:	dc.b 0, 2
		dc.b $F0, 7, 0, $E, $FF, $F0
		dc.b $F0, 7, 8, $E, 0, 0
		even
