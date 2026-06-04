; ---------------------------------------------------------------------------
; Sprite mappings - egg robo badnik
; ---------------------------------------------------------------------------

Map_EggRoboBadnik:	mappingsTable
	dc.w 0
	mappingsTableEntry.w word_184F46
	mappingsTableEntry.w word_184F60
	mappingsTableEntry.w word_184F6E
	mappingsTableEntry.w word_184F8E
	mappingsTableEntry.w word_184F96
	mappingsTableEntry.w word_184F9E
	mappingsTableEntry.w word_184FAC

word_184F46:	spriteHeader
	spritePiece	-$14, -$18, 4, 4, 0, 0, 0, 1, 0
	spritePiece	$C, -$10, 1, 4, $10, 0, 0, 1, 0
	spritePiece	-$14, 8, 4, 1, $14, 0, 0, 1, 0
	spritePiece	-$14, $10, 3, 1, $18, 0, 0, 1, 0
word_184F46_End

word_184F60:	spriteHeader
	spritePiece	-$10, -$C, 4, 2, $1B, 0, 0, 1, 0
	spritePiece	-8, 4, 3, 1, $23, 0, 0, 1, 0
word_184F60_End

word_184F6E:	spriteHeader
	spritePiece	-$14, -$18, 4, 4, 0, 0, 0, 1, 0
	spritePiece	$C, -$10, 1, 4, $10, 0, 0, 1, 0
	spritePiece	-$14, 8, 4, 1, $14, 0, 0, 1, 0
	spritePiece	-$14, $10, 3, 1, $18, 0, 0, 1, 0
	spritePiece	4, 8, 3, 3, $26, 0, 0, 0, 0
word_184F6E_End

word_184F8E:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, $2F, 0, 0, 1, 0
word_184F8E_End

word_184F96:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, $38, 0, 0, 1, 0
word_184F96_End

word_184F9E:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, $41, 0, 0, 1, 0
	spritePiece	-4, $C, 1, 1, $4A, 0, 0, 1, 0
word_184F9E_End

word_184FAC:	spriteHeader
	spritePiece	-$20, -4, 4, 1, $4B, 0, 0, 1, 0
	spritePiece	0, -4, 4, 1, $4B, 1, 0, 1, 0
word_184FAC_End

	even
