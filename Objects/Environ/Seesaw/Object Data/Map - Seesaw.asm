; ---------------------------------------------------------------------------
; Sprite mappings - seesaws (SLZ)
; ---------------------------------------------------------------------------

Map_Seesaw:	mappingsTable
	mappingsTableEntry.w Map_Seesaw_8
	mappingsTableEntry.w Map_Seesaw_34
	mappingsTableEntry.w Map_Seesaw_8
	mappingsTableEntry.w Map_Seesaw_34

Map_Seesaw_8:	spriteHeader
	spritePiece	-$2D, -$2C, 2, 3, 0, 0, 0, 0, 0
	spritePiece	-$1D, -$24, 2, 3, 6, 0, 0, 0, 0
	spritePiece	-$D, -$1C, 2, 1, $C, 0, 0, 0, 0
	spritePiece	-$D, -$14, 4, 2, $E, 0, 0, 0, 0
	spritePiece	-5, -4, 3, 1, $16, 0, 0, 0, 0
	spritePiece	$13, -$C, 2, 3, 6, 0, 0, 0, 0
	spritePiece	$23, -4, 2, 2, $19, 0, 0, 0, 0
Map_Seesaw_8_End

Map_Seesaw_34:	spriteHeader
	spritePiece	-$30, -$1A, 3, 3, $1D, 0, 0, 0, 0
	spritePiece	-$18, -$1A, 3, 3, $23, 0, 0, 0, 0
	spritePiece	0, -$1A, 3, 3, $23, 1, 0, 0, 0
	spritePiece	$18, -$1A, 3, 3, $1D, 1, 0, 0, 0
Map_Seesaw_34_End

	even
