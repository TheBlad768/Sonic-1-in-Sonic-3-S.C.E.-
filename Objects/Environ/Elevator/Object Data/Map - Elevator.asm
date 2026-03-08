; ---------------------------------------------------------------------------
; Sprite mappings - platforms that move when you stand on them (SLZ)
; ---------------------------------------------------------------------------

Map_Elevator:
		dc.w Map_Elevator_2-Map_Elevator
Map_Elevator_2:	dc.b 0, 3
		dc.b $F8, $F, 0, $41, $FF, $D8
		dc.b $F8, $F, 0, $41, $FF, $F8
		dc.b $F8, 7, 0, $41, 0, $18
		even
