; ---------------------------------------------------------------------------
; Animation script - Egg Robo head (boss levels)
; ---------------------------------------------------------------------------

Ani_EggRoboHead: offsetTable
		offsetTableEntry.w .normal	; 0
		offsetTableEntry.w .laugh	; 1
		offsetTableEntry.w .hurt	; 2
		offsetTableEntry.w .defeated	; 3

.normal		dc.b $F, 0, 1, afEnd
.laugh		dc.b 3, 0, 1, afEnd
.hurt		dc.b $7F, 2, afEnd
.defeated	dc.b $7F, 3, afEnd
	even
