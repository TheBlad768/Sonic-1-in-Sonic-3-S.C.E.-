; ---------------------------------------------------------------------------
; Sprite mappings - blocks (LZ)
; ---------------------------------------------------------------------------

Map_LabyrinthBlock:	mappingsTable
	mappingsTableEntry.w Map_LabyrinthBlock_8
	mappingsTableEntry.w Map_LabyrinthBlock_10
	mappingsTableEntry.w Map_LabyrinthBlock_1E
	mappingsTableEntry.w Map_LabyrinthBlock_26

Map_LabyrinthBlock_8:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 0
Map_LabyrinthBlock_8_End

Map_LabyrinthBlock_10:	spriteHeader
	spritePiece	-$20, -$C, 4, 3, $69, 0, 0, 0, 0
	spritePiece	0, -$C, 4, 3, $75, 0, 0, 0, 0
Map_LabyrinthBlock_10_End

Map_LabyrinthBlock_1E:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $81, 0, 0, 0, 0
Map_LabyrinthBlock_1E_End

Map_LabyrinthBlock_26:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $5FA, 1, 1, 3, 1
Map_LabyrinthBlock_26_End

		even
