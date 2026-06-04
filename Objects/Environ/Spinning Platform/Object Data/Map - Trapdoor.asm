; ---------------------------------------------------------------------------
; Sprite mappings - trapdoor (SBZ)
; ---------------------------------------------------------------------------

Map_Trapdoor:	mappingsTable
	mappingsTableEntry.w Map_Trapdoor_6
	mappingsTableEntry.w Map_Trapdoor_20
	mappingsTableEntry.w Map_Trapdoor_52

Map_Trapdoor_6:	spriteHeader
	spritePiece	-$40, -$C, 4, 3, 0, 0, 0, 0, 0
	spritePiece	-$20, -$C, 4, 3, 0, 1, 0, 0, 0
	spritePiece	0, -$C, 4, 3, 0, 0, 0, 0, 0
	spritePiece	$20, -$C, 4, 3, 0, 1, 0, 0, 0
Map_Trapdoor_6_End

Map_Trapdoor_20:	spriteHeader
	spritePiece	-$4A, -$E, 4, 4, $C, 0, 0, 0, 0
	spritePiece	-$2A, $1A, 4, 4, $C, 1, 1, 0, 0
	spritePiece	-$2A, 2, 3, 3, $1C, 0, 0, 0, 0
	spritePiece	-$42, $12, 3, 3, $1C, 1, 1, 0, 0
	spritePiece	$2A, -$E, 4, 4, $C, 1, 0, 0, 0
	spritePiece	$A, $1A, 4, 4, $C, 0, 1, 0, 0
	spritePiece	$12, 2, 3, 3, $1C, 1, 0, 0, 0
	spritePiece	$2A, $12, 3, 3, $1C, 0, 1, 0, 0
Map_Trapdoor_20_End

Map_Trapdoor_52:	spriteHeader
	spritePiece	-$4C, 0, 3, 4, $25, 0, 0, 0, 0
	spritePiece	-$4C, $20, 3, 4, $25, 0, 1, 0, 0
	spritePiece	$34, 0, 3, 4, $25, 0, 0, 0, 0
	spritePiece	$34, $20, 3, 4, $25, 0, 1, 0, 0
Map_Trapdoor_52_End

		even
