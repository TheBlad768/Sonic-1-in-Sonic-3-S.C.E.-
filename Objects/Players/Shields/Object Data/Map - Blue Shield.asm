; ---------------------------------------------------------------------------
; Sprite mappings - Blue Shield
; ---------------------------------------------------------------------------

Map_BlueShield:	mappingsTable
	mappingsTableEntry.w Map_BlueShield_C
	mappingsTableEntry.w Map_BlueShield_C
	mappingsTableEntry.w Map_BlueShield_C
	mappingsTableEntry.w Map_BlueShield_C
	mappingsTableEntry.w Map_BlueShield_C
	mappingsTableEntry.w Map_BlueShield_26

Map_BlueShield_C:	spriteHeader
	spritePiece	-$10, -$10, 2, 2, 0, 0, 0, 0, 0
	spritePiece	0, -$10, 2, 2, 0, 1, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, 0, 0, 1, 0, 0
	spritePiece	0, 0, 2, 2, 0, 1, 1, 0, 0
Map_BlueShield_C_End

Map_BlueShield_26:	spriteHeader
	spritePiece	-$18, -$20, 3, 4, 0, 0, 0, 0, 0
	spritePiece	0, -$20, 3, 4, 0, 1, 0, 0, 0
	spritePiece	-$18, 0, 3, 4, 0, 0, 1, 0, 0
	spritePiece	0, 0, 3, 4, 0, 1, 1, 0, 0
Map_BlueShield_26_End

	even
