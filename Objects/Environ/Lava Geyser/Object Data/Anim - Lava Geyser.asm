; ---------------------------------------------------------------------------
; Animation script - Geyser of lava (MZ)
; ---------------------------------------------------------------------------

Ani_Geyser: offsetTable
		offsetTableEntry.w .bubble1	; 0
		offsetTableEntry.w .bubble2	; 1
		offsetTableEntry.w .end		; 2
		offsetTableEntry.w .bubble3	; 3
		offsetTableEntry.w .blank	; 4
		offsetTableEntry.w .bubble4	; 5

.bubble1	dc.b 2, 0, 1, 0, 1, 4, 5, 4, 5, afRoutine
.bubble2	dc.b 2, 2, 3, afEnd
.end		dc.b 2, 6, 7, afEnd
.bubble3	dc.b 2, 2, 3, 0, 1, 0, 1, afRoutine
.blank		dc.b $7F, $13, afEnd
.bubble4	dc.b 2, $11, $12, afEnd
	even
