; ---------------------------------------------------------------------------
; Sprite mappings - continue sprites
; ---------------------------------------------------------------------------

Map_ContinueSprites:	mappingsTable
	mappingsTableEntry.w word_5CC5A
	mappingsTableEntry.w word_5CC6E
	mappingsTableEntry.w word_5CC82
	mappingsTableEntry.w word_5CC9C
	mappingsTableEntry.w word_5CCB6
	mappingsTableEntry.w word_5CCD0
	mappingsTableEntry.w word_5CCDE
	mappingsTableEntry.w word_5CCF2

word_5CC5A:	spriteHeader
	spritePiece	-$C, -$14, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$C, 4, 2, 2, 9, 0, 0, 0, 0
	spritePiece	4, 4, 1, 2, $D, 0, 0, 0, 0
word_5CC5A_End

word_5CC6E:	spriteHeader
	spritePiece	-$C, -$14, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$C, 4, 2, 2, $F, 0, 0, 0, 0
	spritePiece	4, 4, 1, 2, $D, 0, 0, 0, 0
word_5CC6E_End

word_5CC82:	spriteHeader
	spritePiece	-$C, -2, 3, 1, $13, 0, 0, 0, 0
	spritePiece	-$14, 6, 2, 2, $16, 0, 0, 0, 0
	spritePiece	-4, 6, 2, 2, $1A, 0, 0, 0, 0
	spritePiece	$C, 6, 1, 2, $1E, 0, 0, 0, 0
word_5CC82_End

word_5CC9C:	spriteHeader
	spritePiece	-$C, -2, 3, 1, $13, 0, 0, 0, 0
	spritePiece	-$14, 6, 2, 2, $16, 0, 0, 0, 0
	spritePiece	-4, 6, 2, 2, $20, 0, 0, 0, 0
	spritePiece	$C, 6, 1, 2, $1E, 0, 0, 0, 0
word_5CC9C_End

word_5CCB6:	spriteHeader
	spritePiece	-$C, -2, 3, 1, $13, 0, 0, 0, 0
	spritePiece	-$14, 6, 2, 2, $16, 0, 0, 0, 0
	spritePiece	-4, 6, 2, 2, $24, 0, 0, 0, 0
	spritePiece	$C, 6, 1, 2, $1E, 0, 0, 0, 0
word_5CCB6_End

word_5CCD0:	spriteHeader
	spritePiece	-$10, -$14, 3, 2, $28, 0, 0, 0, 0
	spritePiece	-$10, -4, 4, 3, $2E, 0, 0, 0, 0
word_5CCD0_End

word_5CCDE:	spriteHeader
	spritePiece	0, -$14, 1, 1, $3A, 0, 0, 0, 0
	spritePiece	-$10, -$C, 3, 2, $3B, 0, 0, 0, 0
	spritePiece	-$10, 4, 4, 2, $41, 0, 0, 0, 0
word_5CCDE_End

word_5CCF2:	spriteHeader
	spritePiece	-$18, -4, 2, 2, $49, 0, 0, 0, 0
	spritePiece	8, -4, 2, 2, $49, 0, 0, 0, 0
word_5CCF2_End

	even
