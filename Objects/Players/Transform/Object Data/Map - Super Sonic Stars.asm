; ---------------------------------------------------------------------------
; Sprite mappings - super sonic stars
; ---------------------------------------------------------------------------

Map_SuperSonic_Stars:	mappingsTable
	mappingsTableEntry.w word_192F2
	mappingsTableEntry.w word_192F4
	mappingsTableEntry.w word_192FC
	mappingsTableEntry.w word_19316
	mappingsTableEntry.w word_192FC
	mappingsTableEntry.w word_192F4

word_192F2:	spriteHeader
word_192F2_End

word_192F4:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0
word_192F4_End

word_192FC:	spriteHeader
	spritePiece	-$10, -$10, 2, 2, 4, 0, 0, 0, 0
	spritePiece	0, -$10, 2, 2, 4, 1, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, 4, 0, 1, 0, 0
	spritePiece	0, 0, 2, 2, 4, 1, 1, 0, 0
word_192FC_End

word_19316:	spriteHeader
	spritePiece	-$18, -$18, 3, 3, 8, 0, 0, 0, 0
	spritePiece	0, -$18, 3, 3, 8, 1, 0, 0, 0
	spritePiece	-$18, 0, 3, 3, 8, 0, 1, 0, 0
	spritePiece	0, 0, 3, 3, 8, 1, 1, 0, 0
word_19316_End

	even
