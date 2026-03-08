; ---------------------------------------------------------------------------
; Animation script - Chopper enemy
; ---------------------------------------------------------------------------

Ani_Chopper: offsetTable
		offsetTableEntry.w .slow	; 0
		offsetTableEntry.w .fast	; 1
		offsetTableEntry.w .still	; 2

.slow		dc.b 7, 0, 1, afEnd
.fast		dc.b 3, 0, 1, afEnd
.still		dc.b $7F, 0, afEnd
	even
