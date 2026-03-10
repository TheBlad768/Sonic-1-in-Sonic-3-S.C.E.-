; ---------------------------------------------------------------------------
; Sprite mappings - spiked ball on a chain (SBZ) and big spiked ball (SYZ)
; ---------------------------------------------------------------------------

Map_BigSpikeBall:
		dc.w Map_BigSpikeBall_6-Map_BigSpikeBall, Map_BigSpikeBall_26-Map_BigSpikeBall
		dc.w Map_BigSpikeBall_2E-Map_BigSpikeBall
Map_BigSpikeBall_6:	dc.b 0, 5
		dc.b $E8, 4, 0, 0, $FF, $F8
		dc.b $F0, $F, 0, 2, $FF, $F0
		dc.b $F8, 1, 0, $12, $FF, $E8
		dc.b $F8, 1, 0, $14, 0, $10
		dc.b $10, 4, 0, $16, $FF, $F8
Map_BigSpikeBall_26:	dc.b 0, 1
		dc.b $F8, 5, 0, $20, $FF, $F8
Map_BigSpikeBall_2E:	dc.b 0, 2
		dc.b $F8, $D, 0, $18, $FF, $F0
		dc.b $E8, $D, $10, $18, $FF, $F0
		even
