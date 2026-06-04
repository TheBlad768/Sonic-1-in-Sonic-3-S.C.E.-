; ---------------------------------------------------------------------------
; Sprite mappings - Basaran enemy (MZ)
; ---------------------------------------------------------------------------

Map_Basaran:	mappingsTable
	mappingsTableEntry.w SME_u9kpk_8
	mappingsTableEntry.w SME_u9kpk_10
	mappingsTableEntry.w SME_u9kpk_24
	mappingsTableEntry.w SME_u9kpk_3E

SME_u9kpk_8:	spriteHeader
	spritePiece	-8, -$C, 2, 3, 0, 0, 0, 0, 0
SME_u9kpk_8_End

SME_u9kpk_10:	spriteHeader
	spritePiece	-$C, -$E, 4, 3, 6, 0, 0, 0, 0
	spritePiece	-4, $A, 2, 1, $12, 0, 0, 0, 0
	spritePiece	$C, 2, 1, 1, $27, 0, 0, 0, 0
SME_u9kpk_10_End

SME_u9kpk_24:	spriteHeader
	spritePiece	-8, -8, 2, 1, $14, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 1, $16, 0, 0, 0, 0
	spritePiece	0, 8, 2, 1, $1A, 0, 0, 0, 0
	spritePiece	$C, 0, 1, 1, $28, 0, 0, 0, 0
SME_u9kpk_24_End

SME_u9kpk_3E:	spriteHeader
	spritePiece	-$B, -$A, 3, 2, $1C, 0, 0, 0, 0
	spritePiece	-$C, 6, 3, 1, $22, 0, 0, 0, 0
	spritePiece	-$C, $E, 2, 1, $25, 0, 0, 0, 0
	spritePiece	$C, -2, 1, 1, $27, 0, 0, 0, 0
SME_u9kpk_3E_End

		even
