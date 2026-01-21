; ---------------------------------------------------------------------------
; Sprite mappings - spiked balls on the seesaws (SLZ)
; ---------------------------------------------------------------------------

Map_SSawBall:
		dc.w Map_SSawBall_4-Map_SSawBall
		dc.w Map_SSawBall_C-Map_SSawBall
Map_SSawBall_4:	dc.b 0, 1
		dc.b $F4, $A, 0, 0, $FF, $F4
Map_SSawBall_C:	dc.b 0, 1
		dc.b $F4, $A, 0, 9, $FF, $F4
		even
