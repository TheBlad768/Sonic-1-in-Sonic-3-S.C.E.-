; ---------------------------------------------------------------------------
; Sprite mappings - Burrobot enemy (LZ)
; ---------------------------------------------------------------------------

Map_Burrobot:	mappingsTable
	mappingsTableEntry.w Map_Burrobot_C
	mappingsTableEntry.w Map_Burrobot_1A
	mappingsTableEntry.w Map_Burrobot_28
	mappingsTableEntry.w Map_Burrobot_36
	mappingsTableEntry.w Map_Burrobot_44
	mappingsTableEntry.w Map_Burrobot_52

Map_Burrobot_C:	spriteHeader
	spritePiece	-$10, -$14, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$C, 4, 3, 2, 9, 0, 0, 0, 0
Map_Burrobot_C_End

Map_Burrobot_1A:	spriteHeader
	spritePiece	-$10, -$14, 3, 3, $F, 0, 0, 0, 0
	spritePiece	-$C, 4, 3, 2, $18, 0, 0, 0, 0
Map_Burrobot_1A_End

Map_Burrobot_28:	spriteHeader
	spritePiece	-$C, -$18, 3, 3, $1E, 0, 0, 0, 0
	spritePiece	-$C, 0, 3, 3, $27, 0, 0, 0, 0
Map_Burrobot_28_End

Map_Burrobot_36:	spriteHeader
	spritePiece	-$C, -$18, 3, 3, $30, 0, 0, 0, 0
	spritePiece	-$C, 0, 3, 3, $39, 0, 0, 0, 0
Map_Burrobot_36_End

Map_Burrobot_44:	spriteHeader
	spritePiece	-$10, -$18, 3, 3, $F, 0, 0, 0, 0
	spritePiece	-$C, 0, 3, 3, $42, 0, 0, 0, 0
Map_Burrobot_44_End

Map_Burrobot_52:	spriteHeader
	spritePiece	-$10, -$14, 3, 3, $F, 0, 0, 0, 0
	spritePiece	-$C, 4, 3, 2, 9, 0, 0, 0, 0
Map_Burrobot_52_End

	even
