; ---------------------------------------------------------------------------
; Sprite mappings - moving blocks (MZ, SBZ)
; ---------------------------------------------------------------------------

Map_MovingBlock:	mappingsTable
	mappingsTableEntry.w Map_MovingBlock_A
	mappingsTableEntry.w Map_MovingBlock_12
	mappingsTableEntry.w Map_MovingBlock_20
	mappingsTableEntry.w Map_MovingBlock_3A
	mappingsTableEntry.w Map_MovingBlock_54

Map_MovingBlock_A:	spriteHeader
	spritePiece	-$10, -8, 4, 4, 8, 0, 0, 0, 0
Map_MovingBlock_A_End

Map_MovingBlock_12:	spriteHeader
	spritePiece	-$20, -8, 4, 4, 8, 0, 0, 0, 0
	spritePiece	0, -8, 4, 4, 8, 0, 0, 0, 0
Map_MovingBlock_12_End

Map_MovingBlock_20:	spriteHeader
	spritePiece	-$20, -8, 4, 1, 0, 0, 0, 1, 0
	spritePiece	-$20, 0, 4, 2, 4, 0, 0, 0, 0
	spritePiece	0, -8, 4, 1, 0, 0, 0, 1, 0
	spritePiece	0, 0, 4, 2, 4, 0, 0, 0, 0
Map_MovingBlock_20_End

Map_MovingBlock_3A:	spriteHeader
	spritePiece	-$40, -8, 4, 3, 0, 0, 0, 0, 0
	spritePiece	-$20, -8, 4, 3, 3, 0, 0, 0, 0
	spritePiece	0, -8, 4, 3, 3, 0, 0, 0, 0
	spritePiece	$20, -8, 4, 3, 0, 1, 0, 0, 0
Map_MovingBlock_3A_End

Map_MovingBlock_54:	spriteHeader
	spritePiece	-$30, -8, 4, 4, 8, 0, 0, 0, 0
	spritePiece	-$10, -8, 4, 4, 8, 0, 0, 0, 0
	spritePiece	$10, -8, 4, 4, 8, 0, 0, 0, 0
Map_MovingBlock_54_End

		even
