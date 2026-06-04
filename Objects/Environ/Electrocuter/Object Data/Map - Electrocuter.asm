; ---------------------------------------------------------------------------
; Sprite mappings - electrocution orbs (SBZ)
; ---------------------------------------------------------------------------

Map_Electrocuter:	mappingsTable
	mappingsTableEntry.w Map_Electrocuter_C
	mappingsTableEntry.w Map_Electrocuter_1A
	mappingsTableEntry.w Map_Electrocuter_2E
	mappingsTableEntry.w Map_Electrocuter_4E
	mappingsTableEntry.w Map_Electrocuter_68
	mappingsTableEntry.w Map_Electrocuter_8E

Map_Electrocuter_C:	spriteHeader
	spritePiece	-8, -8, 2, 1, 0, 0, 0, 3, 0
	spritePiece	-8, 0, 2, 3, 2, 0, 0, 2, 0
Map_Electrocuter_C_End

Map_Electrocuter_1A:	spriteHeader
	spritePiece	-8, -8, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-8, -8, 2, 1, 0, 0, 0, 3, 0
	spritePiece	-8, 0, 2, 3, 2, 0, 0, 2, 0
Map_Electrocuter_1A_End

Map_Electrocuter_2E:	spriteHeader
	spritePiece	-8, -8, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-8, -8, 2, 1, 0, 0, 0, 3, 0
	spritePiece	-8, 0, 2, 3, 2, 0, 0, 2, 0
	spritePiece	8, -$A, 4, 2, $C, 0, 0, 0, 0
	spritePiece	-$24, -$A, 4, 2, $C, 1, 0, 0, 0
Map_Electrocuter_2E_End

Map_Electrocuter_4E:	spriteHeader
	spritePiece	-8, -8, 2, 1, 0, 0, 0, 3, 0
	spritePiece	-8, 0, 2, 3, 2, 0, 0, 2, 0
	spritePiece	8, -$A, 4, 2, $C, 0, 0, 0, 0
	spritePiece	-$24, -$A, 4, 2, $C, 1, 0, 0, 0
Map_Electrocuter_4E_End

Map_Electrocuter_68:	spriteHeader
	spritePiece	-8, -8, 2, 1, 0, 0, 0, 3, 0
	spritePiece	-8, 0, 2, 3, 2, 0, 0, 2, 0
	spritePiece	8, -$A, 4, 2, $C, 0, 1, 0, 0
	spritePiece	-$24, -$A, 4, 2, $C, 1, 1, 0, 0
	spritePiece	$24, -$A, 4, 2, $C, 0, 0, 0, 0
	spritePiece	-$40, -$A, 4, 2, $C, 1, 0, 0, 0
Map_Electrocuter_68_End

Map_Electrocuter_8E:	spriteHeader
	spritePiece	-8, -8, 2, 1, 0, 0, 0, 3, 0
	spritePiece	-8, 0, 2, 3, 2, 0, 0, 2, 0
	spritePiece	$24, -$A, 4, 2, $C, 0, 1, 0, 0
	spritePiece	-$40, -$A, 4, 2, $C, 1, 1, 0, 0
Map_Electrocuter_8E_End

		even
