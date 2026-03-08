; ---------------------------------------------------------------------------
; Sprite mappings - large moving grass-covered platforms (MZ)
; ---------------------------------------------------------------------------

Map_LargeGrassPlatform:
		dc.w Map_LargeGrassPlatform_6-Map_LargeGrassPlatform, Map_LargeGrassPlatform_56-Map_LargeGrassPlatform
		dc.w Map_LargeGrassPlatform_94-Map_LargeGrassPlatform
Map_LargeGrassPlatform_6:	dc.b 0, $D
		dc.b $D8, 6, 0, $57, $FF, $C0
		dc.b $F0, 5, 0, $53, $FF, $C0
		dc.b 0, $F, 0, 1, $FF, $C0
		dc.b $D0, $F, 0, $27, $FF, $D0
		dc.b $F0, $D, 0, $37, $FF, $D0
		dc.b $F0, $F, 0, 1, $FF, $E0
		dc.b $D0, $F, 0, $11, $FF, $F0
		dc.b $D0, $F, 0, $3F, 0, $10
		dc.b $F0, $D, 0, $4F, 0, $10
		dc.b $F0, $F, 0, 1, 0, 0
		dc.b 0, $F, 0, 1, 0, $20
		dc.b $D8, 6, 0, $57, 0, $30
		dc.b $F0, 5, 0, $53, 0, $30
Map_LargeGrassPlatform_56:	dc.b 0, $A
		dc.b $D0, $F, 0, $27, $FF, $C0
		dc.b $F0, $D, 0, $37, $FF, $C0
		dc.b 0, $F, 0, 1, $FF, $C0
		dc.b $C0, $F, 0, $27, $FF, $E0
		dc.b $E0, $D, 0, $37, $FF, $E0
		dc.b $F0, $F, 0, 1, $FF, $E0
		dc.b $C0, $F, 0, $11, 0, 0
		dc.b $E0, $F, 0, 1, 0, 0
		dc.b $C0, $F, 0, $3F, 0, $20
		dc.b $E0, $D, 0, $4F, 0, $20
Map_LargeGrassPlatform_94:	dc.b 0, 6
		dc.b $D0, $F, 0, $11, $FF, $E0
		dc.b $F0, $F, 0, 1, $FF, $E0
		dc.b $10, $F, 0, 1, $FF, $E0
		dc.b $D0, $F, 0, $11, 0, 0
		dc.b $F0, $F, 0, 1, 0, 0
		dc.b $10, $F, 0, 1, 0, 0
		even
