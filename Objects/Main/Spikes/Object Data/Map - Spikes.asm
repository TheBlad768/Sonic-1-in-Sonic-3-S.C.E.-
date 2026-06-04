; ---------------------------------------------------------------------------
; Sprite mappings - spikes
; ---------------------------------------------------------------------------

Map_Spikes:	mappingsTable
	mappingsTableEntry.w SME_TXTT9_C
	mappingsTableEntry.w SME_TXTT9_20
	mappingsTableEntry.w SME_TXTT9_34
	mappingsTableEntry.w SME_TXTT9_3C
	mappingsTableEntry.w SME_TXTT9_50
	mappingsTableEntry.w SME_TXTT9_76

SME_TXTT9_C:	spriteHeader
	spritePiece	-$14, -$10, 1, 4, 8, 0, 0, 0, 0
	spritePiece	-4, -$10, 1, 4, $C, 0, 0, 0, 0
	spritePiece	$C, -$10, 1, 4, 8, 0, 0, 0, 0
SME_TXTT9_C_End

SME_TXTT9_20:	spriteHeader
	spritePiece	-$10, -$14, 4, 1, 0, 1, 0, 0, 0
	spritePiece	-$10, -4, 4, 1, 4, 1, 0, 0, 0
	spritePiece	-$10, $C, 4, 1, 0, 1, 0, 0, 0
SME_TXTT9_20_End

SME_TXTT9_34:	spriteHeader
	spritePiece	-4, -$10, 1, 4, 8, 0, 0, 0, 0
SME_TXTT9_34_End

SME_TXTT9_3C:	spriteHeader
	spritePiece	-$1C, -$10, 1, 4, 8, 0, 0, 0, 0
	spritePiece	-4, -$10, 1, 4, $C, 0, 0, 0, 0
	spritePiece	$14, -$10, 1, 4, 8, 0, 0, 0, 0
SME_TXTT9_3C_End

SME_TXTT9_50:	spriteHeader
	spritePiece	-$40, -$10, 1, 4, 8, 0, 0, 0, 0
	spritePiece	-$28, -$10, 1, 4, $C, 0, 0, 0, 0
	spritePiece	-$10, -$10, 1, 4, 8, 0, 0, 0, 0
	spritePiece	8, -$10, 1, 4, $C, 0, 0, 0, 0
	spritePiece	$20, -$10, 1, 4, 8, 0, 0, 0, 0
	spritePiece	$38, -$10, 1, 4, $C, 0, 0, 0, 0
SME_TXTT9_50_End

SME_TXTT9_76:	spriteHeader
	spritePiece	-$10, -4, 4, 1, 0, 1, 0, 0, 0
SME_TXTT9_76_End

		even
