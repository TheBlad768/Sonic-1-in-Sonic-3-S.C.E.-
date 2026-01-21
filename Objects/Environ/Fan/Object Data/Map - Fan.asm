; ---------------------------------------------------------------------------
; Sprite mappings - fans (SLZ)
; ---------------------------------------------------------------------------

Map_Fan:
		dc.w Map_Fan_A-Map_Fan, Map_Fan_18-Map_Fan
		dc.w Map_Fan_26-Map_Fan, Map_Fan_34-Map_Fan
		dc.w Map_Fan_42-Map_Fan
Map_Fan_A:	dc.b 0, 2
		dc.b $F0, 9, 0, 0, $FF, $F8
		dc.b 0, $D, 0, 6, $FF, $F0
Map_Fan_18:	dc.b 0, 2
		dc.b $F0, $D, 0, $E, $FF, $F0
		dc.b 0, $D, 0, $16, $FF, $F0
Map_Fan_26:	dc.b 0, 2
		dc.b $F0, $D, 0, $1E, $FF, $F0
		dc.b 0, 9, 0, $26, $FF, $F8
Map_Fan_34:	dc.b 0, 2
		dc.b $F0, $D, 0, $E, $FF, $F0
		dc.b 0, $D, 0, $16, $FF, $F0
Map_Fan_42:	dc.b 0, 2
		dc.b $F0, 9, 0, 0, $FF, $F8
		dc.b 0, $D, 0, 6, $FF, $F0
		even
