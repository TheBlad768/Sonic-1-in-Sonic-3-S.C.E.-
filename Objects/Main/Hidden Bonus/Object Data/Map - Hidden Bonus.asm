; ---------------------------------------------------------------------------
; Sprite mappings - hidden points at the end of a level
; ---------------------------------------------------------------------------

Map_HiddenBonus:	mappingsTable
	dc.w 0						; blank
	mappingsTableEntry.w Map_HiddenBonus_A		; 10000
	mappingsTableEntry.w Map_HiddenBonus_12		; 1000
	mappingsTableEntry.w Map_HiddenBonus_1A		; 100

Map_HiddenBonus_A:	spriteHeader
	spritePiece	-$10, -$C, 4, 3, 0, 0, 0, 0, 0
Map_HiddenBonus_A_End

Map_HiddenBonus_12:	spriteHeader
	spritePiece	-$10, -$C, 4, 3, $C, 0, 0, 0, 0
Map_HiddenBonus_12_End

Map_HiddenBonus_1A:	spriteHeader
	spritePiece	-$10, -$C, 4, 3, $18, 0, 0, 0, 0
Map_HiddenBonus_1A_End

	even
