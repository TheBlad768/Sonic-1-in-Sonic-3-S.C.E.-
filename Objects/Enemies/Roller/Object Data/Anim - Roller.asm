; ---------------------------------------------------------------------------
; Animation script - Roller enemy
; ---------------------------------------------------------------------------

Ani_Roll: offsetTable
		offsetTableEntry.w .unfold	; 0
		offsetTableEntry.w .fold	; 1
		offsetTableEntry.w .roll	; 2

.unfold		dc.b $F, 2, 1, 0, afBack, 1
.fold		dc.b $F, 1, 2, afChange, 2
.roll		dc.b 3, 3, 4, 2, afEnd
	even
