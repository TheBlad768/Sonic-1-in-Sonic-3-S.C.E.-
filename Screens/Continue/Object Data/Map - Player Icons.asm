; ---------------------------------------------------------------------------
; Sprite mappings - continue icons
; ---------------------------------------------------------------------------

Map_ContinueIcons:	mappingsTable
	mappingsTableEntry.w word_5CD12
	mappingsTableEntry.w word_5CD20
	mappingsTableEntry.w word_5CD2E
	mappingsTableEntry.w word_5CD36
	mappingsTableEntry.w word_5CD3E
	mappingsTableEntry.w word_5CD46
	mappingsTableEntry.w word_5CD4E
	mappingsTableEntry.w word_5CD56
	mappingsTableEntry.w word_5CD5E

word_5CD12:	spriteHeader
	spritePiece	-$C, -$C, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$C, 4, 3, 1, 4, 0, 0, 0, 0
word_5CD12_End

word_5CD20:	spriteHeader
	spritePiece	-$C, -$C, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$C, 4, 3, 1, 7, 0, 0, 0, 0
word_5CD20_End

word_5CD2E:	spriteHeader
	spritePiece	-8, -$C, 2, 3, $A, 0, 0, 0, 0
word_5CD2E_End

word_5CD36:	spriteHeader
	spritePiece	-8, -$C, 2, 3, $10, 0, 0, 0, 0
word_5CD36_End

word_5CD3E:	spriteHeader
	spritePiece	-$E, -4, 2, 2, $16, 0, 0, 0, 0
word_5CD3E_End

word_5CD46:	spriteHeader
	spritePiece	-$E, -4, 2, 2, $1A, 0, 0, 0, 0
word_5CD46_End

word_5CD4E:	spriteHeader
	spritePiece	-$E, -4, 2, 2, $1E, 0, 0, 0, 0
word_5CD4E_End

word_5CD56:	spriteHeader
	spritePiece	-8, -$C, 2, 3, $22, 0, 0, 0, 0
word_5CD56_End

word_5CD5E:	spriteHeader
	spritePiece	-8, -$C, 2, 3, $28, 0, 0, 0, 0
word_5CD5E_End

	even
