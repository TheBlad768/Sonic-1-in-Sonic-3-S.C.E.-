; ---------------------------------------------------------------------------
; Sprite mappings - spiked balls on the seesaws (SLZ)
; ---------------------------------------------------------------------------

Map_SeesawSpikeBall:
		dc.w Map_SeesawSpikeBall_4-Map_SeesawSpikeBall
		dc.w Map_SeesawSpikeBall_C-Map_SeesawSpikeBall
Map_SeesawSpikeBall_4:	dc.b 0, 1
		dc.b $F4, $A, 0, 0, $FF, $F4
Map_SeesawSpikeBall_C:	dc.b 0, 1
		dc.b $F4, $A, 0, 9, $FF, $F4
		even
