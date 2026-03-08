; ---------------------------------------------------------------------------
; Animation script - Lava balls
; ---------------------------------------------------------------------------

Ani_LavaBall: offsetTable
		offsetTableEntry.w .vertical		; 0
		offsetTableEntry.w .vertcollide		; 1
		offsetTableEntry.w .horizontal		; 2
		offsetTableEntry.w .horicollide		; 3

.vertical	dc.b 5, 0, 1, 2, 3, afEnd
.vertcollide	dc.b 5, 4, afRoutine, afEnd
.horizontal	dc.b 5, 5, 6, 7, 8, afEnd
.horicollide	dc.b 5, 9, afRoutine, afEnd
	even
