; ---------------------------------------------------------------------------
; Sprite mappings - Jaws enemy (LZ)
; ---------------------------------------------------------------------------

Map_Jaws:	mappingsTable
	mappingsTableEntry.w Map_Jaws_8
	mappingsTableEntry.w Map_Jaws_16
	mappingsTableEntry.w Map_Jaws_24
	mappingsTableEntry.w Map_Jaws_32

Map_Jaws_8:	spriteHeader
	spritePiece	-$10, -$C, 4, 3, 0, 0, 0, 0, 0
	spritePiece	$10, -$B, 2, 2, $18, 0, 0, 0, 0
Map_Jaws_8_End

Map_Jaws_16:	spriteHeader
	spritePiece	-$10, -$C, 4, 3, $C, 0, 0, 0, 0
	spritePiece	$10, -$B, 2, 2, $1C, 0, 0, 0, 0
Map_Jaws_16_End

Map_Jaws_24:	spriteHeader
	spritePiece	-$10, -$C, 4, 3, 0, 0, 0, 0, 0
	spritePiece	$10, -$B, 2, 2, $18, 0, 1, 0, 0
Map_Jaws_24_End

Map_Jaws_32:	spriteHeader
	spritePiece	-$10, -$C, 4, 3, $C, 0, 0, 0, 0
	spritePiece	$10, -$B, 2, 2, $1C, 0, 1, 0, 0
Map_Jaws_32_End

		even
