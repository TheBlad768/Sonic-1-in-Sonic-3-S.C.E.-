; ---------------------------------------------------------------------------
; Animation script - Orbinaut enemy
; ---------------------------------------------------------------------------

Ani_Orbinaut: offsetTable
		offsetTableEntry.w .normal	; 0
		offsetTableEntry.w .angers	; 1

.normal		dc.b $7F, 0, afEnd
.angers		dc.b $F, 1, 2, afBack, 1
	even
