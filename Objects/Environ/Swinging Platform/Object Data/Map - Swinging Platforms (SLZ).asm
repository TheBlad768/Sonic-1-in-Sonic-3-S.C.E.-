; ---------------------------------------------------------------------------
; Sprite mappings - SLZ swinging platforms
; ---------------------------------------------------------------------------

Map_SwingingPlatform_SLZ:
		dc.w Map_SwingingPlatform_SLZ_6-Map_SwingingPlatform_SLZ
		dc.w Map_SwingingPlatform_SLZ_38-Map_SwingingPlatform_SLZ
		dc.w Map_SwingingPlatform_SLZ_40-Map_SwingingPlatform_SLZ
Map_SwingingPlatform_SLZ_6:	dc.b 0, 8
		dc.b $F0, $F, 0, 4, $FF, $E0
		dc.b $F0, $F, 8, 4, 0, 0
		dc.b $F0, 5, 0, $14, $FF, $D0
		dc.b $F0, 5, 8, $14, 0, $20
		dc.b $10, 4, 0, $18, $FF, $E0
		dc.b $10, 4, 8, $18, 0, $10
		dc.b $10, 1, 0, $1A, $FF, $F8
		dc.b $10, 1, 8, $1A, 0, 0
Map_SwingingPlatform_SLZ_38:	dc.b 0, 1
		dc.b $F8, 5, 0, 0, $FF, $F8
Map_SwingingPlatform_SLZ_40:	dc.b 0, 1
		dc.b $F8, 5, 0, $1C, $FF, $F8
		even
