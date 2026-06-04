; ---------------------------------------------------------------------------
; Sprite mappings - switches (MZ, SYZ, LZ, SBZ)
; ---------------------------------------------------------------------------

Map_Button:	mappingsTable
	mappingsTableEntry.w Map_Button_8
	mappingsTableEntry.w Map_Button_16
	mappingsTableEntry.w Map_Button_24
	mappingsTableEntry.w Map_Button_32

Map_Button_8:	spriteHeader
	spritePiece	-$10, -$B, 2, 2, 0, 0, 0, 0, 0
	spritePiece	0, -$B, 2, 2, 0, 1, 0, 0, 0
Map_Button_8_End

Map_Button_16:	spriteHeader
	spritePiece	-$10, -$B, 2, 2, 4, 0, 0, 0, 0
	spritePiece	0, -$B, 2, 2, 4, 1, 0, 0, 0
Map_Button_16_End

Map_Button_24:	spriteHeader
	spritePiece	-$10, -$B, 2, 2, $7FC, 1, 1, 3, 1
	spritePiece	0, -$B, 2, 2, $7FC, 0, 0, 0, 0
Map_Button_24_End

Map_Button_32:	spriteHeader
	spritePiece	-$10, -$B, 2, 2, 4, 0, 0, 0, 0
	spritePiece	0, -$B, 2, 2, 4, 1, 0, 0, 0
Map_Button_32_End

		even
