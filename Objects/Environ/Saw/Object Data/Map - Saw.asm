; ---------------------------------------------------------------------------
; Sprite mappings - ground saws	and pizza cutters (SBZ)
; ---------------------------------------------------------------------------

Map_Saw:	mappingsTable
	mappingsTableEntry.w Map_Saw_8
	mappingsTableEntry.w Map_Saw_34
	mappingsTableEntry.w Map_Saw_60
	mappingsTableEntry.w Map_Saw_7A

Map_Saw_8:	spriteHeader
	spritePiece	-4, -$3C, 1, 2, $20, 0, 0, 0, 0
	spritePiece	-4, -$2C, 1, 2, $20, 0, 0, 0, 0
	spritePiece	-4, -$1C, 1, 4, $20, 0, 0, 0, 0
	spritePiece	-$20, -$20, 4, 4, 0, 0, 0, 0, 0
	spritePiece	0, -$20, 4, 4, 0, 1, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, 0, 0, 1, 0, 0
	spritePiece	0, 0, 4, 4, 0, 1, 1, 0, 0
Map_Saw_8_End

Map_Saw_34:	spriteHeader
	spritePiece	-4, -$3C, 1, 2, $20, 0, 0, 0, 0
	spritePiece	-4, -$2C, 1, 2, $20, 0, 0, 0, 0
	spritePiece	-4, -$1C, 1, 4, $20, 0, 0, 0, 0
	spritePiece	-$20, -$20, 4, 4, $10, 0, 0, 0, 0
	spritePiece	0, -$20, 4, 4, $10, 1, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, $10, 0, 1, 0, 0
	spritePiece	0, 0, 4, 4, $10, 1, 1, 0, 0
Map_Saw_34_End

Map_Saw_60:	spriteHeader
	spritePiece	-$20, -$20, 4, 4, 0, 0, 0, 0, 0
	spritePiece	0, -$20, 4, 4, 0, 1, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, 0, 0, 1, 0, 0
	spritePiece	0, 0, 4, 4, 0, 1, 1, 0, 0
Map_Saw_60_End

Map_Saw_7A:	spriteHeader
	spritePiece	-$20, -$20, 4, 4, $10, 0, 0, 0, 0
	spritePiece	0, -$20, 4, 4, $10, 1, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, $10, 0, 1, 0, 0
	spritePiece	0, 0, 4, 4, $10, 1, 1, 0, 0
Map_Saw_7A_End

		even
