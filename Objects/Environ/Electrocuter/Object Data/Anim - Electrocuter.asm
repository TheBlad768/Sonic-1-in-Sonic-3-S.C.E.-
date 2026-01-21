; ---------------------------------------------------------------------------
; Animation script - Electrocution orbs (SBZ)
; ---------------------------------------------------------------------------

Ani_Elec: offsetTable
		offsetTableEntry.w byte_161CC	; 0
		offsetTableEntry.w byte_161D0	; 1

byte_161CC:	dc.b $7F, 0, afEnd
byte_161D0:	dc.b 0, 1, 1, 1, 2, 3, 3, 4, 4, 4, 5, 5, 5, 0, afChange, 0
	even
