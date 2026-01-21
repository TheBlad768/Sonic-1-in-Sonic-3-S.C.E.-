; ---------------------------------------------------------------------------
; Animation script - Energy ball launcher (FZ)
; ---------------------------------------------------------------------------

Ani_PLaunch: offsetTable
		offsetTableEntry.w .red			; 0
		offsetTableEntry.w .redsparking		; 1
		offsetTableEntry.w .whitesparking	; 2

.red		dc.b $7F, 0, afEnd
.redsparking	dc.b 1, 0, 2, 0, 3, afEnd
.whitesparking	dc.b 1, 1, 2, 1, 3, afEnd
	even
