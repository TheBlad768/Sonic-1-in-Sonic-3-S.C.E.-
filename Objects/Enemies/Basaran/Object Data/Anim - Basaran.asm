; ---------------------------------------------------------------------------
; Animation script - Basaran enemy
; ---------------------------------------------------------------------------

Ani_Basaran: offsetTable
		offsetTableEntry.w .still	; 0
		offsetTableEntry.w .fall	; 1
		offsetTableEntry.w .fly		; 2

.still		dc.b $7F, 0, afEnd
.fall		dc.b $7F, 1, afEnd
.fly		dc.b 3, 1, 2, 3, 2, afEnd
	even
