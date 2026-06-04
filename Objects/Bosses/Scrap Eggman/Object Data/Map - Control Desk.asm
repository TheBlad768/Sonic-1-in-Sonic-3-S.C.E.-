; ---------------------------------------------------------------------------
; Sprite mappings - scrap control desk (SBZ)
; ---------------------------------------------------------------------------

Map_ScrapControlDesk:	mappingsTable
	mappingsTableEntry.w Map_ScrapControlDesk_4
	mappingsTableEntry.w Map_ScrapControlDesk_12

Map_ScrapControlDesk_4:	spriteHeader
	spritePiece	-$C, -$14, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$C, 4, 3, 2, 9, 0, 0, 0, 0
Map_ScrapControlDesk_4_End

Map_ScrapControlDesk_12:	spriteHeader
	spritePiece	-$C, -$14, 3, 3, $F, 0, 0, 0, 0
	spritePiece	-$C, 4, 3, 2, $18, 0, 0, 0, 0
Map_ScrapControlDesk_12_End

	even
