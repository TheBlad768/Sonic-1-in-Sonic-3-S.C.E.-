; ---------------------------------------------------------------------------
; Sprite mappings - Moto Bug enemy (GHZ)
; ---------------------------------------------------------------------------

Map_MotoBug:	mappingsTable
	mappingsTableEntry.w Map_MotoBug_E
	mappingsTableEntry.w Map_MotoBug_28
	mappingsTableEntry.w Map_MotoBug_42
	mappingsTableEntry.w Map_MotoBug_62
	mappingsTableEntry.w Map_MotoBug_6A
	mappingsTableEntry.w Map_MotoBug_72
	mappingsTableEntry.w Map_MotoBug_7A

Map_MotoBug_E:	spriteHeader
	spritePiece	-$14, -$10, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$14, 0, 4, 1, 8, 0, 0, 0, 0
	spritePiece	$C, -8, 1, 2, $C, 0, 0, 0, 0
	spritePiece	-$C, 8, 3, 1, $E, 0, 0, 0, 0
Map_MotoBug_E_End

Map_MotoBug_28:	spriteHeader
	spritePiece	-$14, -$F, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$14, 1, 4, 1, 8, 0, 0, 0, 0
	spritePiece	$C, -7, 1, 2, $C, 0, 0, 0, 0
	spritePiece	-$C, 9, 3, 1, $11, 0, 0, 0, 0
Map_MotoBug_28_End

Map_MotoBug_42:	spriteHeader
	spritePiece	-$14, -$10, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-$14, 0, 4, 1, $14, 0, 0, 0, 0
	spritePiece	$C, -8, 1, 2, $C, 0, 0, 0, 0
	spritePiece	-$14, 8, 2, 1, $18, 0, 0, 0, 0
	spritePiece	-4, 8, 2, 1, $12, 0, 0, 0, 0
Map_MotoBug_42_End

Map_MotoBug_62:	spriteHeader
	spritePiece	$10, -6, 1, 1, $1A, 0, 0, 0, 0
Map_MotoBug_62_End

Map_MotoBug_6A:	spriteHeader
	spritePiece	$10, -6, 1, 1, $1B, 0, 0, 0, 0
Map_MotoBug_6A_End

Map_MotoBug_72:	spriteHeader
	spritePiece	$10, -6, 1, 1, $1C, 0, 0, 0, 0
Map_MotoBug_72_End

Map_MotoBug_7A:	spriteHeader
Map_MotoBug_7A_End

		even
