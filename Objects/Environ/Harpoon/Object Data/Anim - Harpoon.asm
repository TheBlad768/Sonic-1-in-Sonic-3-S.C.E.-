; ---------------------------------------------------------------------------
; Animation script - Harpoon (LZ)
; ---------------------------------------------------------------------------

Ani_Harp: offsetTable
		offsetTableEntry.w .h_extending		; 0
		offsetTableEntry.w .h_retracting	; 1
		offsetTableEntry.w .v_extending		; 2
		offsetTableEntry.w .v_retracting	; 3

.h_extending		dc.b 3, 1, 2, afRoutine
.h_retracting		dc.b 3, 1, 0, afRoutine
.v_extending		dc.b 3, 4, 5, afRoutine
.v_retracting		dc.b 3, 4, 3, afRoutine
	even
