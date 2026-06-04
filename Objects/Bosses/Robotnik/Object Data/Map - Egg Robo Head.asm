; ---------------------------------------------------------------------------
; Sprite mappings - Egg Robo head (boss levels)
; ---------------------------------------------------------------------------

Map_EggRoboHead:	mappingsTable
	mappingsTableEntry.w word_681DC
	mappingsTableEntry.w word_681E4
	mappingsTableEntry.w word_681EC
	mappingsTableEntry.w word_681F4

word_681DC:	spriteHeader
	spritePiece	-$10, -8, 4, 2, 0, 0, 0, 0, 0
word_681DC_End

word_681E4:	spriteHeader
	spritePiece	-$10, -8, 4, 2, 8, 0, 0, 0, 0
word_681E4_End

word_681EC:	spriteHeader
	spritePiece	-$10, -8, 4, 2, $10, 0, 0, 0, 0
word_681EC_End

word_681F4:	spriteHeader
	spritePiece	-$10, -8, 4, 2, $18, 0, 0, 0, 0
word_681F4_End
	even
