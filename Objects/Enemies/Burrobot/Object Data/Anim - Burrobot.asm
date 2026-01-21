; ---------------------------------------------------------------------------
; Animation script - Burrobot enemy
; ---------------------------------------------------------------------------

Ani_Burro: offsetTable
		offsetTableEntry.w .walk1	; 0
		offsetTableEntry.w .walk2	; 1
		offsetTableEntry.w .digging	; 2
		offsetTableEntry.w .fall	; 3

.walk1		dc.b 3, 0, 5, afEnd
.walk2		dc.b 3, 0, 1, afEnd
.digging	dc.b 3, 2, 3, afEnd
.fall		dc.b 3, 4, afEnd
	even
