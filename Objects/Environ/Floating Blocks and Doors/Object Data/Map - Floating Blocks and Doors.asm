; ---------------------------------------------------------------------------
; Sprite mappings - moving blocks (SYZ/SLZ/LZ)
; ---------------------------------------------------------------------------

Map_FloatingBlock:	mappingsTable
	mappingsTableEntry.w Map_FloatingBlock_10
	mappingsTableEntry.w Map_FloatingBlock_18
	mappingsTableEntry.w Map_FloatingBlock_32
	mappingsTableEntry.w Map_FloatingBlock_40
	mappingsTableEntry.w Map_FloatingBlock_5A
	mappingsTableEntry.w Map_FloatingBlock_6E
	mappingsTableEntry.w Map_FloatingBlock_76
	mappingsTableEntry.w Map_FloatingBlock_84

Map_FloatingBlock_10:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $31, 0, 0, 0, 0
Map_FloatingBlock_10_End

Map_FloatingBlock_18:	spriteHeader
	spritePiece	-$20, -$20, 4, 4, $31, 0, 0, 0, 0
	spritePiece	0, -$20, 4, 4, $31, 0, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, $31, 0, 0, 0, 0
	spritePiece	0, 0, 4, 4, $31, 0, 0, 0, 0
Map_FloatingBlock_18_End

Map_FloatingBlock_32:	spriteHeader
	spritePiece	-$10, -$20, 4, 4, $31, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 4, $31, 0, 0, 0, 0
Map_FloatingBlock_32_End

Map_FloatingBlock_40:	spriteHeader
	spritePiece	-$20, -$1A, 4, 4, $51, 0, 0, 0, 0
	spritePiece	0, -$1A, 4, 4, $51, 0, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, $51, 0, 0, 0, 0
	spritePiece	0, 0, 4, 4, $51, 0, 0, 0, 0
Map_FloatingBlock_40_End

Map_FloatingBlock_5A:	spriteHeader
	spritePiece	-$10, -$27, 4, 4, $51, 0, 0, 0, 0
	spritePiece	-$10, -$D, 4, 4, $51, 0, 0, 0, 0
	spritePiece	-$10, $D, 4, 4, $51, 0, 0, 0, 0
Map_FloatingBlock_5A_End

Map_FloatingBlock_6E:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $21, 0, 0, 0, 0
Map_FloatingBlock_6E_End

Map_FloatingBlock_76:	spriteHeader
	spritePiece	-8, -$20, 2, 4, 0, 0, 0, 0, 0
	spritePiece	-8, 0, 2, 4, 0, 0, 1, 0, 0
Map_FloatingBlock_76_End

Map_FloatingBlock_84:	spriteHeader
	spritePiece	-$40, -$10, 4, 4, $22, 0, 0, 0, 0
	spritePiece	-$20, -$10, 4, 4, $22, 0, 0, 0, 0
	spritePiece	0, -$10, 4, 4, $22, 0, 0, 0, 0
	spritePiece	$20, -$10, 4, 4, $22, 0, 0, 0, 0
Map_FloatingBlock_84_End

		even
