; ---------------------------------------------------------------------------
; Sprite mappings - big ring flash
; ---------------------------------------------------------------------------

Map_BigRingFlash:	mappingsTable
	mappingsTableEntry.w word_61B30
	mappingsTableEntry.w word_61B56
	mappingsTableEntry.w word_61B7C
	mappingsTableEntry.w word_61BAE

word_61B30:	spriteHeader
	spritePiece	0, -$20, 3, 1, 0, 0, 0, 0, 0
	spritePiece	8, -$18, 3, 2, 3, 0, 0, 0, 0
	spritePiece	$18, -8, 1, 1, 9, 0, 0, 0, 0
	spritePiece	0, $18, 3, 1, 0, 0, 1, 0, 0
	spritePiece	8, 8, 3, 2, 3, 0, 1, 0, 0
	spritePiece	$18, 0, 1, 1, 9, 0, 1, 0, 0
word_61B30_End

word_61B56:	spriteHeader
	spritePiece	0, -$20, 4, 1, 0, 0, 0, 0, 0
	spritePiece	8, -$18, 4, 2, 4, 0, 0, 0, 0
	spritePiece	$18, -8, 2, 1, $C, 0, 0, 0, 0
	spritePiece	0, $18, 4, 1, 0, 0, 1, 0, 0
	spritePiece	8, 8, 4, 2, 4, 0, 1, 0, 0
	spritePiece	$18, 0, 2, 1, $C, 0, 1, 0, 0
word_61B56_End

word_61B7C:	spriteHeader
	spritePiece	0, -$20, 3, 1, 0, 0, 0, 0, 0
	spritePiece	0, -$18, 4, 3, 3, 0, 0, 0, 0
	spritePiece	0, $18, 3, 1, 0, 0, 1, 0, 0
	spritePiece	0, 0, 4, 3, 3, 0, 1, 0, 0
	spritePiece	-$10, -$20, 2, 2, $F, 1, 0, 0, 0
	spritePiece	-8, -$10, 1, 2, $13, 1, 0, 0, 0
	spritePiece	-$10, $10, 2, 2, $F, 1, 1, 0, 0
	spritePiece	-8, 0, 1, 2, $13, 1, 1, 0, 0
word_61B7C_End

word_61BAE:	spriteHeader
	spritePiece	0, -$20, 3, 1, 0, 0, 0, 0, 0
	spritePiece	0, -$18, 4, 3, 3, 0, 0, 0, 0
	spritePiece	0, $18, 3, 1, 0, 0, 1, 0, 0
	spritePiece	0, 0, 4, 3, 3, 0, 1, 0, 0
	spritePiece	-$18, -$20, 3, 1, 0, 1, 0, 0, 0
	spritePiece	-$20, -$18, 4, 3, 3, 1, 0, 0, 0
	spritePiece	-$18, $18, 3, 1, 0, 1, 1, 0, 0
	spritePiece	-$20, 0, 4, 3, 3, 1, 1, 0, 0
word_61BAE_End

	even
