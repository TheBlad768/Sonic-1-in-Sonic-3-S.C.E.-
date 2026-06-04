; ---------------------------------------------------------------------------
; Sprite mappings - walking bomb enemy (SLZ, SBZ)
; ---------------------------------------------------------------------------

Map_Bomb:	mappingsTable
	mappingsTableEntry.w Map_Bomb_18
	mappingsTableEntry.w Map_Bomb_2C
	mappingsTableEntry.w Map_Bomb_40
	mappingsTableEntry.w Map_Bomb_54
	mappingsTableEntry.w Map_Bomb_68
	mappingsTableEntry.w Map_Bomb_7C
	mappingsTableEntry.w Map_Bomb_90
	mappingsTableEntry.w Map_Bomb_9E
	mappingsTableEntry.w Map_Bomb_AC
	mappingsTableEntry.w Map_Bomb_B4
	mappingsTableEntry.w Map_Bomb_BC
	mappingsTableEntry.w Map_Bomb_C4

Map_Bomb_18:	spriteHeader
	spritePiece	-$C, -$F, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$C, 9, 3, 1, $12, 0, 0, 0, 0
	spritePiece	-4, -$19, 1, 2, $21, 0, 0, 0, 0
Map_Bomb_18_End

Map_Bomb_2C:	spriteHeader
	spritePiece	-$C, -$F, 3, 3, 9, 0, 0, 0, 0
	spritePiece	-$C, 9, 3, 1, $12, 0, 0, 0, 0
	spritePiece	-4, -$19, 1, 2, $21, 0, 0, 0, 0
Map_Bomb_2C_End

Map_Bomb_40:	spriteHeader
	spritePiece	-$C, -$10, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$C, 8, 3, 1, $15, 0, 0, 0, 0
	spritePiece	-4, -$1A, 1, 2, $21, 0, 0, 0, 0
Map_Bomb_40_End

Map_Bomb_54:	spriteHeader
	spritePiece	-$C, -$F, 3, 3, 9, 0, 0, 0, 0
	spritePiece	-$C, 9, 3, 1, $18, 0, 0, 0, 0
	spritePiece	-4, -$19, 1, 2, $21, 0, 0, 0, 0
Map_Bomb_54_End

Map_Bomb_68:	spriteHeader
	spritePiece	-$C, -$10, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$C, 8, 3, 1, $1B, 0, 0, 0, 0
	spritePiece	-4, -$1A, 1, 2, $21, 0, 0, 0, 0
Map_Bomb_68_End

Map_Bomb_7C:	spriteHeader
	spritePiece	-$C, -$F, 3, 3, 9, 0, 0, 0, 0
	spritePiece	-$C, 9, 3, 1, $1E, 0, 0, 0, 0
	spritePiece	-4, -$19, 1, 2, $21, 0, 0, 0, 0
Map_Bomb_7C_End

Map_Bomb_90:	spriteHeader
	spritePiece	-$C, -$F, 3, 3, 0, 0, 0, 0, 0
	spritePiece	-$C, 9, 3, 1, $12, 0, 0, 0, 0
Map_Bomb_90_End

Map_Bomb_9E:	spriteHeader
	spritePiece	-$C, -$F, 3, 3, 9, 0, 0, 0, 0
	spritePiece	-$C, 9, 3, 1, $12, 0, 0, 0, 0
Map_Bomb_9E_End

Map_Bomb_AC:	spriteHeader
	spritePiece	-4, -$19, 1, 2, $23, 0, 0, 0, 0
Map_Bomb_AC_End

Map_Bomb_B4:	spriteHeader
	spritePiece	-4, -$19, 1, 2, $25, 0, 0, 0, 0
Map_Bomb_B4_End

Map_Bomb_BC:	spriteHeader
	spritePiece	-4, -4, 1, 1, $27, 0, 0, 0, 0
Map_Bomb_BC_End

Map_Bomb_C4:	spriteHeader
	spritePiece	-4, -4, 1, 1, $28, 0, 0, 0, 0
Map_Bomb_C4_End

		even
