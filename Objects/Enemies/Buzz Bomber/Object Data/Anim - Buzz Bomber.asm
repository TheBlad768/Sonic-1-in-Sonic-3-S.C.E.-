; ---------------------------------------------------------------------------
; Animation script - Buzz Bomber enemy
; ---------------------------------------------------------------------------

Ani_Buzz: offsetTable
		offsetTableEntry.w .fly1	; 0
		offsetTableEntry.w .fly2	; 1
		offsetTableEntry.w .fires	; 2

.fly1		dc.b 1, 0, 1, afEnd
.fly2		dc.b 1, 2, 3, afEnd
.fires		dc.b 1, 4, 5, afEnd
	even
