; ---------------------------------------------------------------------------
; Sprite mappings - platforms that move in circles (SLZ)
; ---------------------------------------------------------------------------

Map_CirclingPlatform:
		dc.w Map_CirclingPlatform_2-Map_CirclingPlatform
Map_CirclingPlatform_2:	dc.b 0, 2
		dc.b $F8, 9, 0, $51, $FF, $E8
		dc.b $F8, 9, 8, $51, 0, 0
	even
