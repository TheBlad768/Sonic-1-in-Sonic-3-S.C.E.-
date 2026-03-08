; ---------------------------------------------------------------------------
; Animation script - Motobug enemy
; ---------------------------------------------------------------------------

Ani_MotoBug: offsetTable
		offsetTableEntry.w .stand	; 0
		offsetTableEntry.w .walk	; 1
		offsetTableEntry.w .smoke	; 2

.stand		dc.b $7F, 2, afEnd
.walk		dc.b 7, 0, 1, 0, 2, afEnd
.smoke		dc.b 1, 3, 6, 3, 6, 4, 6, 4, 6, 4, 6, 5, afRoutine, afEnd
	even
