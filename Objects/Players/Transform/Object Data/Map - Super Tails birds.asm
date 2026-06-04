; ---------------------------------------------------------------------------
; Sprite mappings - super tails birds
; ---------------------------------------------------------------------------

Map_SuperTails_Birds:	mappingsTable
	mappingsTableEntry.w word_1A46A
	mappingsTableEntry.w word_1A472
	mappingsTableEntry.w word_1A47A

word_1A46A:	spriteHeader
	spritePiece	-8, -8, 2, 2, 6, 0, 0, 0, 0
word_1A46A_End

word_1A472:	spriteHeader
	spritePiece	-8, -8, 2, 2, $A, 0, 0, 0, 0
word_1A472_End

word_1A47A:	spriteHeader
	spritePiece	-8, -$C, 2, 3, 0, 0, 0, 0, 0
word_1A47A_End

	even
