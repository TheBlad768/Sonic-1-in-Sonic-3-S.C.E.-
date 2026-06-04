; ---------------------------------------------------------------------------
; Sprite mappings - advancing wall of lava (MZ)
; ---------------------------------------------------------------------------

Map_LavaWall:	mappingsTable
	mappingsTableEntry.w Map_LavaWall_A		; 0 (duplicate)
	mappingsTableEntry.w Map_LavaWall_A		; 1 (duplicate)
	mappingsTableEntry.w Map_LavaWall_42		; 2
	mappingsTableEntry.w Map_LavaWall_7A		; 3
	mappingsTableEntry.w Map_LavaWall_B2		; 4
	mappingsTableEntry.w Map_LavaWall_EA		; 5

Map_LavaWall_A:	spriteHeader
	spritePiece	$20, -$20, 4, 4, $60, 0, 0, 0, 0
	spritePiece	$3C, 0, 4, 4, $70, 0, 0, 0, 0
	spritePiece	$20, 0, 4, 4, $765, 1, 1, 3, 1
	spritePiece	0, -$20, 4, 4, $765, 1, 1, 3, 1
	spritePiece	0, 0, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$20, -$20, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$20, 0, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$40, -$20, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$40, 0, 4, 4, $765, 1, 1, 3, 1
Map_LavaWall_A_End

Map_LavaWall_42:	spriteHeader
	spritePiece	$20, -$20, 4, 4, $70, 0, 0, 0, 0
	spritePiece	$3C, 0, 4, 4, $80, 0, 0, 0, 0
	spritePiece	$20, 0, 4, 4, $765, 1, 1, 3, 1
	spritePiece	0, -$20, 4, 4, $765, 1, 1, 3, 1
	spritePiece	0, 0, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$20, -$20, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$20, 0, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$40, -$20, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$40, 0, 4, 4, $765, 1, 1, 3, 1
Map_LavaWall_42_End

Map_LavaWall_7A:	spriteHeader
	spritePiece	$20, -$20, 4, 4, $80, 0, 0, 0, 0
	spritePiece	$3C, 0, 4, 4, $70, 0, 0, 0, 0
	spritePiece	$20, 0, 4, 4, $765, 1, 1, 3, 1
	spritePiece	0, -$20, 4, 4, $765, 1, 1, 3, 1
	spritePiece	0, 0, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$20, -$20, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$20, 0, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$40, -$20, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$40, 0, 4, 4, $765, 1, 1, 3, 1
Map_LavaWall_7A_End

Map_LavaWall_B2:	spriteHeader
	spritePiece	$20, -$20, 4, 4, $70, 0, 0, 0, 0
	spritePiece	$3C, 0, 4, 4, $60, 0, 0, 0, 0
	spritePiece	$20, 0, 4, 4, $765, 1, 1, 3, 1
	spritePiece	0, -$20, 4, 4, $765, 1, 1, 3, 1
	spritePiece	0, 0, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$20, -$20, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$20, 0, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$40, -$20, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$40, 0, 4, 4, $765, 1, 1, 3, 1
Map_LavaWall_B2_End

Map_LavaWall_EA:	spriteHeader
	spritePiece	$20, -$20, 4, 4, $765, 1, 1, 3, 1
	spritePiece	$20, 0, 4, 4, $765, 1, 1, 3, 1
	spritePiece	0, -$20, 4, 4, $765, 1, 1, 3, 1
	spritePiece	0, 0, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$20, -$20, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$20, 0, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$40, -$20, 4, 4, $765, 1, 1, 3, 1
	spritePiece	-$40, 0, 4, 4, $765, 1, 1, 3, 1
Map_LavaWall_EA_End

		even
