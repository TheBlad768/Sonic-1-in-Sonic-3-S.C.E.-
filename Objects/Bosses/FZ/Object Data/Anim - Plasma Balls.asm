; ---------------------------------------------------------------------------
; Animation script - Plasma balls (FZ)
; ---------------------------------------------------------------------------

Ani_Plasma: offsetTable
		offsetTableEntry.w .full	; 0
		offsetTableEntry.w .short	; 1

.full		dc.b 1, 0, $A, 8, $A, 1, $A, 9, $A, 6, $A, 7, $A, 0, $A
		dc.b 8, $A, 1, $A, 9, $A, 6, $A, 7, $A, 2, $A, 3, $A, 4
		dc.b $A, 5, afEnd
.short		dc.b 0, 6, 5, 1, 5, 7, 5, 1, 5, afEnd
	even
