; ---------------------------------------------------------------------------
; Animation script - Yadrin enemy
; ---------------------------------------------------------------------------

Ani_Yad: offsetTable
		offsetTableEntry.w .stand	; 0
		offsetTableEntry.w .walk	; 1

.stand		dc.b $7F, 0, afEnd
.walk		dc.b 7, 0, 3, 1, 4, 0, 3, 2, 5, afEnd
	even
