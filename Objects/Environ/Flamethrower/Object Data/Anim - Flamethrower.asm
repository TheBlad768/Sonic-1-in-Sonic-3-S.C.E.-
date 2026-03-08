; ---------------------------------------------------------------------------
; Animation script - Flamethrower (SBZ)
; ---------------------------------------------------------------------------

Ani_Flamethrower: offsetTable
		offsetTableEntry.w .pipe1	; 0
		offsetTableEntry.w .pipe2	; 1
		offsetTableEntry.w .valve1	; 2
		offsetTableEntry.w .valve2	; 3

.pipe1		dc.b 3, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, $A, afBack, 2
.pipe2		dc.b 0, 9, 7, 5, 3, 1, 0, afBack, 1
.valve1		dc.b 3, $B, $C, $D, $E, $F, $10, $11, $12, $13, $14, $15, afBack, 2
.valve2		dc.b 0, $14, $12, $11, $F, $D, $B, afBack, 1
	even
