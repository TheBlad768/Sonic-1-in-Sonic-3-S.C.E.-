; ---------------------------------------------------------------------------
; Sprite mappings - spiked balls on the seesaws (SLZ)
; ---------------------------------------------------------------------------

Map_SeesawSpikeBall:	mappingsTable
	mappingsTableEntry.w Map_SeesawSpikeBall_4
	mappingsTableEntry.w Map_SeesawSpikeBall_C

Map_SeesawSpikeBall_4:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 0, 0, 0, 0, 0
Map_SeesawSpikeBall_4_End

Map_SeesawSpikeBall_C:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, 9, 0, 0, 0, 0
Map_SeesawSpikeBall_C_End

		even
