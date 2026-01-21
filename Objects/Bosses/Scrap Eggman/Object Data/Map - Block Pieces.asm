; ---------------------------------------------------------------------------
; Sprite mappings - block pieces that disintegrate when Eggman presses a switch
; ---------------------------------------------------------------------------

Map_FFloor_Pieces:
		dc.w Map_FFloor_12-Map_FFloor_Pieces
		dc.w Map_FFloor_20-Map_FFloor_Pieces
		dc.w Map_FFloor_2E-Map_FFloor_Pieces
		dc.w Map_FFloor_3C-Map_FFloor_Pieces
Map_FFloor_12:
		dc.b 0, 2
		dc.b $F8, 1, 0, 0, $FF, $F8
		dc.b $F8, 1, 0, 4, 0, 0
Map_FFloor_20:
		dc.b 0, 2
		dc.b $F8, 1, 0, 8, $FF, $F8
		dc.b $F8, 1, 0, $C, 0, 0
Map_FFloor_2E:
		dc.b 0, 2
		dc.b $F8, 1, 0, 2, $FF, $F8
		dc.b $F8, 1, 0, 6, 0, 0
Map_FFloor_3C:
		dc.b 0, 2
		dc.b $F8, 1, 0, $A, $FF, $F8
		dc.b $F8, 1, 0, $E, 0, 0
	even
