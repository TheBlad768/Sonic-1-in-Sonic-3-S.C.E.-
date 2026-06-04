; ---------------------------------------------------------------------------
; Sprite mappings - platforms that move when you stand on them (SLZ)
; ---------------------------------------------------------------------------

Map_Elevator:	mappingsTable
	mappingsTableEntry.w Map_Elevator_2

Map_Elevator_2:	spriteHeader
	spritePiece	-$28, -8, 4, 4, $41, 0, 0, 0, 0
	spritePiece	-8, -8, 4, 4, $41, 0, 0, 0, 0
	spritePiece	$18, -8, 2, 4, $41, 0, 0, 0, 0
Map_Elevator_2_End

		even
