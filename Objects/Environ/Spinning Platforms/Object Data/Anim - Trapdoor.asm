; ---------------------------------------------------------------------------
; Animation script - trapdoor (SBZ)
; ---------------------------------------------------------------------------

Ani_Trap: offsetTable
		offsetTableEntry.w .trapopen	; 0
		offsetTableEntry.w .trapclose	; 1

.trapopen	dc.b 3, 0, 1, 2, afBack, 1
.trapclose	dc.b 3, 2, 1, 0, afBack, 1
	even
