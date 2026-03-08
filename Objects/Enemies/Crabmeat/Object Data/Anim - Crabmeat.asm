; ---------------------------------------------------------------------------
; Animation script - Crabmeat enemy
; ---------------------------------------------------------------------------

Ani_Crabmeat: offsetTable
		offsetTableEntry.w .stand		; 0
		offsetTableEntry.w .standslope		; 1
		offsetTableEntry.w .standsloperev	; 2
		offsetTableEntry.w .walk		; 3
		offsetTableEntry.w .walkslope		; 4
		offsetTableEntry.w .walksloperev	; 5
		offsetTableEntry.w .firing		; 6

.stand			dc.b $7F, 0, afEnd
.standslope		dc.b $7F, 3, afEnd
.standsloperev		dc.b $7F, $22, afEnd
.walk			dc.b $F, 1, 4, 0, afEnd
.walkslope		dc.b $F, 4, 2, 3, afEnd
.walksloperev		dc.b $F, 1, 5, 6, afEnd
.firing			dc.b $7F, 7, afEnd
	even
