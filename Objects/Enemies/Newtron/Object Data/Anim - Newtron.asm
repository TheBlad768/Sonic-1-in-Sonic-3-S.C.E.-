; ---------------------------------------------------------------------------
; Animation script - Newtron enemy
; ---------------------------------------------------------------------------

Ani_Newt: offsetTable
		offsetTableEntry.w .blank	; 0
		offsetTableEntry.w .drop	; 1
		offsetTableEntry.w .fly1	; 2
		offsetTableEntry.w .fly2	; 3
		offsetTableEntry.w .fires	; 4

.blank		dc.b $7F, $A, afEnd
.drop		dc.b $13, 0, 1, 3, 4, 5, afBack, 1
.fly1		dc.b 2, 6, 7, afEnd
.fly2		dc.b 2, 8, 9, afEnd
.fires		dc.b $13, 0, 1, 1, 2, 1, 1, 0, afRoutine, afEnd
	even
