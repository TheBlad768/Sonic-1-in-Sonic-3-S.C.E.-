; ---------------------------------------------------------------------------
; Sprite mappings - Ball Hog enemy (SBZ)
; ---------------------------------------------------------------------------

Map_BallHog:	mappingsTable
	mappingsTableEntry.w Map_BallHog_C
	mappingsTableEntry.w Map_BallHog_1A
	mappingsTableEntry.w Map_BallHog_28
	mappingsTableEntry.w Map_BallHog_36
	mappingsTableEntry.w Map_BallHog_44
	mappingsTableEntry.w Map_BallHog_4C

Map_BallHog_C:	spriteHeader
	spritePiece	-$C, -$11, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$C, -1, 3, 3, 6, 0, 0, 0, 0
Map_BallHog_C_End

Map_BallHog_1A:	spriteHeader
	spritePiece	-$C, -$11, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$C, -1, 3, 3, $F, 0, 0, 0, 0
Map_BallHog_1A_End

Map_BallHog_28:	spriteHeader
	spritePiece	-$C, -$C, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$C, 4, 3, 2, $18, 0, 0, 0, 0
Map_BallHog_28_End

Map_BallHog_36:	spriteHeader
	spritePiece	-$C, -$1C, 3, 2, 0, 0, 0, 0, 0
	spritePiece	-$C, -$C, 3, 3, $1E, 0, 0, 0, 0
Map_BallHog_36_End

Map_BallHog_44:	spriteHeader
	spritePiece	-8, -8, 2, 2, $27, 0, 0, 0, 0
Map_BallHog_44_End

Map_BallHog_4C:	spriteHeader
	spritePiece	-8, -8, 2, 2, $2B, 0, 0, 0, 0
Map_BallHog_4C_End

		even
