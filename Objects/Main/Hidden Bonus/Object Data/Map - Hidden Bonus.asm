; ---------------------------------------------------------------------------
; Sprite mappings - hidden points at the end of a level
; ---------------------------------------------------------------------------

Map_HiddenBonus:
		dc.w 0										; blank
		dc.w Map_HiddenBonus_A-Map_HiddenBonus	; 10000
		dc.w Map_HiddenBonus_12-Map_HiddenBonus	; 1000
		dc.w Map_HiddenBonus_1A-Map_HiddenBonus	; 100
Map_HiddenBonus_A:
		dc.w 1
		dc.b $F4, $E, 0, 0, $FF, $F0
Map_HiddenBonus_12:
		dc.w 1
		dc.b $F4, $E, 0, $C, $FF, $F0
Map_HiddenBonus_1A:
		dc.w 1
		dc.b $F4, $E, 0, $18, $FF, $F0
	even
