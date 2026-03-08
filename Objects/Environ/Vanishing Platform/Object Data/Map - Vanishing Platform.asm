; ---------------------------------------------------------------------------
; Sprite mappings - vanishing platforms (SBZ)
; ---------------------------------------------------------------------------

Map_VanishPlatform:
		dc.w Map_VanishPlatform_8-Map_VanishPlatform
		dc.w Map_VanishPlatform_10-Map_VanishPlatform
		dc.w Map_VanishPlatform_18-Map_VanishPlatform
		dc.w Map_VanishPlatform_20-Map_VanishPlatform
Map_VanishPlatform_8:
		dc.w 1
		dc.b $F8, $F, 0, 0, $FF, $F0
Map_VanishPlatform_10:
		dc.w 1
		dc.b $F8, 7, 0, $10, $FF, $F8
Map_VanishPlatform_18:
		dc.w 1
		dc.b $F8, 3, 0, $18, $FF, $FC
Map_VanishPlatform_20:
		dc.w 0
	even
