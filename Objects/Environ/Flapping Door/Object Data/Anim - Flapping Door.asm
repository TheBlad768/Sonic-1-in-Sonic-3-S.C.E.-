; ---------------------------------------------------------------------------
; Animation script - flapping door (LZ)
; ---------------------------------------------------------------------------

Ani_Flap: offsetTable
		offsetTableEntry.w .opening	; 0
		offsetTableEntry.w .closing	; 1

.opening	dc.b 3, 0, 1, 2, afBack, 1
.closing	dc.b 3, 2, 1, 0, afBack, 1
	even
