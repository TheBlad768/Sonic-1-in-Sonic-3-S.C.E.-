; ---------------------------------------------------------------------------
; Sprite mappings - collapsing floors (MZ, SLZ, SBZ)
; ---------------------------------------------------------------------------

Map_CollapseFloor:	mappingsTable
	mappingsTableEntry.w Map_CollapseFloor_8
	mappingsTableEntry.w Map_CollapseFloor_22
	mappingsTableEntry.w Map_CollapseFloor_54
	mappingsTableEntry.w Map_CollapseFloor_6E

Map_CollapseFloor_8:	spriteHeader
	spritePiece	-$20, -8, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$20, 8, 4, 2, 0, 0, 0, 0, 0
	spritePiece	0, -8, 4, 2, 0, 0, 0, 0, 0
	spritePiece	0, 8, 4, 2, 0, 0, 0, 0, 0
Map_CollapseFloor_8_End

Map_CollapseFloor_22:	spriteHeader
	spritePiece	-$20, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	0, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	$10, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$20, 8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, 8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	0, 8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	$10, 8, 2, 2, 0, 0, 0, 0, 0
Map_CollapseFloor_22_End

Map_CollapseFloor_54:	spriteHeader
	spritePiece	-$20, -8, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$20, 8, 4, 2, 8, 0, 0, 0, 0
	spritePiece	0, -8, 4, 2, 0, 0, 0, 0, 0
	spritePiece	0, 8, 4, 2, 8, 0, 0, 0, 0
Map_CollapseFloor_54_End

Map_CollapseFloor_6E:	spriteHeader
	spritePiece	-$20, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, -8, 2, 2, 4, 0, 0, 0, 0
	spritePiece	0, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	$10, -8, 2, 2, 4, 0, 0, 0, 0
	spritePiece	-$20, 8, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-$10, 8, 2, 2, $C, 0, 0, 0, 0
	spritePiece	0, 8, 2, 2, 8, 0, 0, 0, 0
	spritePiece	$10, 8, 2, 2, $C, 0, 0, 0, 0
Map_CollapseFloor_6E_End

		even
