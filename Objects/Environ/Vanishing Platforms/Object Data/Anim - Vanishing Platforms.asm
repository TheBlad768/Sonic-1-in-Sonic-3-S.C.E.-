; ---------------------------------------------------------------------------
; Animation script - vanishing platforms (SBZ)
; ---------------------------------------------------------------------------

Ani_Van: offsetTable
		offsetTableEntry.w .vanish	; 0
		offsetTableEntry.w .appear	; 1

.vanish		dc.b 7, 0, 1, 2, 3, afBack, 1
.appear		dc.b 7, 3, 2, 1, 0, afBack, 1
	even
