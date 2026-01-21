; ---------------------------------------------------------------------------
; Animation script - Robotnik head (boss levels)
; ---------------------------------------------------------------------------

Ani_RobotnikHead: offsetTable
		offsetTableEntry.w .normal	; 0
		offsetTableEntry.w .laugh	; 1
		offsetTableEntry.w .hurt	; 2
		offsetTableEntry.w .defeated	; 3

.normal		dc.b 5, 0, 1, afEnd
.laugh		dc.b 5, 3, 4, afEnd
.hurt		dc.b $7F, 2, afEnd
.defeated	dc.b $7F, 5, afEnd
	even
