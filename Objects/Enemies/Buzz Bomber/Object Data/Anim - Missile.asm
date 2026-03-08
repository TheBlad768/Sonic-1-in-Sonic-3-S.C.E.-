; ---------------------------------------------------------------------------
; Animation script - Missile that Buzz Bomber throws
; ---------------------------------------------------------------------------

Ani_Missile: offsetTable
		offsetTableEntry.w .flare	; 0
		offsetTableEntry.w .missile	; 1

.flare		dc.b 7, 0, 1, afRoutine, afEnd
.missile	dc.b 1, 2, 3, afEnd
	even
