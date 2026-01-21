; ---------------------------------------------------------------------------
; Animation script - spinning platforms (SBZ)
; ---------------------------------------------------------------------------

Ani_Spin: offsetTable
		offsetTableEntry.w .spin1	; 0

.spin1		dc.b 1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, $A, $B, $C, $D, $E, $F, 0, afBack, 1
	even
