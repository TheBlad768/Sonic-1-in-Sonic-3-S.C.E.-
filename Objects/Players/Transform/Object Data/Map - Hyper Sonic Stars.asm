; ---------------------------------------------------------------------------
; Sprite mappings - hyper sonic stars
; ---------------------------------------------------------------------------

Map_HyperSonicStars:	mappingsTable
	mappingsTableEntry.w word_19498
	mappingsTableEntry.w word_194A0
	mappingsTableEntry.w word_194A8
	mappingsTableEntry.w word_194B6
	mappingsTableEntry.w word_194BE
	mappingsTableEntry.w word_194C6

word_19498:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0
word_19498_End

word_194A0:	spriteHeader
	spritePiece	-8, -8, 2, 2, 4, 0, 0, 0, 0
word_194A0_End

word_194A8:	spriteHeader
	spritePiece	-$10, -$10, 4, 2, 8, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 2, 8, 0, 1, 0, 0
word_194A8_End

word_194B6:	spriteHeader
	spritePiece	-8, -8, 2, 2, $10, 0, 0, 0, 0
word_194B6_End

word_194BE:	spriteHeader
	spritePiece	-8, -$C, 2, 3, $14, 0, 0, 0, 0
word_194BE_End

word_194C6:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, $1A, 0, 0, 0, 0
word_194C6_End

	even
