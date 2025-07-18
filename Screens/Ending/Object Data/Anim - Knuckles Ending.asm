; ---------------------------------------------------------------------------
; Animation script - Knuckles on the ending sequence
; ---------------------------------------------------------------------------

Ani_EKnuckles:
		dc.w .radiance-Ani_EKnuckles	; "radiance" animation (emeralds)
		dc.w .looks-Ani_EKnuckles	; looks left/right
		dc.w .leaping-Ani_EKnuckles	; "leaping" animation (no emeralds)
		dc.w .looks2-Ani_EKnuckles	; looks2 left/right

.radiance	dc.b 3, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 2, afRoutine
.looks		dc.b 5, 3, 5, 6, 5, 6, 5, 6, 5, 5, 5, 7, 7, afRoutine
.leaping	dc.b 3, 8, 8, 9, $A, $B, afBack, 1
.looks2		dc.b 7, 5, 6, 5, 6, 5, 6, 5, afRoutine
	even