; ---------------------------------------------------------------------------
; Sprite mappings - GHZ platforms
; ---------------------------------------------------------------------------

Map_FloatingPlatform_GHZ:
		dc.w Map_FloatingPlatform_GHZ_4-Map_FloatingPlatform_GHZ
		dc.w Map_FloatingPlatform_GHZ_1E-Map_FloatingPlatform_GHZ
Map_FloatingPlatform_GHZ_4:	dc.b 0, 4
		dc.b $F4, $B, 0, $3B, $FF, $E0
		dc.b $F4, 7, 0, $3F, $FF, $F8
		dc.b $F4, 7, 0, $3F, 0, 8
		dc.b $F4, 3, 0, $47, 0, $18
Map_FloatingPlatform_GHZ_1E:	dc.b 0, $A
		dc.b $F4, $F, 0, $C5, $FF, $E0
		dc.b 4, $F, 0, $D5, $FF, $E0
		dc.b $24, $F, 0, $D5, $FF, $E0
		dc.b $44, $F, 0, $D5, $FF, $E0
		dc.b $64, $F, 0, $D5, $FF, $E0
		dc.b $F4, $F, 8, $C5, 0, 0
		dc.b 4, $F, 8, $D5, 0, 0
		dc.b $24, $F, 8, $D5, 0, 0
		dc.b $44, $F, 8, $D5, 0, 0
		dc.b $64, $F, 8, $D5, 0, 0
		even
