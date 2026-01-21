; ---------------------------------------------------------------------------
; Sprite mappings - scrap control desk (SBZ)
; ---------------------------------------------------------------------------

Map_ScrapControlDesk:
		dc.w Map_ScrapControlDesk_4-Map_ScrapControlDesk
		dc.w Map_ScrapControlDesk_12-Map_ScrapControlDesk
Map_ScrapControlDesk_4:
		dc.w 2
		dc.b $EC, $A, 0, 0, $FF, $F4
		dc.b 4, 9, 0, 9, $FF, $F4
Map_ScrapControlDesk_12:
		dc.w 2
		dc.b $EC, $A, 0, $F, $FF, $F4
		dc.b 4, 9, 0, $18, $FF, $F4
	even
