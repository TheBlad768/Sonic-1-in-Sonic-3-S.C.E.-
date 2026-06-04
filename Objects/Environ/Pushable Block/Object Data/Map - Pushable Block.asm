; ---------------------------------------------------------------------------
; Sprite mappings - pushable blocks (MZ, LZ)
; ---------------------------------------------------------------------------

Map_PushableBlock:	mappingsTable
	mappingsTableEntry.w Map_PushableBlock_4
	mappingsTableEntry.w Map_PushableBlock_C

Map_PushableBlock_4:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 8, 0, 0, 0, 0
Map_PushableBlock_4_End

Map_PushableBlock_C:	spriteHeader
	spritePiece	-$40, -$10, 4, 4, 8, 0, 0, 0, 0
	spritePiece	-$20, -$10, 4, 4, 8, 0, 0, 0, 0
	spritePiece	0, -$10, 4, 4, 8, 0, 0, 0, 0
	spritePiece	$20, -$10, 4, 4, 8, 0, 0, 0, 0
Map_PushableBlock_C_End

		even
