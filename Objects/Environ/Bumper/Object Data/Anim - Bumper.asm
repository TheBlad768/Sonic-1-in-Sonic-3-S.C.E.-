; ---------------------------------------------------------------------------
; Animation script - Bumper
; ---------------------------------------------------------------------------

Ani_Bump: offsetTable
		offsetTableEntry.w byte_EAF4	; 0
		offsetTableEntry.w byte_EAF8	; 1

byte_EAF4:	dc.b $7F, 0, afEnd
byte_EAF8:	dc.b 3, 1, 0, 1, 0, 1, afChange, 0
	even
