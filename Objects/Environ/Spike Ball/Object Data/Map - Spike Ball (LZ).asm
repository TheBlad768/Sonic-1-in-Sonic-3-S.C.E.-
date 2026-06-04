; ---------------------------------------------------------------------------
; Sprite mappings - spiked ball on a chain (LZ)
; ---------------------------------------------------------------------------

Map_SpikeBall_LZ:	mappingsTable
	mappingsTableEntry.w Map_SpikeBall_LZ_6
	mappingsTableEntry.w Map_SpikeBall_LZ_E
	mappingsTableEntry.w Map_SpikeBall_LZ_16

Map_SpikeBall_LZ_6:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0
Map_SpikeBall_LZ_6_End

Map_SpikeBall_LZ_E:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 4, 0, 0, 0, 0
Map_SpikeBall_LZ_E_End

Map_SpikeBall_LZ_16:	spriteHeader
	spritePiece	-8, -8, 2, 2, $14, 0, 0, 0, 0
Map_SpikeBall_LZ_16_End

		even
