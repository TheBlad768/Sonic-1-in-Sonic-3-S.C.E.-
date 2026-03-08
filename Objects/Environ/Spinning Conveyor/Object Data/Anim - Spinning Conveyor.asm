; ---------------------------------------------------------------------------
; Animation script - platform on conveyor belt (SBZ)
; ---------------------------------------------------------------------------

Ani_SpinningConveyor: offsetTable
		offsetTableEntry.w .spin	; 0
		offsetTableEntry.w .still	; 1

.spin		dc.b 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, $A, $B, $C, $D, $E, $F, 0, afEnd
.still		dc.b $7F, 0, afEnd
	even
