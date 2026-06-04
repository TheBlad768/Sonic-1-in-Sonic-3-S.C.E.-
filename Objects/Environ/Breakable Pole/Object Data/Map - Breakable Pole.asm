; ---------------------------------------------------------------------------
; Sprite mappings - pole that breaks (LZ)
; ---------------------------------------------------------------------------

Map_BreakablePole:	mappingsTable
	mappingsTableEntry.w Map_BreakablePole_4
	mappingsTableEntry.w Map_BreakablePole_12

Map_BreakablePole_4:	spriteHeader
	spritePiece	-4, -$20, 1, 4, 0, 0, 0, 0, 0
	spritePiece	-4, 0, 1, 4, 0, 0, 1, 0, 0
Map_BreakablePole_4_End

Map_BreakablePole_12:	spriteHeader
	spritePiece	-4, -$20, 1, 2, 0, 0, 0, 0, 0
	spritePiece	-4, -$10, 2, 2, 4, 0, 0, 0, 0
	spritePiece	-4, 0, 2, 2, 4, 0, 1, 0, 0
	spritePiece	-4, $10, 1, 2, 0, 0, 1, 0, 0
Map_BreakablePole_12_End

		even
