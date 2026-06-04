; ---------------------------------------------------------------------------
; Sprite mappings - harpoon (LZ)
; ---------------------------------------------------------------------------

Map_Harpoon:	mappingsTable
	mappingsTableEntry.w Map_Harpoon_C
	mappingsTableEntry.w Map_Harpoon_14
	mappingsTableEntry.w Map_Harpoon_1C
	mappingsTableEntry.w Map_Harpoon_2A
	mappingsTableEntry.w Map_Harpoon_32
	mappingsTableEntry.w Map_Harpoon_3A

Map_Harpoon_C:	spriteHeader
	spritePiece	-8, -4, 2, 1, 0, 0, 0, 0, 0
Map_Harpoon_C_End

Map_Harpoon_14:	spriteHeader
	spritePiece	-8, -4, 4, 1, 2, 0, 0, 0, 0
Map_Harpoon_14_End

Map_Harpoon_1C:	spriteHeader
	spritePiece	-8, -4, 3, 1, 6, 0, 0, 0, 0
	spritePiece	$10, -4, 3, 1, 3, 0, 0, 0, 0
Map_Harpoon_1C_End

Map_Harpoon_2A:	spriteHeader
	spritePiece	-4, -8, 1, 2, 9, 0, 0, 0, 0
Map_Harpoon_2A_End

Map_Harpoon_32:	spriteHeader
	spritePiece	-4, -$18, 1, 4, $B, 0, 0, 0, 0
Map_Harpoon_32_End

Map_Harpoon_3A:	spriteHeader
	spritePiece	-4, -$28, 1, 3, $B, 0, 0, 0, 0
	spritePiece	-4, -$10, 1, 3, $F, 0, 0, 0, 0
Map_Harpoon_3A_End

		even
