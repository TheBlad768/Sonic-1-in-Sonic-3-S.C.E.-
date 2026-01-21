; ---------------------------------------------------------------------------
; Animation script - Bomb enemy
; ---------------------------------------------------------------------------

Ani_Bomb: offsetTable
		offsetTableEntry.w .stand	; 0
		offsetTableEntry.w .walk	; 1
		offsetTableEntry.w .activated	; 2

.stand		dc.b $13, 1, 0, afEnd
.walk		dc.b $13, 5, 4, 3, 2, afEnd
.activated	dc.b $13, 7, 6, afEnd
	even
