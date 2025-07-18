; ---------------------------------------------------------------------------
; Animation script - Tails on the ending sequence
; ---------------------------------------------------------------------------

Ani_ETails:
		dc.w .radiance-Ani_ETails	; "radiance" animation (emeralds)
		dc.w .looks-Ani_ETails		; looks left/right
		dc.w .leaping-Ani_ETails	; "leaping" animation (no emeralds)
		dc.w .looks2-Ani_ETails		; looks2 left/right

.radiance	dc.b 3, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 2, afRoutine
.looks		dc.b 5, 3, 5, 6, 5, 6, 5, 6, 5, afRoutine
.leaping	dc.b 3, 7, 7, 7, 8, 9, afBack, 1
.looks2		dc.b 7, 5, 6, 5, 6, 5, 6, 5, afRoutine
	even