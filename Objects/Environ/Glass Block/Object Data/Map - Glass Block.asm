; ---------------------------------------------------------------------------
; Sprite mappings - large green glassy blocks (MZ)
; ---------------------------------------------------------------------------

Map_GlassBlock:	mappingsTable
	mappingsTableEntry.w Map_GlassBlock_6
	mappingsTableEntry.w Map_GlassBlock_6		; multi-draw
	mappingsTableEntry.w Map_GlassBlock_50
	mappingsTableEntry.w Map_GlassBlock_5E

Map_GlassBlock_6:	spriteHeader
	spritePiece	-$20, -$48, 4, 1, 0, 0, 0, 0, 0
	spritePiece	0, -$48, 4, 1, 0, 1, 0, 0, 0
	spritePiece	-$20, -$40, 4, 4, 4, 0, 0, 0, 0
	spritePiece	0, -$40, 4, 4, 4, 1, 0, 0, 0
	spritePiece	-$20, -$20, 4, 4, 4, 0, 0, 0, 0
	spritePiece	0, -$20, 4, 4, 4, 1, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, 4, 0, 0, 0, 0
	spritePiece	0, 0, 4, 4, 4, 1, 0, 0, 0
	spritePiece	-$20, $20, 4, 4, 4, 0, 0, 0, 0
	spritePiece	0, $20, 4, 4, 4, 1, 0, 0, 0
	spritePiece	-$20, $40, 4, 1, 0, 0, 1, 0, 0
	spritePiece	0, $40, 4, 1, 0, 1, 1, 0, 0
Map_GlassBlock_6_End

Map_GlassBlock_50:	spriteHeader
	spritePiece	-$10, 8, 2, 3, $14, 0, 0, 0, 0
	spritePiece	0, 0, 2, 3, $14, 0, 0, 0, 0
Map_GlassBlock_50_End

Map_GlassBlock_5E:	spriteHeader
	spritePiece	-$20, -$38, 4, 1, 0, 0, 0, 0, 0
	spritePiece	0, -$38, 4, 1, 0, 1, 0, 0, 0
	spritePiece	-$20, -$30, 4, 4, 4, 0, 0, 0, 0
	spritePiece	0, -$30, 4, 4, 4, 1, 0, 0, 0
	spritePiece	-$20, -$10, 4, 4, 4, 0, 0, 0, 0
	spritePiece	0, -$10, 4, 4, 4, 1, 0, 0, 0
	spritePiece	-$20, $10, 4, 4, 4, 0, 0, 0, 0
	spritePiece	0, $10, 4, 4, 4, 1, 0, 0, 0
	spritePiece	-$20, $30, 4, 1, 0, 0, 1, 0, 0
	spritePiece	0, $30, 4, 1, 0, 1, 1, 0, 0
Map_GlassBlock_5E_End

		even
