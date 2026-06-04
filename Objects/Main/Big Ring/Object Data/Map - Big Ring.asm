; ---------------------------------------------------------------------------
; Sprite mappings - big ring
; ---------------------------------------------------------------------------

Map_BigRing:	mappingsTable
	mappingsTableEntry.w word_619F8
	mappingsTableEntry.w word_61A00
	mappingsTableEntry.w word_61A08
	mappingsTableEntry.w word_61A10
	mappingsTableEntry.w word_61A18
	mappingsTableEntry.w word_61A20
	mappingsTableEntry.w word_61A2E
	mappingsTableEntry.w word_61A48
	mappingsTableEntry.w word_61A62
	mappingsTableEntry.w word_61A7C
	mappingsTableEntry.w word_61A96
	mappingsTableEntry.w word_61AA4

word_619F8:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0
word_619F8_End

word_61A00:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0
word_61A00_End

word_61A08:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 0, 0, 0, 0, 0
word_61A08_End

word_61A10:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 0, 0, 0, 0, 0
word_61A10_End

word_61A18:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0
word_61A18_End

word_61A20:	spriteHeader
	spritePiece	-$10, -$14, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$10, $C, 4, 1, $10, 0, 0, 0, 0
word_61A20_End

word_61A2E:	spriteHeader
	spritePiece	-$14, -$14, 3, 2, 0, 0, 0, 0, 0
	spritePiece	4, -$14, 2, 3, 6, 0, 0, 0, 0
	spritePiece	-4, 4, 3, 2, $C, 0, 0, 0, 0
	spritePiece	-$14, -4, 2, 3, $12, 0, 0, 0, 0
word_61A2E_End

word_61A48:	spriteHeader
	spritePiece	-$C, -$18, 3, 1, 0, 0, 0, 0, 0
	spritePiece	-$14, -$10, 4, 4, 3, 0, 0, 0, 0
	spritePiece	$C, -$10, 1, 4, $13, 0, 0, 0, 0
	spritePiece	-$C, $10, 3, 1, $17, 0, 0, 0, 0
word_61A48_End

word_61A62:	spriteHeader
	spritePiece	-$20, -$20, 4, 4, 0, 0, 0, 0, 0
	spritePiece	0, -$20, 4, 4, $10, 0, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, $20, 0, 0, 0, 0
	spritePiece	0, 0, 4, 4, $30, 0, 0, 0, 0
word_61A62_End

word_61A7C:	spriteHeader
	spritePiece	-$1C, -$20, 4, 4, 0, 0, 0, 0, 0
	spritePiece	4, -$20, 3, 4, $10, 0, 0, 0, 0
	spritePiece	-$1C, 0, 4, 4, $1C, 0, 0, 0, 0
	spritePiece	4, 0, 3, 4, $2C, 0, 0, 0, 0
word_61A7C_End

word_61A96:	spriteHeader
	spritePiece	-$C, -$20, 3, 4, 0, 0, 0, 0, 0
	spritePiece	-$C, 0, 3, 4, $C, 0, 0, 0, 0
word_61A96_End

word_61AA4:	spriteHeader
	spritePiece	-$1C, -$20, 4, 4, 0, 0, 0, 0, 0
	spritePiece	4, -$20, 3, 4, $10, 0, 0, 0, 0
	spritePiece	-$1C, 0, 4, 4, $1C, 0, 0, 0, 0
	spritePiece	4, 0, 3, 4, $2C, 0, 0, 0, 0
word_61AA4_End

	even
