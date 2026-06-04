; ---------------------------------------------------------------------------
; Sprite mappings - gargoyle head (LZ)
; ---------------------------------------------------------------------------

Map_Gargoyle:	mappingsTable
	mappingsTableEntry.w Map_Gargoyle_8
	mappingsTableEntry.w Map_Gargoyle_8
	mappingsTableEntry.w Map_Gargoyle_30
	mappingsTableEntry.w Map_Gargoyle_38

Map_Gargoyle_8:	spriteHeader
	spritePiece	0, -$10, 2, 1, 0, 0, 0, 0, 0
	spritePiece	-$10, -8, 4, 2, 2, 0, 0, 0, 0
	spritePiece	-8, 8, 3, 1, $A, 0, 0, 0, 0
Map_Gargoyle_8_End

Map_Gargoyle_30:	spriteHeader
	spritePiece	-8, -4, 2, 1, $D, 0, 0, 0, 0
Map_Gargoyle_30_End

Map_Gargoyle_38:	spriteHeader
	spritePiece	-8, -4, 2, 1, $F, 0, 0, 0, 0
Map_Gargoyle_38_End

		even
